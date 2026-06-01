import SwiftUI

struct RootScreen: View {

    private enum RootTab: Hashable {
        case lineStatus
        case journeyPlanner
        case arrivals
        case nearby
        case maps
    }

    @Environment(AppDataStore.self) var appData
    @State private var selectedTab: RootTab = .lineStatus

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: RootTab.lineStatus) {
                LineStatusScreen()
                    .accessibilityIdentifier("acc.id.line.status.tab.title")
            } label: {
                Label(.lineStatusTabTitle, systemImage: "exclamationmark.circle")
            }

            Tab(value: RootTab.journeyPlanner) {
                JourneyPlannerScreen()
                    .accessibilityIdentifier("acc.id.journey.planner.tab.title")
            } label: {
                Label(.journeyPlannerTabTitle, systemImage: "point.topleft.down.curvedto.point.filled.bottomright.up")
            }

            Tab(value: RootTab.arrivals) {
                ArrivalsPickerScreen()
                    .accessibilityIdentifier("acc.id.arrivals.tab.title")
            } label: {
                Label(.arrivalsTabTitle, systemImage: "tram")
            }

            Tab(value: RootTab.nearby) {
                NearbyStationsScreen()
                    .accessibilityIdentifier("acc.id.nearby.stations.tab.title")
            } label: {
                Label(.nearbyStationsTabTitle, systemImage: "location")
            }

            Tab(value: RootTab.maps) {
                MapsScreen()
                    .accessibilityIdentifier("acc.id.maps.tab.title")
            } label: {
                Label(.mapsTabTitle, systemImage: "map")
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .systemStatusRefreshable()
        .task {
            appData.initialiseAppData()
        }
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
