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

public extension Station.LineGroup {

    var name: String {
        lineIds.sortedByName().map(\.name).joined(separator: ", ")
    }
}

public extension Sequence where Element == Station {
    func sortedByName() -> [Station] {
        self.sorted(by: { $0.name < $1.name })
    }
}

public extension Sequence where Element == Station.LineGroup {
    func sortedByName() -> [Station.LineGroup] {
        self.sorted(by: { $0.name < $1.name })
    }
}
