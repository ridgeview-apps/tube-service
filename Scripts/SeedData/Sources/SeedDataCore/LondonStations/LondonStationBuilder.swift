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
        patches: [LondonStationPatch] = LondonStationPatch.all,
        renames: [String: String] = LondonStationNames.renames
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

        for stationID in stationIDs {
            stationsByID[stationID]?.lineGroups.mergeOverlappingGroups()
        }

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

        for stationID in renames.keys.sorted() where stationsByID[stationID] == nil {
            issues.append(.warning("stale rename: no station \(stationID)"))
        }

        let stations = stationIDs.compactMap { stationsByID[$0] }
            .map { station in
                LondonStation(
                    icsCode: station.key.icsCode,
                    id: station.key.id,
                    lineGroups: station.lineGroups.sortedByLines(),
                    location: station.location,
                    name: LondonStationNames.name(forStationID: station.key.id, tfLName: station.key.name, renames: renames)
                )
            }
            .sorted { ($0.name, $0.id) < ($1.name, $1.id) }

        return Result(stations: stations, incompleteStopPointNames: incompleteStopPointNames.sorted(), issues: issues)
    }

    /// The stop point's line groups with buses and national rail operators left out, keeping TfL's line order.
    ///
    /// A group with a departure-board line is split into one group per line, so each board shows a single line.
    /// TfL's departures don't say which line a train is on, but filtering them by line ID separates them cleanly.
    private static func knownLineGroups(in stopPoint: TfLStopPoint, knownLineIDs: Set<String>) -> [LondonStation.LineGroup] {
        (stopPoint.lineGroup ?? []).flatMap { lineGroup -> [LondonStation.LineGroup] in
            let lineIDs = (lineGroup.lineIdentifier ?? []).filter(knownLineIDs.contains)
            guard let atcoCode = lineGroup.stationAtcoCode, !lineIDs.isEmpty else { return [] }

            let hasDepartureBoard = lineIDs.contains(where: KnownLines.departureBoardIDs.contains)
            guard hasDepartureBoard else { return [LondonStation.LineGroup(atcoCode: atcoCode, lineIds: lineIDs)] }
            return lineIDs.map { LondonStation.LineGroup(atcoCode: atcoCode, lineIds: [$0]) }
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

    /// Merges groups at one ATCO code that share a line, e.g. "circle" and "circle, district" become "circle,
    /// district", so no line is listed twice for the same platforms.
    mutating func mergeOverlappingGroups() {
        var mergedGroups: [LondonStation.LineGroup] = []

        for group in sortedByLines() {
            let overlappingGroups = mergedGroups.filter { mergedGroup in
                mergedGroup.atcoCode == group.atcoCode && !Set<String>(mergedGroup.lineIds).isDisjoint(with: group.lineIds)
            }
            guard !overlappingGroups.isEmpty else {
                mergedGroups.append(group)
                continue
            }

            // A merged group's line order follows KnownLines.ids; groups left alone keep TfL's order and their ID.
            let lineIDs = Set<String>(overlappingGroups.flatMap(\.lineIds) + group.lineIds)
            mergedGroups.removeAll { overlappingGroups.contains($0) }
            mergedGroups.append(LondonStation.LineGroup(atcoCode: group.atcoCode, lineIds: KnownLines.ids.filter(lineIDs.contains)))
        }

        self = Set(mergedGroups)
    }

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
