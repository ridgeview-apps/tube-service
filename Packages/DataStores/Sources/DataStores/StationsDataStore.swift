import Foundation
import Models
import RidgeviewCore

@MainActor
public final class StationsDataStore: ObservableObject {
    
    // MARK: - Data types
    
    struct FetchedDisruptionData {
        var messagesByStationID: [Station.ID: [String]]
        var fetchedAt: Date?
        var fetchState: DataFetchState
        
        static var defaultValue: FetchedDisruptionData {
            .init(messagesByStationID: [:], fetchState: .fetching)
        }
    }
        
    // MARK: - Properties / outputs
    
    // Dependencies
    public let transportAPI: TransportAPIClientType
    public let now: () -> Date
    
    // Private
    private var stationsByLineGroupID: [Station.LineGroup.ID: Station] = [:]
    private var stationsByID: [Station.ID: Station] = [:]
    private var stationsByAtcoCode: [String: Station] = [:]
    private var nationRailStations: [StopPoint] = []
    private var nationRailStationsByICSCode: [String: StopPoint] = [:]
    
    // Published
    @Published public private(set) var allStations: [Station] = []
    @Published private(set) var fetchedDisruptionData: FetchedDisruptionData = .defaultValue
    
    // MARK: - Init
    
    public init(transportAPI: TransportAPIClientType,
                now: @escaping () -> Date = { .now }) {
        self.transportAPI = transportAPI
        self.now = now
        loadStations()
    }
    
    
    private func loadStations() {
        allStations = Station.allValues()
        nationRailStations = Station.nationRailStopPoints()
        assert(!allStations.isEmpty)
        saveStationsByID()
        saveNationalRailStationsByICSCode()
    }
    
    public func refreshStationDisruptions() async {
        fetchedDisruptionData.fetchState = .fetching

        do {
            let disruptedPoints = try await transportAPI.fetchStationDisruptions().decodedModel
            fetchedDisruptionData.messagesByStationID = disruptedPoints.toMessagesGroupedByStationID(stationsByAtcoCode: stationsByAtcoCode)
            fetchedDisruptionData.fetchState = .success
            fetchedDisruptionData.fetchedAt = .now
        } catch {
            fetchedDisruptionData.fetchState = .failure(error)
        }
    }
    
    public func refreshStationDisruptionsIfStale() async {
        let thirtyMinutes = TimeInterval(30 * 60)
        let thirtyMinutesAgo = now() - thirtyMinutes
        
        let lastFetchedAt = fetchedDisruptionData.fetchedAt ?? .distantPast
        let isStale = lastFetchedAt <= thirtyMinutesAgo
        
        if isStale {
            await refreshStationDisruptions()
        }
    }
    
    private func saveStationsByID() {
        stationsByID = [:]
        stationsByLineGroupID = [:]
        stationsByAtcoCode = [:]
        
        allStations.forEach { station in
            stationsByID[station.id] = station
            station.lineGroups.forEach {
                stationsByLineGroupID[$0.id] = station
                stationsByAtcoCode[$0.atcoCode] = station
            }
        }
    }
    
    private func saveNationalRailStationsByICSCode() {
        nationRailStationsByICSCode = [:]
        
        nationRailStations.forEach {
            if let icsCode = $0.icsCode {
                nationRailStationsByICSCode[icsCode] = $0
            }
        }
    }
    
    public func station(forID stationID: Station.ID) -> Station? {
        stationsByID[stationID]
    }
    
    public func station(forLineGroupID lineGroupID: Station.LineGroup.ID) -> Station? {
        stationsByLineGroupID[lineGroupID]
    }
    
    public func filteredStations(matchingName name: String, limit: Int = 30) -> [Station] {
        Array(
            allStations
                .lazy
                .filter { $0.name.alphaNumerics.localizedStandardContains(name.trimmed().alphaNumerics)}
                .prefix(limit)
        )
    }
    
    public func filteredNationalRailStations(matching name: String, limit: Int = 30) -> [StopPoint] {
        Array(
            nationRailStations
                .lazy
                .filter { ($0.commonName ?? "").alphaNumerics.localizedStandardContains(name.trimmed().alphaNumerics)}
                .prefix(limit)
        )
    }
    
    public func nationalRailStation(forICSCode icsCode: String) -> StopPoint? {
        nationRailStationsByICSCode[icsCode]
    }
    
    public func disruptions(forStationID stationID: Station.ID) -> [String] {
        fetchedDisruptionData.messagesByStationID[stationID] ?? []
    }
}

private extension String {
    var alphaNumerics: String {
        self.filter { $0.isLetter || $0.isNumber }
    }
}

private extension Sequence where Element == DisruptedPoint {
    
    func toMessagesGroupedByStationID(stationsByAtcoCode: [String: Station]) -> [Station.ID: [String]] {
        
        var messagesByStationID = [Station.ID: [String]]()
                                   
        self
            .forEach {
                if let atcoCode = $0.atcoCode,
                   let disruptionMessage = $0.description,
                   let stationID = stationsByAtcoCode[atcoCode]?.id {
                    
                    var messages = messagesByStationID[stationID] ?? []
                    if !messages.contains(disruptionMessage) {
                        messages.append(disruptionMessage)
                    }
                    messagesByStationID[stationID] = messages
                }
            }
        
        return messagesByStationID
    }
}
