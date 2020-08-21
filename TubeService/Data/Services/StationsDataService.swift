import ComposableArchitecture

struct StationsDataService {
    let load: () -> Effect<[Station], Never>
}

// MARK: - Real instance
extension StationsDataService {
    
    static let real = StationsDataService(
        load: {
            let decodedStations: [Station] = Bundle.main.decodedJSON(from: "stations.json") ?? []
            return Effect(value: decodedStations.sortedByName())
        }
    )
    
}

// MARK: - Fake instance
#if DEBUG
extension StationsDataService {
    
    static let fake = StationsDataService(
        load: {
            return Effect(value: .fakes())
        }
    )
}
#endif
