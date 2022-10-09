import Combine
import Models
import RidgeviewCore
import Foundation


// MARK: - Data types

public protocol StationsClientType {
    func fetchStations() throws -> [Station]
}

enum StationsClientError: Error {
    case invalidJSON
}


// MARK: - StationsClient

public struct StationsClient: StationsClientType {
    
    public init() {}
    
    public func fetchStations() throws -> [Station] {
        let stations: [Station] = Station.allValues()
        
        guard !stations.isEmpty else {
            throw StationsClientError.invalidJSON
        }
        
        return stations
    }
}
