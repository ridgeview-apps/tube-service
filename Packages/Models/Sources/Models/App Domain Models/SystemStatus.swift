public struct SystemStatus: Codable, Sendable, Identifiable, Equatable, Hashable {
    
    // swiftlint:disable identifier_name
    public enum Status: String, Codable, Sendable, Equatable {
        case ok
        case outage
        case resolved
    }
    // swiftlint:enable identifier_name
    
    public let id: String
    public let status: Status
    public let message: String?
    public let detail: String?
}
