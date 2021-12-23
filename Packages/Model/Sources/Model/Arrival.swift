import Foundation

public struct Arrival: Identifiable, Equatable, Codable {
    public let id: String
    public let lineId: TrainLine
    public let lineName: String
    public let platformName: String
    public let towards: String?
    public let destinationName: String?
    public let currentLocation: String?
    public let timeToStation: Int?
    public let destinationNaptanId: String?
    public let naptanId: String?
    
    public init(
        id: String,
        lineId: TrainLine,
        lineName: String,
        platformName: String,
        towards: String?,
        destinationName: String?,
        currentLocation: String?,
        timeToStation: Int?,
        destinationNaptanId: String?,
        naptanId: String?
    ) {
        self.id = id
        self.lineId = lineId
        self.lineName = lineName
        self.platformName = platformName
        self.towards = towards
        self.destinationName = destinationName
        self.currentLocation = currentLocation
        self.timeToStation = timeToStation
        self.destinationNaptanId = destinationNaptanId
        self.naptanId = naptanId
    }
}
