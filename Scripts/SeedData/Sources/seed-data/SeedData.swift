import Foundation
import SeedDataCore

@main
struct SeedData {

    enum Dataset: String, CaseIterable {
        case london
        case nationalRail = "national-rail"
    }

    struct Options {
        var datasets = Dataset.allCases
        var isDryRun = false
        var allowShrink = false
    }

    static let usage = """
        Usage: seed-data [--only <dataset>] [--dry-run] [--allow-shrink]

        Regenerates the app's bundled station files from live TfL data.

          --only <dataset>   Regenerate one file: \(Dataset.allCases.map(\.rawValue).joined(separator: ", "))
          --dry-run          Check the new data without writing it
          --allow-shrink     Write a file even if it lost more than \(Int(Validation.maximumShrink * 100))% of its entries
          --help             Show this help

        Set TFL_API_APP_KEY to send a TfL key (optional).
        """

    static func main() async {
        do {
            guard let options = try parseOptions(Array(CommandLine.arguments.dropFirst())) else {
                print(usage)
                return
            }
            let resourcesURL = try findResourcesDirectory()
            let client = TfLClient(appKey: ProcessInfo.processInfo.environment["TFL_API_APP_KEY"])

            var succeeded = true
            for dataset in options.datasets {
                switch dataset {
                case .london:
                    succeeded = try await generateLondon(client: client, resourcesURL: resourcesURL, options: options) && succeeded
                case .nationalRail:
                    succeeded = try await generateNationalRail(client: client, resourcesURL: resourcesURL, options: options) && succeeded
                }
            }
            if !succeeded {
                exit(1)
            }
        } catch {
            print("error: \(error)")
            exit(1)
        }
    }

    /// `nil` when the help should be shown instead of running.
    static func parseOptions(_ arguments: [String]) throws -> Options? {
        var options = Options()
        var remaining = arguments[...]

        while let argument = remaining.popFirst() {
            switch argument {
            case "--only":
                guard let value = remaining.popFirst(), let dataset = Dataset(rawValue: value) else {
                    throw UsageError("--only needs one of: \(Dataset.allCases.map(\.rawValue).joined(separator: ", "))")
                }
                options.datasets = [dataset]
            case "--dry-run":
                options.isDryRun = true
            case "--allow-shrink":
                options.allowShrink = true
            case "--help", "-h":
                return nil
            default:
                throw UsageError("unknown option \(argument)\n\n\(usage)")
            }
        }
        return options
    }

    /// Walks up from the working directory, so the tool runs from anywhere in the repo.
    static func findResourcesDirectory() throws -> URL {
        let resourcesPath = "Packages/Models/Sources/Models/Resources"
        var directory = URL(filePath: FileManager.default.currentDirectoryPath)

        while directory.path != "/" {
            let candidate = directory.appending(path: resourcesPath)
            if FileManager.default.fileExists(atPath: candidate.path) {
                return candidate
            }
            directory.deleteLastPathComponent()
        }
        throw UsageError("couldn't find \(resourcesPath); run this from inside the tube-service repo")
    }

    /// Returns `false` if validation failed and nothing was written.
    static func generateLondon(client: TfLClient, resourcesURL: URL, options: Options) async throws -> Bool {
        let fileURL = resourcesURL.appending(path: "londonStations.json")
        print("Fetching London lines…")

        let lineIDs = try await client.fetchLines(modes: KnownLines.modes).map(\.id)
        var stopPointsByLine: [[TfLStopPoint]] = []
        for lineID in KnownLines.ids where lineIDs.contains(lineID) {
            print("Fetching stop points for \(lineID)…")
            stopPointsByLine.append(try await client.fetchStopPoints(line: lineID))
        }
        print("Fetching interchanges…")
        let result = LondonStationBuilder.build(stopPointsByLine: stopPointsByLine, hubs: try await client.fetchInterchanges())

        let currentStations = try SeedOutput.read([LondonStation].self, from: fileURL)
        let issues =
            Validation.unknownLines(lineIDs)
            + result.issues
            + Validation.validate(result.stations, currentCount: currentStations?.count, allowShrink: options.allowShrink)

        return try write(
            result.stations,
            to: fileURL,
            currentCount: currentStations?.count,
            incompleteStopPointNames: result.incompleteStopPointNames,
            issues: issues,
            options: options
        )
    }

    /// Returns `false` if validation failed and nothing was written.
    static func generateNationalRail(client: TfLClient, resourcesURL: URL, options: Options) async throws -> Bool {
        let fileURL = resourcesURL.appending(path: "nationalRailStations.json")
        print("Fetching national rail stations…")

        let result = NationalRailBuilder.build(from: try await client.fetchRailStations())
        let currentStopPoints = try SeedOutput.read([NationalRailStopPoint].self, from: fileURL)
        let issues = Validation.validate(result.stopPoints, currentCount: currentStopPoints?.count, allowShrink: options.allowShrink)

        return try write(
            result.stopPoints,
            to: fileURL,
            currentCount: currentStopPoints?.count,
            incompleteStopPointNames: result.incompleteStopPointNames,
            issues: issues,
            options: options
        )
    }

    /// Reports the run and writes the file unless there's an error or it's a dry run. Returns `false` on an error.
    static func write(
        _ entries: [some Encodable],
        to fileURL: URL,
        currentCount: Int?,
        incompleteStopPointNames: [String],
        issues: [SeedIssue],
        options: Options
    ) throws -> Bool {
        print("\(fileURL.lastPathComponent): \(currentCount ?? 0) → \(entries.count) stations")
        print("Left out \(incompleteStopPointNames.count) TfL stop points missing an ID, ICS code, name or location")
        issues.forEach { print($0) }

        guard !issues.contains(where: { $0.severity == .error }) else {
            print("Not writing \(fileURL.lastPathComponent)")
            return false
        }
        if options.isDryRun {
            print("Dry run: not writing \(fileURL.lastPathComponent)")
        } else {
            try SeedOutput.encode(entries).write(to: fileURL)
            print("Wrote \(fileURL.lastPathComponent)")
        }
        return true
    }
}

struct UsageError: Error, CustomStringConvertible {
    let description: String

    init(_ description: String) {
        self.description = description
    }
}
