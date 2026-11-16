/// One entry in `nationalRailStations.json`. The app decodes it as `Models.StopPoint`, so the keys must stay as they are.
public struct NationalRailStopPoint: Codable, Equatable, Sendable {
    public let commonName: String
    public let icsCode: String
    public let lat: Double
    public let lon: Double
    public let naptanId: String

    public init(
        commonName: String,
        icsCode: String,
        lat: Double,
        lon: Double,
        naptanId: String
    ) {
        self.commonName = commonName
        self.icsCode = icsCode
        self.lat = lat
        self.lon = lon
        self.naptanId = naptanId
    }
}
