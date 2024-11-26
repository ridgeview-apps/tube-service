public extension TrainLineID {
    
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
        case .liberty:
            return "Liberty"
        case .lioness:
            return "Lioness"
        case .metropolitan:
            return "Metropolitan"
        case .mildmay:
            return "Mildmay"
        case .northern:
            return "Northern"
        case .piccadilly:
            return "Piccadilly"
        case .suffragette:
            return "Suffragette"
        case .victoria:
            return "Victoria"
        case .waterlooAndCity:
            return "Waterloo & City"
        case .tram:
            return "Tram"
        case .overground:
            return "Overground"
        case .weaver:
            return "Weaver"
        case .windrush:
            return "Windrush"
        }
    }
}
