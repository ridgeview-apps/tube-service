import DataStores
import Models
import PresentationViews

extension StationInfo {

    /// Shared by the Station screen and its info sheet, so both show the same live data.
    @MainActor
    init(
        station: Station,
        lineStatus: LineStatusDataStore,
        stations: StationsDataStore,
        userPreferences: UserPreferences
    ) {
        let lineStatusData = lineStatus.lineStatusData(for: .live)
        let notices = stations.notices(forStationID: station.id)
        self.init(
            lines: (lineStatusData?.value ?? []).filter { station.sortedLineIDs.contains($0.id) },
            notices: notices,
            isLoadingLines: Self.isLoadingLines(lineStatusData),
            hasUnseenNotices: userPreferences.hasUnseenNotices(notices.map(\.text), at: station.id)
        )
    }

    // Statuses already fetched elsewhere (e.g. the Status tab) show straight away, even while they refresh
    private static func isLoadingLines(_ lineStatusData: RemoteData<[Line]>?) -> Bool {
        guard let lineStatusData else { return true }
        if case .failure = lineStatusData.fetchState { return false }
        return lineStatusData.fetchedAt == nil
    }
}
