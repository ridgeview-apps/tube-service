public enum JourneyPlannerError: Error, Sendable {
    case stationNotFound
    case invalidLocationRequest
    case coordinateUnknown
}
