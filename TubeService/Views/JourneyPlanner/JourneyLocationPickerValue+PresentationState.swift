import DataStores
import Models
import PresentationViews

extension JourneyLocationPicker.Value {
    func isDuplicate(of other: JourneyLocationPicker.Value) -> Bool {
        switch (self, other) {
        case let (.namedLocation(lhsValue), .namedLocation(rhsValue)):
            return lhsValue.name == rhsValue.name
        case let (.station(lhsValue), .station(rhsValue)):
            return lhsValue == rhsValue
        case let (.nationalRail(lhsValue), .nationalRail(rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }

    var isCurrentLocation: Bool {
        switch self {
        case .station, .nationalRail:
            return false
        case .namedLocation(let namedLocationValue):
            return namedLocationValue.isCurrentLocation
        }
    }

    func toRequestParamsJourneyLocation() -> JourneyRequestParams.JourneyLocation? {
        switch self {
        case .station(let station):
            return .icsCode(station.icsCode)
        case .nationalRail(let stopPoint):
            guard let icsCode = stopPoint.icsCode else {
                assertionFailure("Invalid national rail stoppoint detected: \(stopPoint)")
                return nil
            }
            return .icsCode(icsCode)
        case let .namedLocation(location):
            guard let locationCoordinate = location.coordinate else {
                return nil
            }
            return .coordinate(locationCoordinate)
        }
    }

    func toSavedJourneyLocationType() -> SavedJourney.LocationType? {
        switch self {
        case .station(let station):
            return .station(id: station.id)
        case .nationalRail(let stopPoint):
            guard let icsCode = stopPoint.icsCode else {
                return nil
            }
            return .nationalRail(icsCode: icsCode)
        case let .namedLocation(value):
            guard let locationName = value.name,
                let locationCoordinate = value.coordinate
            else {
                return nil
            }
            return .specific(locationName, locationCoordinate)
        }
    }
}

extension Sequence where Element == JourneyLocationPicker.Value {
    func alreadyContains(_ otherValue: JourneyLocationPicker.Value) -> Bool {
        contains { $0.isDuplicate(of: otherValue) }
    }
}
