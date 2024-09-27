public struct SystemStatus: Codable, Sendable, Identifiable {
    
    // swiftlint:disable identifier_name
    public enum Status: String, Codable, Sendable {
        case ok
        case outage
        case resolved
    }
    // swiftlint:enable identifier_name
    
    public let id: String
    public let status: Status
    public let message: String?
    
    public init(id: String,
                status: Status,
                message: String?) {
        self.id = id
        self.status = status
        self.message = message
    }
}
