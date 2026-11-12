import Models
import Foundation

public extension Station {

    var sortedLineIDs: [TrainLineID] {
        Set(lineGroups.flatMap { $0.lineIds }).sortedByName()
    }
}


public extension Sequence where Element == Station {

    /// Returns the favourited stations in the order of `stops`, skipping any that can't be found.
    func favourites(matching stops: [FavouriteStop]) -> [Station] {
        let stationsByID = Dictionary(map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        return stops.compactMap { stop in
            switch stop {
            case .station(let id): stationsByID[id]
            }
        }
    }
}

public extension Sequence where Element == Station {
    func sortedByName() -> [Station] {
        self.sorted(by: { $0.name < $1.name })
    }
}

public extension Station.LineGroup {

    /// The line group's name with long line names abbreviated, e.g. "Circle, H&C, Met".
    var shortName: String {
        let lineIDs = lineIds.sortedByName()
        return lineIDs.map { $0.abbreviatedName(besideOtherLines: lineIDs.count > 1) }.joined(separator: ", ")
    }
}

extension Sequence where Element == Station.LineGroup {

    func ids(disruptedBy disruptedLines: [Line]) -> Set<Station.LineGroup.ID> {
        let disruptedLineIDs = Set(disruptedLines.map(\.id))
        return Set(filter { !disruptedLineIDs.isDisjoint(with: $0.lineIds) }.map(\.id))
    }
}

extension String {
    /// TfL starts most notices with the station's name, which only repeats the screen's title,
    /// e.g. "KENTISH TOWN UNDERGROUND STATION: The station will close…" or "Pimlico: reduced escalator service…".
    func removingStationNamePrefix(_ stationName: String) -> String {
        guard let separator = range(of: ": ") else { return self }
        let prefix = self[..<separator.lowerBound]
        let isStationName =
            prefix.uppercased().hasSuffix("STATION")
            || prefix.compare(stationName, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        return isStationName ? String(self[separator.upperBound...]) : self
    }
}

/// What the selected line group's status card says before it's expanded.
enum LineDisruptionSummary: Equatable {
    /// Every line in the group has the same status, e.g. "Minor delays".
    case status(String)
    /// Some lines in the group share a status, e.g. "Minor delays on Met".
    case statusOnLines(String, [TrainLineID])
    /// The lines have different statuses, e.g. "Disruption on Circle and Met".
    case disruptionOnLines([TrainLineID])

    init?(disruptedLines: [Line], lineGroupLineIDs: [TrainLineID]) {
        let statuses = Set(disruptedLines.map(\.shortStatusText))
        guard let status = statuses.first else { return nil }
        let disruptedLineIDs = disruptedLines.map(\.id).sortedByName()

        if statuses.count > 1 {
            self = .disruptionOnLines(disruptedLineIDs)
        } else if Set(disruptedLineIDs) == Set(lineGroupLineIDs) {
            self = .status(status)
        } else {
            self = .statusOnLines(status, disruptedLineIDs)
        }
    }

    var text: String {
        switch self {
        case .status(let status):
            status
        case .statusOnLines(let status, let lineIDs):
            String(localized: .stationStatusLineOn(status, lineIDs.shortNames))
        case .disruptionOnLines(let lineIDs):
            String(localized: .stationStatusDisruptionOn(lineIDs.shortNames))
        }
    }
}

private extension [TrainLineID] {
    var shortNames: String {
        // Only named when the selected line group has other lines too
        map { $0.abbreviatedName(besideOtherLines: true) }.formatted(.list(type: .and))
    }
}
