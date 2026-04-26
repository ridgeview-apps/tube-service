public struct StopPoint: Codable, Hashable, Sendable {
    public let naptanId: String?
    public let platformName: String?
    public let icsCode: String?
    public let commonName: String?
    public let lat: Double?
    public let lon: Double?
}
