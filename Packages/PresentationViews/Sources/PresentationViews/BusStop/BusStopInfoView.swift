import Models
import Shared
import SwiftUI

/// A bus stop's routes, notices and location, opened from the Stop screen's toolbar or notice row.
public struct BusStopInfoView: View {
    let stop: BusStop
    /// Closures first, and none that have ended; nil until they first arrive.
    let notices: [StationNotice]?
    /// True until the notices first arrive or fail to load.
    let isLoadingNotices: Bool

    @Environment(\.locale) private var locale

    public init(stop: BusStop, notices: [StationNotice]?, isLoadingNotices: Bool) {
        self.stop = stop
        self.notices = notices
        self.isLoadingNotices = isLoadingNotices
    }

    public var body: some View {
        List {
            routesSection
            NoticesSections(notices: notices, isLoading: isLoadingNotices, placeName: stop.name, emptyText: .busStopNoticesEmpty)
            LocationSection(name: stop.name, location: stop.location)
        }
        .listStyle(.insetGrouped)
    }

    private var routesSection: some View {
        Section {
            if stop.routes.isEmpty {
                Text(.busStopRoutesNone)
                    .foregroundStyle(.secondary)
            } else {
                Text(verbatim: stop.routes.joined(separator: " · "))
                    .accessibilityLabel(stop.routes.formatted(.list(type: .and).locale(locale)))
            }
        } header: {
            Text(.busStopRoutesSectionHeaderTitle)
        }
    }
}

// MARK: - Previews

private let previewStop = BusStopDatabase.london.nearbyStops(to: LocationCoordinate(lat: 51.53047, lon: -0.12169), limit: 1)[0].stop

#Preview("Stop info") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NavigationStack {
            BusStopInfoView(
                stop: previewStop,
                notices: [StationNotice(text: "This stop is closed due to roadworks. Please use the temporary stop on Euston Road.", kind: "Closure")],
                isLoadingNotices: false
            )
        }
    }
}

#Preview("No notices") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NavigationStack {
            BusStopInfoView(stop: previewStop, notices: [], isLoadingNotices: false)
        }
    }
}

#Preview("Loading") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NavigationStack {
            BusStopInfoView(stop: previewStop, notices: nil, isLoadingNotices: true)
        }
    }
}
