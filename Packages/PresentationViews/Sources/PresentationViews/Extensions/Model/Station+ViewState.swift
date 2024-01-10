import Models
import Foundation

public extension Station {
    
    var sortedLineIDs: [LineID] {
        Set(lineGroups.flatMap { $0.lineIds }).sortedByName()
    }
}


public extension Sequence where Element == Station {
    
    func favourites(matching favourites: Set<Station.LineGroup.ID>) -> [Station] {
        return self.compactMap {
            let filteredLineGroups = $0.lineGroups.filter { favourites.contains($0.id) }
            guard !filteredLineGroups.isEmpty else {
                return nil
            }
            return Station(id: $0.id,
                           name: $0.name,
                           location: $0.location,
                           lineGroups: filteredLineGroups)
        }
    }
}

public extension Station.LineGroup {
    
    enum ArrivalsDataType: Equatable {
        case arrivalPredictions
        case arrivalDepartures([LineID])
    }
    
    var name: String {
        lineIds.sortedByName().map(\.name).joined(separator: ", ")
    }
    
    var arrivalsDataType: ArrivalsDataType {
        return lineIds.contains(.elizabeth) ? .arrivalDepartures(lineIds) : .arrivalPredictions
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
