/// Checks run on a generated file before it's written. Each returns no issues when the check passes.
public enum Validation {

    /// The most a file may shrink by between runs without `--allow-shrink`.
    public static let maximumShrink = 0.05

    // A loose box around Great Britain; anything outside it is a bad coordinate rather than a real station.
    static let ukLatitudes = 49.8...60.9
    static let ukLongitudes = -8.7...1.8

    public static func nonEmpty(_ items: [some Any], file: String) -> [SeedIssue] {
        items.isEmpty ? [.error("\(file) has no entries")] : []
    }

    public static func unique<Item>(_ items: [Item], by id: (Item) -> String, idName: String, file: String) -> [SeedIssue] {
        let duplicateIDs = Dictionary(grouping: items.map(id), by: { $0 })
            .filter { $0.value.count > 1 }
            .keys
            .sorted()

        return duplicateIDs.isEmpty ? [] : [.error("\(file) has duplicate \(idName)s: \(duplicateIDs.joined(separator: ", "))")]
    }

    public static func notShrunk(newCount: Int, currentCount: Int?, allowShrink: Bool, file: String) -> [SeedIssue] {
        guard let currentCount, currentCount > 0 else { return [] }

        let shrink = Double(currentCount - newCount) / Double(currentCount)
        guard shrink > maximumShrink else { return [] }

        let message = "\(file) would shrink from \(currentCount) to \(newCount) entries"
        return allowShrink ? [.warning(message)] : [.error("\(message) (pass --allow-shrink if that's expected)")]
    }

    public static func withinUK<Item>(_ items: [Item], coordinate: (Item) -> (lat: Double, lon: Double), name: (Item) -> String, file: String) -> [SeedIssue] {
        let namesOutsideUK = items.filter {
            let (lat, lon) = coordinate($0)
            return !ukLatitudes.contains(lat) || !ukLongitudes.contains(lon)
        }
        .map(name)

        return namesOutsideUK.isEmpty ? [] : [.error("\(file) has coordinates outside the UK: \(namesOutsideUK.joined(separator: ", "))")]
    }
}

public extension Validation {

    static func validate(
        _ stopPoints: [NationalRailStopPoint],
        currentCount: Int?,
        allowShrink: Bool,
        file: String = "nationalRailStations.json"
    ) -> [SeedIssue] {
        nonEmpty(stopPoints, file: file)
            + unique(stopPoints, by: \.naptanId, idName: "naptanId", file: file)
            + unique(stopPoints, by: \.icsCode, idName: "icsCode", file: file)
            + notShrunk(newCount: stopPoints.count, currentCount: currentCount, allowShrink: allowShrink, file: file)
            + withinUK(stopPoints, coordinate: { ($0.lat, $0.lon) }, name: \.commonName, file: file)
    }
}
