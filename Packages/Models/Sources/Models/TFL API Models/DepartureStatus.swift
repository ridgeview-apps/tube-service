public enum DepartureStatus: String, Codable, Equatable, Hashable, Sendable {
    case onTime = "OnTime"
    case delayed = "Delayed"
    case cancelled = "Cancelled"
    case notStoppingAtStation = "NotStoppingAtStation"
}
