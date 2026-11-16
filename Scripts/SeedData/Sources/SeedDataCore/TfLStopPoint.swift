/// A stop point as TfL returns it. Every field is optional because TfL leaves any of them out.
public struct TfLStopPoint: Decodable, Equatable, Sendable {
    public let naptanId: String?
    public let commonName: String?
    public let icsCode: String?
    public let lat: Double?
    public let lon: Double?

    public init(
        naptanId: String?,
        commonName: String?,
        icsCode: String?,
        lat: Double?,
        lon: Double?
    ) {
        self.naptanId = naptanId
        self.commonName = commonName
        self.icsCode = icsCode
        self.lat = lat
        self.lon = lon
    }
}
