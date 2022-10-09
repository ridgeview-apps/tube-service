public enum LineID: String, Codable, CaseIterable, Hashable {
    
    case bakerloo
    case central
    case circle
    case district
    case dlr
    case elizabeth
    case hammersmithAndCity = "hammersmith-city"
    case jubilee
    case metropolitan
    case northern
    case piccadilly
    case victoria
    case waterlooAndCity = "waterloo-city"
    case tram
    case overground = "london-overground"
}

public enum TransportMode: String, CaseIterable {
    case tube
    case dlr
    case overground
    case tram
    case elizabethLine = "elizabeth-line"
}
