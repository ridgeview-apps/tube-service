import DataStores
import Models
import PresentationViews

extension JourneyLocation {
    func isDuplicate(of other: JourneyLocation) -> Bool {
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

extension Sequence where Element == JourneyLocation {
    func alreadyContains(_ otherValue: JourneyLocation) -> Bool {
        contains { $0.isDuplicate(of: otherValue) }
    }
}
