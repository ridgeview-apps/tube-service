/// One row of `londonBusStops.sql`.
public struct LondonBusStop: Equatable, Sendable {
    /// The NaPTAN ID, which saved favourites and recents refer to.
    public let id: String
    public let name: String
    /// The area NaPTAN puts the stop in, e.g. "South Hampstead". Only London stops have one.
    public let locality: String?
    public let letter: String?
    public let towards: String?
    /// The 5-digit Countdown code on the stop's flag.
    public let stopCode: String?
    public let stopAreaID: String?
    public let lat: Double
    public let lon: Double
    /// The compass point buses leave the stop towards, e.g. "NE".
    public let bearing: String?
    public let isHailAndRide: Bool
    public let routes: [String]

    public init(
        id: String,
        name: String,
        locality: String?,
        letter: String?,
        towards: String?,
        stopCode: String?,
        stopAreaID: String?,
        lat: Double,
        lon: Double,
        bearing: String?,
        isHailAndRide: Bool,
        routes: [String]
    ) {
        self.id = id
        self.name = name
        self.locality = locality
        self.letter = letter
        self.towards = towards
        self.stopCode = stopCode
        self.stopAreaID = stopAreaID
        self.lat = lat
        self.lon = lon
        self.bearing = bearing
        self.isHailAndRide = isHailAndRide
        self.routes = routes
    }
}
