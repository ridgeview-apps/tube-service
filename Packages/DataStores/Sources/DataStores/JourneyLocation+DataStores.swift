import Models

extension JourneyLocation {
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
        case .namedLocation(let location):
            guard let locationCoordinate = location.coordinate else { return nil }
            return .coordinate(locationCoordinate)
        }
    }
}
