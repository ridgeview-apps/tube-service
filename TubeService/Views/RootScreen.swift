import PresentationViews
import SwiftUI

struct RootScreen: View {

    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            lineStatusTab
            journeyPlannerTab
            liveArrivalsTab
            nearbyStationsTab
            mapsTab
        }
        .tabViewStyle(.sidebarAdaptable)
        .systemStatusRefreshable()
    }

    private var lineStatusTab: some TabContent<AppTab> {
        Tab(value: AppTab.lineStatus) {
            LineStatusScreen()
        } label: {
            Label(L10n.lineStatusTabTitle, systemImage: "info.circle")
        }
        .accessibilityIdentifier("acc.id.line.status.tab.title")
    }

    private var journeyPlannerTab: some TabContent<AppTab> {
        Tab(value: AppTab.journeyPlanner) {
            JourneyPlannerScreen()
        } label: {
            Label(L10n.journeyPlannerTabTitle, systemImage: "arrow.triangle.swap")
        }
        .accessibilityIdentifier("acc.id.journey.planner.tab.title")
    }

    private var liveArrivalsTab: some TabContent<AppTab> {
        Tab(value: AppTab.arrivals) {
            ArrivalsPickerScreen()
        } label: {
            Label(L10n.arrivalsTabTitle, systemImage: "tram")
        }
        .accessibilityIdentifier("acc.id.arrivals.tab.title")
    }

    private var nearbyStationsTab: some TabContent<AppTab> {
        Tab(value: AppTab.nearby) {
            LocatedStationsScreen()
        } label: {
            Label(L10n.nearbyStationsTabTitle, systemImage: "location.magnifyingglass")
        }
        .accessibilityIdentifier("acc.id.nearby.stations.tab.title")
    }

    private var mapsTab: some TabContent<AppTab> {
        Tab(value: AppTab.maps) {
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
        .environment(AppRouter())
    }
#endif
