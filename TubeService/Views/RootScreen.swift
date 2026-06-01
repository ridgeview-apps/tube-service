import SwiftUI

struct RootScreen: View {

    @Environment(AppDataStore.self) var appData

    var body: some View {
        TabView {
            Tab {
                LineStatusScreen()
                    .accessibilityIdentifier("acc.id.line.status.tab.title")
            } label: {
                Label(.lineStatusTabTitle, systemImage: "exclamationmark.circle")
            }

            Tab {
                JourneyPlannerScreen()
                    .accessibilityIdentifier("acc.id.journey.planner.tab.title")
            } label: {
                Label(.journeyPlannerTabTitle, systemImage: "point.topleft.down.curvedto.point.filled.bottomright.up")
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
                Label(.nearbyStationsTabTitle, systemImage: "location")
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
