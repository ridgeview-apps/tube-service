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
    public let stopType: String?
    public let stopLetter: String?
    public let lines: [TfLIdentifier]?
    public let lineModeGroups: [TfLLineModeGroup]?
    public let additionalProperties: [TfLAdditionalProperty]?

    public init(
        naptanId: String?,
        commonName: String?,
        icsCode: String?,
        lat: Double?,
        lon: Double?,
        hubNaptanCode: String? = nil,
        stationNaptan: String? = nil,
        lineGroup: [TfLLineGroup]? = nil,
        stopType: String? = nil,
        stopLetter: String? = nil,
        lines: [TfLIdentifier]? = nil,
        lineModeGroups: [TfLLineModeGroup]? = nil,
        additionalProperties: [TfLAdditionalProperty]? = nil
    ) {
        self.naptanId = naptanId
        self.commonName = commonName
        self.icsCode = icsCode
        self.lat = lat
        self.lon = lon
        self.hubNaptanCode = hubNaptanCode
        self.stationNaptan = stationNaptan
        self.lineGroup = lineGroup
        self.stopType = stopType
        self.stopLetter = stopLetter
        self.lines = lines
        self.lineModeGroups = lineModeGroups
        self.additionalProperties = additionalProperties
    }

    public func additionalProperty(category: String, key: String) -> String? {
        additionalProperties?.first { $0.category == category && $0.key == key }?.value
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

public struct TfLLineModeGroup: Decodable, Equatable, Sendable {
    public let modeName: String?
    public let lineIdentifier: [String]?

    public init(modeName: String?, lineIdentifier: [String]?) {
        self.modeName = modeName
        self.lineIdentifier = lineIdentifier
    }
}

/// A line as listed on a stop point, e.g. id `n63` with name `N63`.
public struct TfLIdentifier: Decodable, Equatable, Sendable {
    public let id: String?
    public let name: String?

    public init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}

public struct TfLAdditionalProperty: Decodable, Equatable, Sendable {
    public let category: String?
    public let key: String?
    public let value: String?

    public init(category: String?, key: String?, value: String?) {
        self.category = category
        self.key = key
        self.value = value
    }
}

/// One page of `/StopPoint/Mode/{modes}`.
public struct TfLStopPointsPage: Decodable, Equatable, Sendable {
    public let stopPoints: [TfLStopPoint]
    public let pageSize: Int
    public let total: Int
    public let page: Int

    public init(stopPoints: [TfLStopPoint], pageSize: Int, total: Int, page: Int) {
        self.stopPoints = stopPoints
        self.pageSize = pageSize
        self.total = total
        self.page = page
    }
}

public struct TfLLine: Decodable, Equatable, Sendable {
    public let id: String
}
