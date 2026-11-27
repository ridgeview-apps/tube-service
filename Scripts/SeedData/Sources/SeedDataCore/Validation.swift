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

    static func validate(
        _ stations: [LondonStation],
        currentCount: Int?,
        allowShrink: Bool,
        file: String = "londonStations.json"
    ) -> [SeedIssue] {
        nonEmpty(stations, file: file)
            + unique(stations, by: \.id, idName: "id", file: file)
            + notShrunk(newCount: stations.count, currentCount: currentCount, allowShrink: allowShrink, file: file)
            + withinUK(stations, coordinate: { ($0.location.lat, $0.location.lon) }, name: \.name, file: file)
            + everyKnownLineHasAStation(stations, file: file)
            + atcoCodesUsableAsFavouriteIDs(stations, file: file)
            + uniqueNames(stations, file: file)
    }

    // Stations with the same name look the same in search; give them names in LondonStationNames.renames.
    static func uniqueNames(_ stations: [LondonStation], file: String) -> [SeedIssue] {
        let duplicateNames = Dictionary(grouping: stations.map(\.name), by: { $0 })
            .filter { $0.value.count > 1 }
            .keys
            .sorted()

        return duplicateNames.isEmpty ? [] : [.warning("\(file) has stations with the same name: \(duplicateNames.joined(separator: ", "))")]
    }

    /// A line TfL returns that the app doesn't know about yet; its stations are left out until `KnownLines` catches up.
    static func unknownLines(_ lineIDs: [String]) -> [SeedIssue] {
        lineIDs.filter { !KnownLines.ids.contains($0) }
            .map { .warning("TfL has a line the app doesn't know: \($0). Add it to TrainLineID and KnownLines.ids") }
    }

    static func everyKnownLineHasAStation(_ stations: [LondonStation], file: String) -> [SeedIssue] {
        let lineIDsWithStations = Set(stations.flatMap(\.lineGroups).flatMap(\.lineIds))
        let linesWithoutStations = KnownLines.ids.filter { !lineIDsWithStations.contains($0) }

        return linesWithoutStations.isEmpty ? [] : [.error("\(file) has no stations for: \(linesWithoutStations.joined(separator: ", "))")]
    }

    // The legacy favourites migration finds a station from the ATCO code before the first "-" in a line group ID,
    // so each ATCO code must be hyphen-free and belong to one station. Mirrors StationDataTests in the Models package.
    static func atcoCodesUsableAsFavouriteIDs(_ stations: [LondonStation], file: String) -> [SeedIssue] {
        let atcoCodes = stations.flatMap(\.lineGroups).map(\.atcoCode)
        let atcoCodesWithHyphens = Set(atcoCodes.filter { $0.contains("-") }).sorted()

        let stationIDsByAtcoCode = Dictionary(
            grouping: stations.flatMap { station in station.lineGroups.map { (atcoCode: $0.atcoCode, stationID: station.id) } },
            by: \.atcoCode
        )
        let sharedAtcoCodes = stationIDsByAtcoCode.filter { Set($0.value.map(\.stationID)).count > 1 }.keys.sorted()

        var issues: [SeedIssue] = []
        if !atcoCodesWithHyphens.isEmpty {
            issues.append(.error("\(file) has ATCO codes containing \"-\": \(atcoCodesWithHyphens.joined(separator: ", "))"))
        }
        if !sharedAtcoCodes.isEmpty {
            issues.append(.error("\(file) has ATCO codes shared by more than one station: \(sharedAtcoCodes.joined(separator: ", "))"))
        }
        return issues
    }
}

public extension Validation {

    static func validate(
        _ stops: [LondonBusStop],
        currentCount: Int?,
        allowShrink: Bool,
        file: String = "londonBusStops.sql"
    ) -> [SeedIssue] {
        nonEmpty(stops, file: file)
            + unique(stops, by: \.id, idName: "id", file: file)
            + notShrunk(newCount: stops.count, currentCount: currentCount, allowShrink: allowShrink, file: file)
            + withinUK(stops, coordinate: { ($0.lat, $0.lon) }, name: \.name, file: file)
            + sharedStopCodes(stops, file: file)
    }

    // A warning rather than an error: NaPTAN itself gives a few different stops the same code.
    static func sharedStopCodes(_ stops: [LondonBusStop], file: String) -> [SeedIssue] {
        let sharedCodes = Dictionary(grouping: stops.compactMap(\.stopCode), by: { $0 })
            .filter { $0.value.count > 1 }
            .keys
            .sorted()

        return sharedCodes.isEmpty ? [] : [.warning("\(file) has \(sharedCodes.count) stop codes shared by more than one stop: \(sharedCodes.joined(separator: ", "))")]
    }
}
