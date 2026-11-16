/// A stop point as TfL returns it. Every field is optional because TfL leaves any of them out.
public struct TfLStopPoint: Decodable, Equatable, Sendable {
    public let naptanId: String?
    public let commonName: String?
    public let icsCode: String?
    public let lat: Double?
    public let lon: Double?
    public let hubNaptanCode: String?
    public let stationNaptan: String?
    public let lineGroup: [TfLLineGroup]?

    public init(
        naptanId: String?,
        commonName: String?,
        icsCode: String?,
        lat: Double?,
        lon: Double?,
        hubNaptanCode: String? = nil,
        stationNaptan: String? = nil,
        lineGroup: [TfLLineGroup]? = nil
    ) {
        self.naptanId = naptanId
        self.commonName = commonName
        self.icsCode = icsCode
        self.lat = lat
        self.lon = lon
        self.hubNaptanCode = hubNaptanCode
        self.stationNaptan = stationNaptan
        self.lineGroup = lineGroup
    }
}

/// The lines that stop at one ATCO code within a stop point, buses and national rail operators included.
public struct TfLLineGroup: Decodable, Equatable, Sendable {
    public let stationAtcoCode: String?
    public let lineIdentifier: [String]?

    public init(stationAtcoCode: String?, lineIdentifier: [String]?) {
        self.stationAtcoCode = stationAtcoCode
        self.lineIdentifier = lineIdentifier
    }
}

public struct TfLLine: Decodable, Equatable, Sendable {
    public let id: String
}
