import PresentationViews
import Shared
import SwiftUI

struct RootScreen: View {

    @Environment(AppNavigator.self) private var appNavigator
    @Environment(\.adaptableTabBarPlacement) private var adaptableTabBarPlacement

    var body: some View {
        @Bindable var appNavigator = appNavigator
        TabView(selection: $appNavigator.selectedTab) {
            lineStatusTab
            journeyPlannerTab
            liveArrivalsTab
            mapsTab
        }
        .tabViewStyle(.sidebarAdaptable)
        .defaultAdaptableTabBarPlacement(adaptableTabBarPlacement)
        .systemStatusRefreshable()
    }

    private var lineStatusTab: some TabContent<AppTab> {
        Tab(value: AppTab.lineStatus) {
            NavigationHost(navigator: appNavigator.lineStatus) {
                LineStatusScreen()
            }
        } label: {
            Label(L10n.lineStatusTabTitle, systemImage: "info.circle")
        }
        .accessibilityIdentifier(AccessibilityID.Tab.lineStatus)
    }

    private var journeyPlannerTab: some TabContent<AppTab> {
        Tab(value: AppTab.journeyPlanner) {
            NavigationHost(navigator: appNavigator.journeyPlanner) {
                JourneyPlannerScreen()
            }
        } label: {
            Label(L10n.journeyPlannerTabTitle, systemImage: "arrow.triangle.swap")
        }
        .accessibilityIdentifier(AccessibilityID.Tab.journeyPlanner)
    }

    private var liveArrivalsTab: some TabContent<AppTab> {
        Tab(value: AppTab.arrivals) {
            NavigationHost(navigator: appNavigator.arrivals) {
                ArrivalsScreen()
            }
        } label: {
            Label(L10n.arrivalsTabTitle, systemImage: "tram")
        }
        .accessibilityIdentifier(AccessibilityID.Tab.arrivals)
    }

    private var mapsTab: some TabContent<AppTab> {
        Tab(value: AppTab.maps) {
            NavigationHost(navigator: appNavigator.maps) {
                MapsScreen()
            }
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
            }
#endif
