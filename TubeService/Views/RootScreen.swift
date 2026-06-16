import PresentationViews
import SwiftUI

struct RootScreen: View {

    @Environment(AppDataStore.self) var appData

    var body: some View {
        TabView {
            lineStatusTab
            journeyPlannerTab
            liveArrivalsTab
            nearbyStationsTab
            mapsTab
        }
        .tabViewStyle(.sidebarAdaptable)
        .systemStatusRefreshable()
        .task {
            await appData.start()
        }
    }

    private var lineStatusTab: some TabContent<Never> {
        Tab {
            LineStatusScreen()
        } label: {
            Label(L10n.lineStatusTabTitle, systemImage: "info.circle")
        }
        .accessibilityIdentifier("acc.id.line.status.tab.title")
    }

    private var journeyPlannerTab: some TabContent<Never> {
        Tab {
            JourneyPlannerScreen()
        } label: {
            Label(L10n.journeyPlannerTabTitle, systemImage: "arrow.triangle.swap")
        }
        .accessibilityIdentifier("acc.id.journey.planner.tab.title")
    }

    private var liveArrivalsTab: some TabContent<Never> {
        Tab {
            ArrivalsPickerScreen()
        } label: {
            Label(L10n.arrivalsTabTitle, systemImage: "tram")
        }
        .accessibilityIdentifier("acc.id.arrivals.tab.title")
    }

    private var nearbyStationsTab: some TabContent<Never> {
        Tab {
            LocatedStationsScreen()
        } label: {
            Label(L10n.nearbyStationsTabTitle, systemImage: "location.magnifyingglass")
        }
        .accessibilityIdentifier("acc.id.nearby.stations.tab.title")
    }

    private var mapsTab: some TabContent<Never> {
        Tab {
            MapsScreen()
        } label: {
            Label(L10n.mapsTabTitle, systemImage: "map")
        }
        .accessibilityIdentifier("acc.id.maps.tab.title")
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            RootScreen()
        }
    }
#endif
