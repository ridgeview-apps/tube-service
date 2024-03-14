public extension JourneyItinerary {
    
    func legsForJourney(at index: Int) -> [JourneyLeg] {
        guard let journeys, journeys.indices.contains(index) else { return [] }
        
        return journeys[index].legs ?? []
    }
}

public extension JourneyLeg {
    var firstRouteOption: JourneyRouteOption? { routeOptions?.first }
    var lineIdentifier: TflIdentifierType? { firstRouteOption?.lineIdentifier }
    var trainLineID: TrainLineID? { lineIdentifier?.trainLineID }
    var modeID: ModeID? { mode?.modeID }
    var stopPoints: [TflIdentifier] { path?.stopPoints ?? [] }
}
