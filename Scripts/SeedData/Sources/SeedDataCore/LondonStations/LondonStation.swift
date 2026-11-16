/// One entry in `londonStations.json`. The app decodes it as `Models.Station`, so the keys must stay as they are.
public struct LondonStation: Codable, Equatable, Sendable {

    public struct LineGroup: Codable, Hashable, Sendable {
        public let atcoCode: String
        public let lineIds: [String]

        public init(atcoCode: String, lineIds: [String]) {
            self.atcoCode = atcoCode
            self.lineIds = lineIds
        }
    }

    public struct Location: Codable, Equatable, Sendable {
        public let lat: Double
        public let lon: Double

        public init(lat: Double, lon: Double) {
            self.lat = lat
            self.lon = lon
        }
    }

    public let icsCode: String
    public let id: String
    public let lineGroups: [LineGroup]
    public let location: Location
    public let name: String

    public init(
        icsCode: String,
        id: String,
        lineGroups: [LineGroup],
        location: Location,
        name: String
    ) {
        self.icsCode = icsCode
        self.id = id
        self.lineGroups = lineGroups
        self.location = location
        self.name = name
    }
}
