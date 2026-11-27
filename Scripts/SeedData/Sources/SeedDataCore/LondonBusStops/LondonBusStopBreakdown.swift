public extension LondonBusStopBuilder.Result {

    /// Counts of the stops that look unusual, so a change in TfL's or NaPTAN's data shows up in the seed summary.
    var breakdown: [String] {
        let unusualLetters = Set(stops.compactMap(\.letter).filter { $0.count > 2 || !$0.allSatisfy(\.isLetter) }).sorted()
        let localitiesByName = Dictionary(grouping: stops, by: \.name).mapValues { Set($0.compactMap(\.locality)) }
        let namesInSeveralLocalities = localitiesByName.values.filter { $0.count > 1 }.count

        return [
            "\(stops.count) stops",
            "\(stops.count { $0.stopCode == nil }) without a stop code",
            "\(stops.count { $0.towards == nil }) without \"towards\"",
            "\(stops.count { $0.letter == nil }) without a letter",
            "\(stops.count { $0.bearing == nil }) without a bearing",
            "\(stops.count(where: \.isHailAndRide)) hail and ride",
            "\(stopsNotInNaptanCount) not in NaPTAN's London data",
            "\(namesInSeveralLocalities) names shared by stops in different localities",
            "Letters other than one or two letters: \(Self.listed(unusualLetters))",
            "Stop letters treated as none: \(Self.listed(discardedLetters))",
            "Left out \(stopsWithoutRoutesCount) stops without bus routes",
            "Left out \(incompleteStopPointNames.count) stops missing an ID, name or location"
        ]
    }

    private static func listed(_ values: [String]) -> String {
        values.isEmpty ? "none" : values.map { "`\($0)`" }.joined(separator: ", ")
    }
}
