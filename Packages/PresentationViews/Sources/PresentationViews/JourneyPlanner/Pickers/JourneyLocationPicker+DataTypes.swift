import Foundation
import Models

public enum JourneyLocationPicker {
    
    public struct NamedLocationValue: Hashable {
        public let name: LocationName?
        public let coordinate: LocationCoordinate?
        public let isCurrentLocation: Bool
        
        public var isResolved: Bool { coordinate != nil }
        
        public init(name: LocationName?,
                    coordinate: LocationCoordinate?,
                    isCurrentLocation: Bool) {
            self.name = name
            self.coordinate = coordinate
            self.isCurrentLocation = isCurrentLocation
        }
    }
    
    public enum Value: Hashable {
        case station(Station)
        case nationalRail(StopPoint)
        case namedLocation(NamedLocationValue)
        
        public static func currentLocation(name: LocationName?, coordinate: LocationCoordinate?) -> Value {
            .namedLocation(.init(name: name, coordinate: coordinate, isCurrentLocation: true))
        }
        
        public static let unknownCurrentLocation = Value.namedLocation(.init(name: nil, coordinate: nil, isCurrentLocation: true))
    }
    
    public struct SectionState: Hashable, Identifiable {
        public enum SectionID: Hashable {
            case suggestions, nearbyStations, searchResults(count: Int)
        }
        
        public var id: SectionID { sectionID }
        
        public let sectionID: SectionID
        public let values: [Value]
        
        public static func suggestions(_ values: [Value]) -> SectionState {
            .init(sectionID: .suggestions, values: values)
        }
        
        public static func nearbyStations(_ values: [Value]) -> SectionState {
            .init(sectionID: .nearbyStations, values: values)
        }
        
        public static func searchResults(_ values: [Value]) -> SectionState {
            .init(sectionID: .searchResults(count: values.count), values: values)
        }
    }

    public enum Action {
        case searchTermChanged(String)
        case valueSelected(Value)
    }
}

extension JourneyLocationPicker.Value {
    
    var localizedTitle: String {
        switch self {
        case .station(let station):
            return station.name
        case .nationalRail(let stopPoint):
            return stopPoint.commonName ?? ""
        case .namedLocation(let location):
            if location.isCurrentLocation {
                return location.name?.formattedSingleLineTitle ?? NSLocalizedString("journey.planner.location.value.current.location", bundle: .module, comment: "")
            } else {
                return location.name?.formattedSingleLineTitle ?? ""
            }
        }
    }
}


extension LocationName {
    var formattedSingleLineTitle: String {
        [title, subtitle]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

private extension JourneyLocationPicker.Value {
    
    typealias SortProperties = (sortValue: Int, name: String)
    
    var sortProperties: SortProperties {
        switch self {
        case .station(let station):
            return (1, station.name)
        case .nationalRail(let stopPoint):
            return (1, stopPoint.commonName ?? "")
        case .namedLocation(let location):
            if location.isCurrentLocation {
                return (0, location.name?.title ?? "")
            } else {
                return (1, location.name?.title ?? "")
            }
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
