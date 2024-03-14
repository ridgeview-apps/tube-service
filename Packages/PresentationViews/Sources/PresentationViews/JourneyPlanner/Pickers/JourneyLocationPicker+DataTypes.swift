import Foundation
import Models

public enum JourneyLocationPicker {
    
    public struct NamedLocationValue: Hashable {
        public let name: LocationName
        public let coordinate: LocationCoordinate?
        
        public var isResolved: Bool { coordinate != nil }
        
        public init(name: LocationName, 
                    coordinate: LocationCoordinate? = nil) {
            self.name = name
            self.coordinate = coordinate
        }
    }
    
    public struct CurrentLocationValue: Hashable {
        public let name: LocationName?
        public let coordinate: LocationCoordinate?
        
        public init(name: LocationName?, coordinate: LocationCoordinate? = nil) {
            self.name = name
            self.coordinate = coordinate
        }
        
        public var isResolved: Bool { name != nil && coordinate != nil }
        
        public static let unknown = CurrentLocationValue(name: nil, coordinate: nil)
    }
    
    public enum Value: Hashable {
        case currentLocation(CurrentLocationValue)
        case station(Station)
        case nationalRail(StopPoint)
        case namedLocation(NamedLocationValue)
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
        case .currentLocation(let location):
            location.name?.formattedSingleLineTitle ?? NSLocalizedString("journey.planner.location.value.current.location", bundle: .module, comment: "")
        case .station(let station):
            station.name
        case .nationalRail(let stopPoint):
            stopPoint.commonName ?? ""
        case .namedLocation(let location):
            location.name.formattedSingleLineTitle
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
        case .currentLocation:
            return (0, "")
        case .station(let station):
            return (1, station.name)
        case .nationalRail(let stopPoint):
            return (1, stopPoint.commonName ?? "")
        case .namedLocation(let location):
            return (1, location.name.title)
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
