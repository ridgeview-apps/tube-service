import Models
import Foundation

public extension Station {

    var sortedLineIDs: [TrainLineID] {
        Set(lineGroups.flatMap { $0.lineIds }).sortedByName()
    }
}


public extension Sequence where Element == Station {

    /// Returns stations in the user's chosen `order`; any not in it (e.g. new favourites) follow alphabetically.
    func favourites(matching favourites: Set<Station.LineGroup.ID>, order: [Station.ID]) -> [Station] {
        let favouriteStations = self.favourites(matching: favourites)
        let positions = Dictionary(order.enumerated().map { ($1, $0) }, uniquingKeysWith: { first, _ in first })

        let ordered =
            favouriteStations
            .filter { positions[$0.id] != nil }
            .sorted { positions[$0.id, default: 0] < positions[$1.id, default: 0] }
        let unordered =
            favouriteStations
            .filter { positions[$0.id] == nil }
            .sortedByName()

        return ordered + unordered
    }

    func favourites(matching favourites: Set<Station.LineGroup.ID>) -> [Station] {
        return self.compactMap {
            let filteredLineGroups = $0.lineGroups.filter { favourites.contains($0.id) }
            guard !filteredLineGroups.isEmpty else {
                return nil
            }
            return Station(
                id: $0.id,
                icsCode: $0.icsCode,
                name: $0.name,
                location: $0.location,
                lineGroups: filteredLineGroups
            )
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
