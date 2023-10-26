import DataClients
import Foundation
import Models

@MainActor
public final class StationsModel: ObservableObject {
        
    // MARK: - Properties / outputs
    
    // Dependencies
    public let stationsClient: StationsClientType
    
    // Private
    private var stationsByLineGroupID: [Station.LineGroup.ID: Station] = [:]
    private var stationsByID: [Station.ID: Station] = [:]
    
    // Published
    @Published public private(set) var allStations: [Station] = []
    
    
    // MARK: - Init
    
    public init(stationsClient: StationsClientType,
                fetchImmediately: Bool = true) {
        self.stationsClient = stationsClient
        if fetchImmediately {
            fetchStations()
        }
    }
    
    
    public func fetchStations() {
        do {
            allStations = try stationsClient.fetchStations()
            saveStationsByID()
        } catch {
            assertionFailure("Failed to fetch stations - please check the embedded stations.json file")
        }
    }
    
    private func saveStationsByID() {
        stationsByID = [:]
        stationsByLineGroupID = [:]
        
        allStations.forEach { station in
            stationsByID[station.id] = station
            station.lineGroups.forEach {
                stationsByLineGroupID[$0.id] = station
            }
        }
    }
    
    public func station(forID stationID: Station.ID) -> Station? {
        stationsByID[stationID]
    }
    
    public func station(forLineGroupID lineGroupID: Station.LineGroup.ID) -> Station? {
        stationsByLineGroupID[lineGroupID]
    }
    
    public func filteredStations(matchingName name: String) -> [Station] {
        allStations.filter { $0.name.alphaNumerics.localizedStandardContains(name.trimmed().alphaNumerics)}
    }
    
}


private extension String {
    var alphaNumerics: String {
        self.filter { $0.isLetter || $0.isNumber }
    }
}
