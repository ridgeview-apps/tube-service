public extension LineID {
    
    var name: String {
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
        case .elizabeth:
            return "Elizabeth"
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
        case .overground:
            return "Overground"
        }
    }
}
