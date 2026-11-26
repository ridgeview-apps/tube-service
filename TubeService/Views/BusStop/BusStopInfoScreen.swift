import DataStores
import Models
import PresentationViews
import SwiftUI

/// The Stop screen's info sheet, reading the store itself so it stays live while open.
@MainActor
struct BusStopInfoScreen: View {

    @Environment(BusStopsDataStore.self) private var busStops

    let stop: BusStop

    var body: some View {
        BusStopInfoView(
            stop: stop,
            notices: busStops.notices(forStopID: stop.id),
            isLoadingNotices: busStops.isLoadingNotices(forStopID: stop.id)
        )
        .navigationTitle(stop.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { CloseToolbarItem() }
        .task {
            await busStops.refreshNoticesIfStale(for: stop.id)
        }
    }
}

// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            BusStopInfoScreen(stop: BusStopDatabase.london.nearbyStops(to: LocationCoordinate(lat: 51.53047, lon: -0.12169), limit: 1)[0].stop)
        }
    }
#endif
