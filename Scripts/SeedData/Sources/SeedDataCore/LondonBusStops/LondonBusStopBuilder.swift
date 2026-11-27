import Foundation

public enum LondonBusStopBuilder {

    public struct Result: Equatable, Sendable {
        public let stops: [LondonBusStop]
        /// Names of the TfL stops left out for missing an ID, name or location.
        public let incompleteStopPointNames: [String]
        public let stopsWithoutRoutesCount: Int
        /// Stops with no NaPTAN row, so no stop code, locality or hail and ride flag: mostly those outside London.
        public let stopsNotInNaptanCount: Int
        /// TfL stop letters that aren't letters, e.g. "->N" or "E-bound", which the stops are given none for.
        public let discardedLetters: [String]
    }

    static let busStopType = "NaptanPublicBusCoachTram"
    static let maximumLetterLength = 4

    /// One stop per NaPTAN ID: TfL's bus stops that have bus routes, with NaPTAN's stop code, locality and bearing.
    ///
    /// A stop pair lists its stops as children, but TfL also lists each of them on its own, so only the top-level
    /// stops are read.
    public static func build(stopPoints: [TfLStopPoint], naptanStops: [NaptanStop]) -> Result {
        let naptanStopsByID = Dictionary(naptanStops.map { ($0.atcoCode, $0) }, uniquingKeysWith: { first, _ in first })
        var incompleteStopPointNames: [String] = []
        var stopsWithoutRoutesCount = 0
        var stopsNotInNaptanCount = 0
        var discardedLetters: Set<String> = []
        var stopsByID: [String: LondonBusStop] = [:]

        for stopPoint in stopPoints where stopPoint.stopType == busStopType {
            guard let id = stopPoint.naptanId,
                let commonName = stopPoint.commonName,
                let lat = stopPoint.lat,
                let lon = stopPoint.lon
            else {
                incompleteStopPointNames.append(stopPoint.commonName ?? stopPoint.naptanId ?? "(unnamed)")
                continue
            }
            let routes = busRoutes(of: stopPoint)
            guard !routes.isEmpty else {
                stopsWithoutRoutesCount += 1
                continue
            }
            guard stopsByID[id] == nil else { continue }

            let letter = stopPoint.stopLetter.flatMap(cleanedLetter)
            if let rawLetter = stopPoint.stopLetter, letter == nil {
                discardedLetters.insert(rawLetter)
            }
            let naptanStop = naptanStopsByID[id]
            if naptanStop == nil {
                stopsNotInNaptanCount += 1
            }
            stopsByID[id] = LondonBusStop(
                id: id,
                name: cleanedName(commonName),
                locality: naptanStop?.localityName,
                letter: letter,
                towards: stopPoint.additionalProperty(category: "Direction", key: "Towards").flatMap(cleanedTowards),
                stopCode: naptanStop?.naptanCode,
                stopAreaID: stopPoint.stationNaptan,
                lat: lat,
                lon: lon,
                bearing: stopPoint.additionalProperty(category: "Direction", key: "CompassPoint") ?? naptanStop?.bearing,
                isHailAndRide: naptanStop?.isHailAndRide ?? false,
                routes: routes
            )
        }

        return Result(
            stops: stopsByID.values.sorted { $0.id < $1.id },
            incompleteStopPointNames: incompleteStopPointNames.sorted(),
            stopsWithoutRoutesCount: stopsWithoutRoutesCount,
            stopsNotInNaptanCount: stopsNotInNaptanCount,
            discardedLetters: discardedLetters.sorted()
        )
    }

    /// The route names, e.g. "N63" for line `n63`, numbers first.
    static func busRoutes(of stopPoint: TfLStopPoint) -> [String] {
        let namesByLineID = Dictionary(
            (stopPoint.lines ?? []).compactMap { line in line.id.map { ($0, line.name ?? $0.uppercased()) } },
            uniquingKeysWith: { first, _ in first }
        )
        let busLineIDs = (stopPoint.lineModeGroups ?? [])
            .filter { $0.modeName == "bus" }
            .flatMap { $0.lineIdentifier ?? [] }
        let routes = Set(busLineIDs.map { namesByLineID[$0] ?? $0.uppercased() })
        return routes.sorted(by: isRouteOrderedBefore)
    }

    /// "9" < "46" < "205" < "EL1" < "N9" < "N63" < "SL6".
    static func isRouteOrderedBefore(_ lhs: String, _ rhs: String) -> Bool {
        routeSortKey(lhs) < routeSortKey(rhs)
    }

    private static func routeSortKey(_ route: String) -> (String, Int, String) {
        let prefix = route.prefix { !$0.isNumber }
        let digits = route.dropFirst(prefix.count).prefix { $0.isNumber }
        let suffix = route.dropFirst(prefix.count + digits.count)
        return (String(prefix), Int(digits) ?? 0, String(suffix))
    }

    static func cleanedName(_ name: String) -> String {
        String(collapsingSpaces(in: name).drop { $0 == "." })
    }

    static func cleanedTowards(_ towards: String) -> String? {
        let cleaned = collapsingSpaces(in: towards).replacingOccurrences(of: " Or ", with: " or ")
        return cleaned.isEmpty ? nil : cleaned
    }

    /// "Z2", "KX", "1-4" and "10A" are letters; arrows like "->N" and words like "E-bound" aren't.
    static func cleanedLetter(_ letter: String) -> String? {
        let cleaned = letter.trimmingCharacters(in: .whitespaces).uppercased()
        let isLetterLike =
            !cleaned.isEmpty
            && cleaned.count <= maximumLetterLength
            && cleaned.first != "-"
            && cleaned.allSatisfy { $0.isLetter || $0.isNumber || $0 == "-" }
        return isLetterLike ? cleaned : nil
    }

    private static func collapsingSpaces(in text: String) -> String {
        text.split(whereSeparator: \.isWhitespace).joined(separator: " ")
    }
}
