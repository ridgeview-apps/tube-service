import Foundation
import Models
import Shared

@MainActor
@Observable
public final class StationsDataStore {

    struct FetchedDisruptionData {
        var messagesByStationID: [Station.ID: [String]]
        var stationIDsWithClosures: Set<Station.ID> = []
        var fetchedAt: Date?
        var fetchState: DataFetchState

        static var defaultValue: FetchedDisruptionData {
            .init(messagesByStationID: [:], fetchState: .idle)
        }
    }

    // MARK: - State

    private let tflAPI: TflAPIClientType
    private let now: () -> Date

    private var nationRailStations: [StopPoint] { Station.allNationalRail }
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

    public func hasClosureNotice(forStationID stationID: Station.ID) -> Bool {
        fetchedDisruptionData.stationIDsWithClosures.contains(stationID)
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
            fetchedDisruptionData.stationIDsWithClosures = Set(
                disruptedPoints.filter(\.isClosure).compactMap { $0.atcoCode.flatMap { stationsByAtcoCode[$0]?.id } }
            )
            fetchedDisruptionData.fetchState = .success
            fetchedDisruptionData.fetchedAt = now()
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
        stationsByAtcoCode = [:]

        allLondon.forEach { station in
            stationsByID[station.id] = station
            station.lineGroups.forEach {
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
            .sorted { $0.noticePriority < $1.noticePriority }
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

private extension DisruptedPoint {
    /// Closures change how people use the station, e.g. trains not stopping or an exit only entrance.
    var isClosure: Bool {
        guard let type else { return false }
        return type.localizedCaseInsensitiveContains("closure") || type.localizedCaseInsensitiveCompare("Exit Only") == .orderedSame
    }

    /// The Station screen shows the first notice, so closures come first, then by how current the notice is.
    /// TfL marks long-running notices (e.g. weeks of escalator works) as real-time too, so the category alone isn't enough.
    var noticePriority: Int {
        if isClosure { return 0 }
        return switch appearance {
        case .realTime, .statusAlert: 1
        case .crowding, .event: 2
        case .plannedWork: 3
        case .information, nil: 4
        }
    }
}
