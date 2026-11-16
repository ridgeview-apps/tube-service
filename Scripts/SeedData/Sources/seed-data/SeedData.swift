import Foundation
import SeedDataCore

@main
struct SeedData {

    enum Dataset: String, CaseIterable {
        case london
        case nationalRail = "national-rail"

        var fileName: String {
            switch self {
            case .london: "londonStations.json"
            case .nationalRail: "nationalRailStations.json"
            }
        }
    }

    struct Options {
        var datasets = Dataset.allCases
        var isDryRun = false
        var allowShrink = false
        var summaryURL: URL?
    }

    /// One dataset's run: whether it passed validation, and its section of the summary.
    struct DatasetResult {
        let succeeded: Bool
        let summary: String
    }

    static let usage = """
        Usage: seed-data [--only <dataset>] [--dry-run] [--allow-shrink] [--summary <path>]

        Regenerates the app's bundled station files from live TfL data.

          --only <dataset>   Regenerate one file: \(Dataset.allCases.map(\.rawValue).joined(separator: ", "))
          --dry-run          Check the new data without writing it
          --allow-shrink     Write a file even if it lost more than \(Int(Validation.maximumShrink * 100))% of its entries
          --summary <path>   Write a Markdown summary of what changed, even if validation fails
          --help             Show this help
        """

    static func main() async {
        do {
            guard let options = try parseOptions(Array(CommandLine.arguments.dropFirst())) else {
                print(usage)
                return
            }
            let resourcesURL = try findResourcesDirectory()
            let client = TfLClient()

            var results: [DatasetResult] = []
            for dataset in options.datasets {
                do {
                    switch dataset {
                    case .london:
                        results.append(try await generateLondon(client: client, resourcesURL: resourcesURL, options: options))
                    case .nationalRail:
                        results.append(try await generateNationalRail(client: client, resourcesURL: resourcesURL, options: options))
                    }
                } catch {
                    print("error: \(error)")
                    // URLError's description is a dump of its userInfo; its localized one reads better in a PR
                    let message = (error as? URLError)?.localizedDescription ?? String(describing: error)
                    results.append(DatasetResult(succeeded: false, summary: "## \(dataset.fileName)\n\nFailed: \(message)\n"))
                }
            }
            if let summaryURL = options.summaryURL {
                let summary = (["# Station seed data", ""] + results.map(\.summary)).joined(separator: "\n")
                try Data(summary.utf8).write(to: summaryURL)
                print("Wrote summary to \(summaryURL.path)")
            }
            if results.contains(where: { !$0.succeeded }) {
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
            case "--summary":
                guard let path = remaining.popFirst() else {
                    throw UsageError("--summary needs a file path")
                }
                options.summaryURL = URL(filePath: path)
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

    static func generateLondon(client: TfLClient, resourcesURL: URL, options: Options) async throws -> DatasetResult {
        let fileURL = resourcesURL.appending(path: Dataset.london.fileName)
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
            current: currentStations,
            incompleteStopPointNames: result.incompleteStopPointNames,
            issues: issues,
            options: options
        )
    }

    static func generateNationalRail(client: TfLClient, resourcesURL: URL, options: Options) async throws -> DatasetResult {
        let fileURL = resourcesURL.appending(path: Dataset.nationalRail.fileName)
        print("Fetching national rail stations…")

        let result = NationalRailBuilder.build(from: try await client.fetchRailStations())
        let currentStopPoints = try SeedOutput.read([NationalRailStopPoint].self, from: fileURL)
        let issues = Validation.validate(result.stopPoints, currentCount: currentStopPoints?.count, allowShrink: options.allowShrink)

        return try write(
            result.stopPoints,
            to: fileURL,
            current: currentStopPoints,
            incompleteStopPointNames: result.incompleteStopPointNames,
            issues: issues,
            options: options
        )
    }

    /// Reports the run and writes the file unless there's an error or it's a dry run.
    static func write<Entry: SeedEntry & Encodable>(
        _ entries: [Entry],
        to fileURL: URL,
        current: [Entry]?,
        incompleteStopPointNames: [String],
        issues: [SeedIssue],
        options: Options
    ) throws -> DatasetResult {
        let diff = SeedDiff(old: current, new: entries)
        let summary = diff.markdown(file: fileURL.lastPathComponent, issues: issues)
        print("\(fileURL.lastPathComponent): \(diff.oldCount) → \(diff.newCount) stations")
        print("\(diff.added.count) added, \(diff.removed.count) removed, \(diff.changed.count) changed")
        print("Left out \(incompleteStopPointNames.count) TfL stop points missing an ID, ICS code, name or location")
        issues.forEach { print($0) }

        guard !issues.contains(where: { $0.severity == .error }) else {
            print("Not writing \(fileURL.lastPathComponent)")
            return DatasetResult(succeeded: false, summary: summary)
        }
        if options.isDryRun {
            print("Dry run: not writing \(fileURL.lastPathComponent)")
        } else {
            try SeedOutput.encode(entries).write(to: fileURL)
            print("Wrote \(fileURL.lastPathComponent)")
        }
        return DatasetResult(succeeded: true, summary: summary)
    }
}

struct UsageError: Error, CustomStringConvertible {
    let description: String

    init(_ description: String) {
        self.description = description
    }
}
