import Foundation
import SeedDataCore

@main
struct SeedData {

    enum Dataset: String, CaseIterable {
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
    static func generateNationalRail(client: TfLClient, resourcesURL: URL, options: Options) async throws -> Bool {
        let fileURL = resourcesURL.appending(path: "nationalRailStations.json")
        print("Fetching national rail stations…")

        let result = NationalRailBuilder.build(from: try await client.fetchRailStations())
        let currentStopPoints = try SeedOutput.read([NationalRailStopPoint].self, from: fileURL)
        let issues = Validation.validate(result.stopPoints, currentCount: currentStopPoints?.count, allowShrink: options.allowShrink)

        print("\(fileURL.lastPathComponent): \(currentStopPoints?.count ?? 0) → \(result.stopPoints.count) stations")
        print("Left out \(result.incompleteStopPointNames.count) TfL stop points missing an ICS code, name or location")
        issues.forEach { print($0) }

        guard !issues.contains(where: { $0.severity == .error }) else {
            print("Not writing \(fileURL.lastPathComponent)")
            return false
        }
        if options.isDryRun {
            print("Dry run: not writing \(fileURL.lastPathComponent)")
        } else {
            try SeedOutput.encode(result.stopPoints).write(to: fileURL)
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
