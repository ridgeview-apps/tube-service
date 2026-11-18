import DataStores
import Models
import PresentationViews

extension StationInfo {

    @MainActor
    init(station: Station, lineStatus: LineStatusDataStore, stations: StationsDataStore) {
        self.init(
            lines: lineStatus.liveLines(at: station),
            isLoadingLines: lineStatus.isLoadingLiveLines,
            notices: stations.notices(forStationID: station.id),
            isLoadingNotices: stations.isLoadingNotices
        )
    }
}

/// Shared by the Station screen and its info sheet, so both show the same live data.
extension LineStatusDataStore {

    func liveLines(at station: Station) -> [Line] {
        (lineStatusData(for: .live)?.value ?? []).filter { station.sortedLineIDs.contains($0.id) }
    }

    // Statuses already fetched elsewhere (e.g. the Status tab) show straight away, even while they refresh
    var isLoadingLiveLines: Bool {
        guard let lineStatusData = lineStatusData(for: .live) else { return true }
        if case .failure = lineStatusData.fetchState { return false }
        return lineStatusData.fetchedAt == nil
    }
}
