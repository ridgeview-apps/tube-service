public enum NationalRailBuilder {

    public struct Result: Equatable, Sendable {
        public let stopPoints: [NationalRailStopPoint]
        /// Names of the TfL stop points left out for missing an ICS code, name or location.
        public let incompleteStopPointNames: [String]
    }

    /// One stop point per ICS code, sorted by name.
    ///
    /// Duplicates are picked before names are cleaned, as the old playground did, so the same stop point keeps winning:
    /// "Farringdon" sorts ahead of "Farringdon Rail Station".
    public static func build(from tflStopPoints: [TfLStopPoint]) -> Result {
        var incompleteStopPointNames: [String] = []
        let completeStopPoints = tflStopPoints.compactMap { tflStopPoint -> NationalRailStopPoint? in
            guard let naptanId = tflStopPoint.naptanId,
                let commonName = tflStopPoint.commonName,
                let icsCode = tflStopPoint.icsCode,
                let lat = tflStopPoint.lat,
                let lon = tflStopPoint.lon
            else {
                incompleteStopPointNames.append(tflStopPoint.commonName ?? tflStopPoint.naptanId ?? "(unnamed)")
                return nil
            }
            return NationalRailStopPoint(commonName: commonName, icsCode: icsCode, lat: lat, lon: lon, naptanId: naptanId)
        }

        var seenICSCodes: Set<String> = []
        let stopPoints =
            completeStopPoints
            .sortedByNameThenNaptanID()
            .filter { seenICSCodes.insert($0.icsCode).inserted }
            .map { stopPoint in
                NationalRailStopPoint(
                    commonName: StationNameCleaner.clean(stopPoint.commonName),
                    icsCode: stopPoint.icsCode,
                    lat: stopPoint.lat,
                    lon: stopPoint.lon,
                    naptanId: stopPoint.naptanId
                )
            }
            .sortedByNameThenNaptanID()

        return Result(stopPoints: stopPoints, incompleteStopPointNames: incompleteStopPointNames.sorted())
    }
}

private extension Sequence where Element == NationalRailStopPoint {
    func sortedByNameThenNaptanID() -> [NationalRailStopPoint] {
        sorted { ($0.commonName, $0.naptanId) < ($1.commonName, $1.naptanId) }
    }
}
