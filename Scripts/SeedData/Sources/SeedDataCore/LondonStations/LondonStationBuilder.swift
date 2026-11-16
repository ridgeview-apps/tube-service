public enum LondonStationBuilder {

    public struct Result: Sendable {
        public let stations: [LondonStation]
        /// Names of the TfL stop points left out for missing an ID, ICS code, name or location.
        public let incompleteStopPointNames: [String]
        public let issues: [SeedIssue]
    }

    fileprivate struct StationKey {
        let id: String
        let icsCode: String
        let name: String
    }

    private struct PartialStation {
        let key: StationKey
        let location: LondonStation.Location
        var lineGroups: Set<LondonStation.LineGroup>
    }

    /// Groups each line's stop points into stations, merging stop points that share a hub such as "HUBPAD".
    ///
    /// - Parameter stopPointsByLine: each line's stop points, in a fixed line order. A station takes the location of
    ///   the first stop point seen for it, so the order decides which location wins.
    public static func build(
        stopPointsByLine: [[TfLStopPoint]],
        hubs: [TfLStopPoint],
        patches: [LondonStationPatch] = LondonStationPatch.all
    ) -> Result {
        let hubsByCode = Dictionary(
            hubs.compactMap { hub in hub.naptanId.map { ($0, hub) } },
            uniquingKeysWith: { first, _ in first }
        )
        let knownLineIDs = Set(KnownLines.ids)

        var stationIDs: [String] = []
        var stationsByID: [String: PartialStation] = [:]
        var incompleteStopPointNames: Set<String> = []
        var unknownHubCodes: Set<String> = []

        for stopPoint in stopPointsByLine.joined() {
            let lineGroups = knownLineGroups(in: stopPoint, knownLineIDs: knownLineIDs)
            guard !lineGroups.isEmpty else { continue }

            let stationKey: StationKey
            if let hubCode = stopPoint.hubNaptanCode, !hubCode.isBlank {
                guard let hub = hubsByCode[hubCode] else {
                    unknownHubCodes.insert(hubCode)
                    continue
                }
                guard let key = hub.stationKey(id: hub.naptanId) else {
                    incompleteStopPointNames.insert(hub.displayName)
                    continue
                }
                stationKey = key
            } else {
                // Some tram stops have a naptanId per platform; stationNaptan is the one the station is known by.
                let stationID = stopPoint.stationNaptan.flatMap { $0.isBlank ? nil : $0 } ?? stopPoint.naptanId
                guard let key = stopPoint.stationKey(id: stationID) else {
                    incompleteStopPointNames.insert(stopPoint.displayName)
                    continue
                }
                stationKey = key
            }

            if var station = stationsByID[stationKey.id] {
                station.lineGroups.formUnion(lineGroups)
                stationsByID[stationKey.id] = station
            } else {
                guard let lat = stopPoint.lat, let lon = stopPoint.lon else {
                    incompleteStopPointNames.insert(stopPoint.displayName)
                    continue
                }
                stationIDs.append(stationKey.id)
                stationsByID[stationKey.id] = PartialStation(
                    key: stationKey,
                    location: LondonStation.Location(lat: lat, lon: lon),
                    lineGroups: Set(lineGroups)
                )
            }
        }

        var issues = unknownHubCodes.sorted().map { SeedIssue.error("no TransportInterchange stop point for hub \($0)") }

        for patch in patches {
            guard let station = stationsByID[patch.stationID] else {
                issues.append(.warning("stale patch: no station \(patch.stationID) (\(patch.reason))"))
                continue
            }
            let patchedLineGroups = station.lineGroups.filter { !patch.removes($0) }
            if patchedLineGroups.count == station.lineGroups.count {
                issues.append(.warning("stale patch: removed nothing from \(patch.stationID) (\(patch.reason))"))
            }
            stationsByID[patch.stationID]?.lineGroups = patchedLineGroups
        }

        let stations = stationIDs.compactMap { stationsByID[$0] }
            .map { station in
                LondonStation(
                    icsCode: station.key.icsCode,
                    id: station.key.id,
                    lineGroups: station.lineGroups.sortedByLines(),
                    location: station.location,
                    name: StationNameCleaner.clean(station.key.name)
                )
            }
            .sorted { ($0.name, $0.id) < ($1.name, $1.id) }

        return Result(stations: stations, incompleteStopPointNames: incompleteStopPointNames.sorted(), issues: issues)
    }

    /// The stop point's line groups with buses and national rail operators left out, keeping TfL's line order.
    private static func knownLineGroups(in stopPoint: TfLStopPoint, knownLineIDs: Set<String>) -> [LondonStation.LineGroup] {
        (stopPoint.lineGroup ?? []).compactMap { lineGroup in
            let lineIDs = (lineGroup.lineIdentifier ?? []).filter(knownLineIDs.contains)
            guard let atcoCode = lineGroup.stationAtcoCode, !lineIDs.isEmpty else { return nil }
            return LondonStation.LineGroup(atcoCode: atcoCode, lineIds: lineIDs)
        }
    }
}

private extension TfLStopPoint {

    var displayName: String {
        commonName ?? naptanId ?? "(unnamed)"
    }

    func stationKey(id: String?) -> LondonStationBuilder.StationKey? {
        guard let id, let icsCode, let commonName else { return nil }
        return .init(id: id, icsCode: icsCode, name: commonName)
    }
}

private extension Set where Element == LondonStation.LineGroup {

    /// By line IDs, then ATCO code, so groups with the same lines always come out in the same order.
    func sortedByLines() -> [LondonStation.LineGroup] {
        sorted {
            ($0.lineIds.sorted().joined(separator: "-"), $0.atcoCode) < ($1.lineIds.sorted().joined(separator: "-"), $1.atcoCode)
        }
    }
}

private extension String {
    var isBlank: Bool {
        allSatisfy(\.isWhitespace)
    }
}
