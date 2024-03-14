public enum TrainLineID: String, Codable, CaseIterable, Hashable {
    
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

public enum ModeID: String, Codable {
    case bus
    case cableCar = "cable-car"
    case coach
    case cycle
    case cycleHire = "cycle-hire"
    case dlr
    case elizabethLine = "elizabeth-line"
    case interchangeKeepSitting = "interchange-keep-sitting"
    case interchangeSecure = "interchange-secure"
    case nationalRail = "national-rail"
    case overground
    case replacementBus = "replacement-bus"
    case riverBus = "river-bus"
    case riverTour = "river-tour"
    case taxi
    case tram
    case tube
    case walking
}

public extension ModeID {
    
    static var trains: [ModeID] {
        [.tube, .dlr, .overground, .tram, .elizabethLine]
    }
    
    static var journeyPlannerModeIDs: Set<ModeID> {
        [
            .bus,
            .cableCar,
            .cycle,
            .dlr,
            .elizabethLine,
            .nationalRail,
            .overground,
            .riverBus,
            .tram,
            .tube,
            .walking
        ]
    }
}
