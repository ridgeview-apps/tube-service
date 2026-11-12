import Foundation
import Models
import Shared

@MainActor
@Observable
public final class StationsDataStore {

    struct FetchedDisruptionData {
        var noticesByStationID: [Station.ID: [StationNotice]]
        var fetchedAt: Date?
        var fetchState: DataFetchState

        static var defaultValue: FetchedDisruptionData {
            .init(noticesByStationID: [:], fetchState: .idle)
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

    /// The station's notices that haven't ended, closures first.
    public func notices(forStationID stationID: Station.ID) -> [StationNotice] {
        let now = now()
        return (fetchedDisruptionData.noticesByStationID[stationID] ?? []).filter { $0.timing(at: now) != .ended }
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
            fetchedDisruptionData.noticesByStationID = disruptedPoints.toNoticesGroupedByStationID(stationsByAtcoCode: stationsByAtcoCode)
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

    func toNoticesGroupedByStationID(stationsByAtcoCode: [String: Station]) -> [Station.ID: [StationNotice]] {
        var noticesByStationID = [Station.ID: [StationNotice]]()

        let stationNotices = compactMap { disruptedPoint -> (Station.ID, StationNotice)? in
            guard let atcoCode = disruptedPoint.atcoCode,
                let stationID = stationsByAtcoCode[atcoCode]?.id,
                let notice = StationNotice(disruptedPoint)
            else { return nil }
            return (stationID, notice)
        }

        // Sorted before removing duplicates, so a duplicate keeps its highest priority
        for (stationID, notice) in stationNotices.sorted(by: { $0.1.priority < $1.1.priority }) {
            var notices = noticesByStationID[stationID] ?? []
            if !notices.contains(where: { $0.text == notice.text }) {
                notices.append(notice)
            }
            noticesByStationID[stationID] = notices
        }

        return noticesByStationID
    }
}
