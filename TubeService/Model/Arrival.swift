import Foundation

struct Arrival: Identifiable, Equatable, Codable {
    let id: String
    let lineId: TrainLine
    let lineName: String
    let platformName: String
    let towards: String?
    let destinationName: String?
    let currentLocation: String?
    let timeToStation: Int?
}

enum TrainLine: String, Codable, CaseIterable {
    
    case bakerloo
    case central
    case circle
    case district
    case dlr
    case hammersmithAndCity = "hammersmith-city"
    case jubilee
    case metropolitan
    case northern
    case piccadilly
    case victoria
    case waterlooAndCity = "waterloo-city"
    case tram
    case overground = "london-overground"
    case tflRail = "tfl-rail"
}
