import SwiftUI

struct RootScreen: View {

    @Environment(AppDataStore.self) var appData

    var body: some View {
        TabView {
            Tab {
                LineStatusScreen()
            } label: {
                Label(.lineStatusTabTitle, systemImage: "info.circle")
            }
            .accessibilityIdentifier("acc.id.line.status.tab.title")

            Tab {
                JourneyPlannerScreen()
            } label: {
                Label(.journeyPlannerTabTitle, systemImage: "arrow.triangle.swap")
            }
            .accessibilityIdentifier("acc.id.journey.planner.tab.title")

            Tab {
                ArrivalsPickerScreen()
            } label: {
                Label(.arrivalsTabTitle, systemImage: "tram")
            }
            .accessibilityIdentifier("acc.id.arrivals.tab.title")

            Tab {
                NearbyStationsScreen()
            } label: {
                Label(.nearbyStationsTabTitle, systemImage: "location.magnifyingglass")
            }
            .accessibilityIdentifier("acc.id.nearby.stations.tab.title")

            Tab {
                MapsScreen()
            } label: {
                Label(.mapsTabTitle, systemImage: "map")
            }
            .accessibilityIdentifier("acc.id.maps.tab.title")
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
