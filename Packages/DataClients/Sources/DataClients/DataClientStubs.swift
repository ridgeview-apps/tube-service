import Combine
import Foundation
import Models
import Shared

#if DEBUG

public enum DataClientStubs {} // Namespace

public extension DataClientStubs {
    
    static var transportAPI: TransportAPIClientType {
        StubTransportAPIClient()
    }
    
    static var stations: StationsClientType {
        StubStationsClient()
    }
    
    static var userPreferences: UserPreferencesClientType {
        StubUserPreferencesClient()
    }
}


// MARK: - StubTransportAPIClient

public final class StubTransportAPIClient: TransportAPIClientType {
    
    public init() {}
    
    public private(set) var fetchCurrentLineStatusesCallCount = 0
    public var stubbedLineStatuses: [Line] = ModelStubs.lineStatusesToday
    public var fetchCurrentLineStatusesError: Error?
    public func fetchCurrentLineStatuses() async throws -> [Line] {
        fetchCurrentLineStatusesCallCount += 1
        if let fetchCurrentLineStatusesError { throw fetchCurrentLineStatusesError }
        return stubbedLineStatuses
    }
    
    public private(set) var fetchFutureLineStatusesCallCount = 0
    public var stubbedFutureLineStatuses: [Line] = ModelStubs.lineStatusesFuture
    public func fetchFutureLineStatuses(for dateInterval: DateInterval) async throws -> [Line] {
        fetchFutureLineStatusesCallCount += 1
        return stubbedFutureLineStatuses
    }
    
    public private(set) var fetchArrivalPredictionsCallCount = 0
    public var stubbedArrivalPredictions: [ArrivalPrediction] = ModelStubs.northernLineBothPlatforms
    public func fetchArrivalPredictions(forLineGroup lineGroup: Station.LineGroup) async throws -> [ArrivalPrediction] {
        fetchArrivalPredictionsCallCount += 1
        return stubbedArrivalPredictions
    }
    
    public private(set) var fetchArrivalDeparturesCallCount = 0
    public var stubbedArrivalDepartures: [ArrivalDeparture] = ModelStubs.elizabethLineBothPlatforms
    public func fetchArrivalDepartures(forLineGroup lineGroup: Station.LineGroup) async throws -> [ArrivalDeparture] {
        fetchArrivalDeparturesCallCount += 1
        return stubbedArrivalDepartures
    }

}


// MARK: - StubStationsClient

public final class StubStationsClient: StationsClientType {
    
    public init() {}
    
    public var stations: [Station] = ModelStubs.stations
    public func fetchStations() throws -> [Station] {
        stations
    }
}


// MARK: - StubUserPreferencesClient

public final class StubUserPreferencesClient: UserPreferencesClientType {
    public var stubbedPreferences: UserPreferences = .empty
    
    public init() {}
    
    public func load() -> UserPreferences {
        stubbedPreferences
    }
    
    public func save(_ userPreferences: UserPreferences) {
        self.stubbedPreferences = userPreferences
    }
}


#endif