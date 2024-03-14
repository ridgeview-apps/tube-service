import Foundation
import Models

public enum JourneyLocationPicker {
    
    public enum Value: Hashable {
        case currentLocation(name: String?)
        case station(Station)
        case nationalRail(StopPoint)
        case searchResult(LocationSearchResult)
    }
    
    public enum SectionState: Hashable, Identifiable {
        public var id: Self { self }
        case userLocation(name: String?)
        case recent([Value])
        case nearbyStations([Value])
        case searchResults([Value])
        
        var values: [Value] {
            switch id {
            case let .userLocation(name):
                return [.currentLocation(name: name)]
            case let .recent(values), let .nearbyStations(values), let .searchResults(values):
                return values
            }
        }
    }

    public enum Action {
        case searchTermChanged(String)
        case valueSelected(Value)
    }
}

private extension JourneyLocationPicker.Value {
    
    typealias SortProperties = (sortValue: Int, name: String)
    
    var sortProperties: SortProperties {
        switch self {
        case .currentLocation:
            return (0, "")
        case .station(let station):
            return (1, station.name)
        case .nationalRail(let stopPoint):
            return (1, stopPoint.commonName ?? "")
        case .searchResult(let locationSearchResult):
            return (1, locationSearchResult.title)
        }
    }
}

public extension Sequence where Element == JourneyLocationPicker.Value {
    func sortedByName() -> [Element] {
        sorted {
            $0.sortProperties < $1.sortProperties
        }
    }
}
