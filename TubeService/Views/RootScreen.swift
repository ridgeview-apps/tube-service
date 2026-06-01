import SwiftUI

struct RootScreen: View {

    @Environment(AppDataStore.self) var appData

    var body: some View {
        TabView {
            Tab {
                LineStatusScreen()
                    .accessibilityIdentifier("acc.id.line.status.tab.title")
            } label: {
                Label(.lineStatusTabTitle, systemImage: "info.circle")
            }

            Tab {
                JourneyPlannerScreen()
                    .accessibilityIdentifier("acc.id.journey.planner.tab.title")
            } label: {
                Label(.journeyPlannerTabTitle, systemImage: "arrow.triangle.swap")
            }

            Tab {
                ArrivalsPickerScreen()
                    .accessibilityIdentifier("acc.id.arrivals.tab.title")
            } label: {
                Label(.arrivalsTabTitle, systemImage: "tram")
            }

            Tab {
                NearbyStationsScreen()
                    .accessibilityIdentifier("acc.id.nearby.stations.tab.title")
            } label: {
                Label(.nearbyStationsTabTitle, systemImage: "location.magnifyingglass")
            }

            Tab {
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
