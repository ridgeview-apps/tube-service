import PresentationViews
import Shared
import SwiftUI

struct RootScreen: View {

    @Environment(AppRouter.self) private var router
    @Environment(\.adaptableTabBarPlacement) private var adaptableTabBarPlacement

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
        .defaultAdaptableTabBarPlacement(adaptableTabBarPlacement)
        .systemStatusRefreshable()
    }

    private var lineStatusTab: some TabContent<AppTab> {
        Tab(value: AppTab.lineStatus) {
            LineStatusScreen()
        } label: {
            Label(L10n.lineStatusTabTitle, systemImage: "waveform.path.ecg")
        }
        .accessibilityIdentifier(AccessibilityID.Tab.lineStatus)
    }

    private var journeyPlannerTab: some TabContent<AppTab> {
        Tab(value: AppTab.journeyPlanner) {
            JourneyPlannerScreen()
        } label: {
            Label(L10n.journeyPlannerTabTitle, systemImage: "arrow.triangle.swap")
        }
        .accessibilityIdentifier(AccessibilityID.Tab.journeyPlanner)
    }

    private var liveArrivalsTab: some TabContent<AppTab> {
        Tab(value: AppTab.arrivals) {
            ArrivalsPickerScreen()
        } label: {
            Label(L10n.arrivalsTabTitle, systemImage: "tram")
        }
        .accessibilityIdentifier(AccessibilityID.Tab.arrivals)
    }

    private var nearbyStationsTab: some TabContent<AppTab> {
        Tab(value: AppTab.nearby) {
            LocatedStationsScreen()
        } label: {
            Label(L10n.nearbyStationsTabTitle, systemImage: "location.magnifyingglass")
        }
        .accessibilityIdentifier(AccessibilityID.Tab.nearby)
    }

    private var mapsTab: some TabContent<AppTab> {
        Tab(value: AppTab.maps) {
            MapsScreen()
        } label: {
            Label(L10n.mapsTabTitle, systemImage: "map")
        }
        .accessibilityIdentifier(AccessibilityID.Tab.maps)
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
