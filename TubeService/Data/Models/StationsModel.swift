import DataClients
import Foundation
import Models

@MainActor
public final class StationsModel: ObservableObject {
        
    // MARK: - Properties / outputs
    
    public let stationsClient: StationsClientType
    
    @Published public private(set) var allStations: [Station] = []
    private var stationsByLineGroupID: [Station.LineGroup.ID: Station] = [:]
    private var stationsByID: [Station.ID: Station] = [:]
    
    
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
    
    public func filteredStations(matchingLineGroupIDs favourites: Set<Station.LineGroup.ID>) -> [Station] {
        allStations.filteredBy(favourites: favourites)
    }
    
    public func filteredStations(matchingName name: String) -> [Station] {
        allStations.filter { $0.name.alphaNumerics.localizedStandardContains(name.trimmed().alphaNumerics)}
    }
    
}

private extension Sequence where Element == Station {
    
    func filteredBy(favourites: Set<Station.LineGroup.ID>) -> [Station] {
        return self.compactMap {
            let filteredLineGroups = $0.lineGroups.filter { favourites.contains($0.id) }
            guard !filteredLineGroups.isEmpty else {
                return nil
            }
            return Station(id: $0.id,
                           name: $0.name,
                           lineGroups: filteredLineGroups)
        }
    }
}

private extension String {
    var alphaNumerics: String {
        self.filter { $0.isLetter || $0.isNumber }
    }
}
