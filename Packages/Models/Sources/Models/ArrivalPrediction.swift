import Foundation

public struct ArrivalPrediction: Identifiable, Equatable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case currentLocation
        case destinationName
        case destinationNaptanID = "destinationNaptanId"
        case lineID = "lineId"
        case naptanID = "naptanId"
        case platformName
        case timeToStation
        case towards
    }
    
    public let id: String?
    
    public let currentLocation: String?
    public let destinationName: String?
    public let destinationNaptanID: String?
    public let lineID: LineID?
    public let naptanID: String?
    public let platformName: String?
    public let timeToStation: Int?
    public let towards: String?
  
    
    // MARK: - Init
    
    public init(id: String?,
                currentLocation: String?,
                destinationName: String?,
                destinationNaptanID: String?,
                lineID: LineID?,
                naptanID: String?,
                platformName: String?,
                timeToStation: Int?,
                towards: String?) {
        self.id = id
        self.currentLocation = currentLocation
        self.destinationName = destinationName
        self.destinationNaptanID = destinationNaptanID
        self.lineID = lineID
        self.naptanID = naptanID
        self.platformName = platformName
        self.timeToStation = timeToStation
        self.towards = towards
    }
}
