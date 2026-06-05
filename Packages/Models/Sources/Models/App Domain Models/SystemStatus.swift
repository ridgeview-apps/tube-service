public struct SystemStatus: Codable, Sendable, Identifiable, Equatable, Hashable {

    public enum Status: String, Codable, Sendable, Equatable {
        case ok
        case outage
        case resolved
    }

    public let id: String
    public let status: Status
    public let message: String?
    public let detail: String?
}
