public enum TrainLine: String, Codable, CaseIterable {
    
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

public extension TrainLine {
    
    var shortName: String {
        switch self {
        case .bakerloo:
            return "Bakerloo"
        case .central:
            return "Central"
        case .circle:
            return "Circle"
        case .dlr:
            return "DLR"
        case .district:
            return "District"
        case .hammersmithAndCity:
            return "Hammersmith & City"
        case .jubilee:
            return "Jubilee"
        case .metropolitan:
            return "Metropolitan"
        case .northern:
            return "Northern"
        case .piccadilly:
            return "Piccadilly"
        case .victoria:
            return "Victoria"
        case .waterlooAndCity:
            return "Waterloo & City"
        case .tram:
            return "Tram"
        case .tflRail:
            return "TfL Rail"
        case .overground:
            return "Overground"
        }
    }
}

public extension Sequence where Element == TrainLine {
    func sortedByName() -> [TrainLine] {
        self.sorted(by: { $0.shortName < $1.shortName })
    }
    
    func toTitle() -> String {
        self.sortedByName().map { $0.shortName }.joined(separator: ", ")
    }
    
    func toId() -> String {
        self.sortedByName().map { $0.rawValue }.joined(separator: ",")
    }
}
