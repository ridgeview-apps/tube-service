import Foundation

/// A bus prediction from `/StopPoint/{id}/Arrivals`. Routes like "73" aren't `TrainLineID`s, so buses can't share
/// `ArrivalPrediction`.
public struct BusArrival: Identifiable, Equatable, Codable, Sendable {

    enum CodingKeys: String, CodingKey {
        case id
        case lineName
        case destinationName
        case towards
        case timeToStation
        case naptanID = "naptanId"
        case platformName
    }

    public let id: String?
    /// The route as shown on the bus, e.g. "N63".
    public let lineName: String?
    public let destinationName: String?
    public let towards: String?
    public let timeToStation: Int?
    public let naptanID: String?
    /// The stop letter, e.g. "H".
    public let platformName: String?

    public init(
        id: String?,
        lineName: String?,
        destinationName: String?,
        towards: String?,
        timeToStation: Int?,
        naptanID: String?,
        platformName: String?
    ) {
        self.id = id
        self.lineName = lineName
        self.destinationName = destinationName
        self.towards = towards
        self.timeToStation = timeToStation
        self.naptanID = naptanID
        self.platformName = platformName
    }
}
