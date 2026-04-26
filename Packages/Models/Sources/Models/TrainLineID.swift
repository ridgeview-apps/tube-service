public enum TrainLineID: String, Codable, CaseIterable, Hashable, Sendable {
    
    case bakerloo
    case central
    case circle
    case district
    case dlr
    case elizabeth
    case hammersmithAndCity = "hammersmith-city"
    case jubilee
    case liberty
    case lioness
    case metropolitan
    case mildmay
    case northern
    case piccadilly
    case suffragette
    case victoria
    case waterlooAndCity = "waterloo-city"
    case weaver
    case windrush
    case tram
    case overground = "london-overground"
}
