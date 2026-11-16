import Foundation

public enum SeedOutput {

    /// Matches the formatting of the files already in the repo, so a regenerated file only shows real changes.
    public static func encode(_ value: some Encodable) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(value) + Data("\n".utf8)
    }

    /// The entries in an existing file, or `nil` if there isn't one yet.
    public static func read<Entry: Decodable>(_ type: [Entry].Type, from url: URL) throws -> [Entry]? {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try JSONDecoder().decode(type, from: Data(contentsOf: url))
    }
}
