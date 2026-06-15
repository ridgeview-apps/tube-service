import Foundation
import Models
import RidgeviewCore

@MainActor
@Observable
public final class StationsDataStore {

    struct FetchedDisruptionData {
        var messagesByStationID: [Station.ID: [String]]
        var fetchedAt: Date?
        var fetchState: DataFetchState

        static var defaultValue: FetchedDisruptionData {
            .init(messagesByStationID: [:], fetchState: .fetching)
        }
    }

    // MARK: - State

    private let tflAPI: TflAPIClientType
    private let now: () -> Date

    private var nationRailStations: [StopPoint] { Station.allNationalRail }
    private var stationsByLineGroupID: [Station.LineGroup.ID: Station] = [:]
    private var stationsByID: [Station.ID: Station] = [:]
    private var stationsByAtcoCode: [String: Station] = [:]
    private var nationRailStationsByICSCode: [String: StopPoint] = [:]
    private(set) var fetchedDisruptionData: FetchedDisruptionData = .defaultValue

    public init(
        tflAPI: TflAPIClientType,
        now: @escaping () -> Date = { .now }
    ) {
        self.tflAPI = tflAPI
        self.now = now
        loadStations()
    }

    // MARK: - Outputs

    public var allLondon: [Station] {
        Station.allLondonTrains
    }

    public func station(forID stationID: Station.ID) -> Station? {
        stationsByID[stationID]
    }

    public func station(forLineGroupID lineGroupID: Station.LineGroup.ID) -> Station? {
        stationsByLineGroupID[lineGroupID]
    }

    public func nationalRailStation(forICSCode icsCode: String) -> StopPoint? {
        nationRailStationsByICSCode[icsCode]
    }

    public func filteredStations(matchingName name: String, limit: Int = 30) -> [Station] {
        Array(
            allLondon
                .lazy
                .filter { $0.name.alphaNumerics.localizedStandardContains(name.trimmed().alphaNumerics) }
                .prefix(limit)
        )
    }

    public func filteredNationalRailStations(matching name: String, limit: Int = 30) -> [StopPoint] {
        Array(
            nationRailStations
                .lazy
                .filter { ($0.commonName ?? "").alphaNumerics.localizedStandardContains(name.trimmed().alphaNumerics) }
                .prefix(limit)
        )
    }

    public func disruptions(forStationID stationID: Station.ID) -> [String] {
        (fetchedDisruptionData.messagesByStationID[stationID] ?? []).map { $0.trimmed() }
    }

    // MARK: - Refreshing

    public func refreshStationDisruptionsIfStale() async {
        let thirtyMinutes = TimeInterval(30 * 60)
        let thirtyMinutesAgo = now() - thirtyMinutes

        let lastFetchedAt = fetchedDisruptionData.fetchedAt ?? .distantPast
        let isStale = lastFetchedAt <= thirtyMinutesAgo

        if isStale {
            await refreshStationDisruptions()
        }
    }

    public func refreshStationDisruptions() async {
        fetchedDisruptionData.fetchState = .fetching

        do {
            let disruptedPoints = try await tflAPI.fetchStationDisruptions().decodedModel
            fetchedDisruptionData.messagesByStationID = disruptedPoints.toMessagesGroupedByStationID(stationsByAtcoCode: stationsByAtcoCode)
            fetchedDisruptionData.fetchState = .success
            fetchedDisruptionData.fetchedAt = .now
        } catch {
            fetchedDisruptionData.fetchState = .failure(error)
        }
    }

    // MARK: - Implementation

    private func loadStations() {
        assert(!allLondon.isEmpty)
        assert(!nationRailStations.isEmpty)
        saveStationsByID()
        saveNationalRailStationsByICSCode()
    }

    private func saveStationsByID() {
        stationsByID = [:]
        stationsByLineGroupID = [:]
        stationsByAtcoCode = [:]

        allLondon.forEach { station in
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
                    let stationID = stationsByAtcoCode[atcoCode]?.id
                {

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
