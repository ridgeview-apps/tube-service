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
            appData.initialiseAppData()
        }
    }
    
    private var lineStatusTab: some TabContent<Never> {
        Tab {
            LineStatusScreen()
        } label: {
            Label(.lineStatusTabTitle, systemImage: "info.circle")
        }
        .accessibilityIdentifier("acc.id.line.status.tab.title")
    }
    
    private var journeyPlannerTab: some TabContent<Never> {
        Tab {
            JourneyPlannerScreen()
        } label: {
            Label(.journeyPlannerTabTitle, systemImage: "arrow.triangle.swap")
        }
        .accessibilityIdentifier("acc.id.journey.planner.tab.title")
    }
    
    private var liveArrivalsTab: some TabContent<Never> {
        Tab {
            ArrivalsPickerScreen()
        } label: {
            Label(.arrivalsTabTitle, systemImage: "tram")
        }
        .accessibilityIdentifier("acc.id.arrivals.tab.title")
    }
    
    private var nearbyStationsTab: some TabContent<Never> {
        Tab {
            NearbyStationsScreen()
        } label: {
            Label(.nearbyStationsTabTitle, systemImage: "location.magnifyingglass")
        }
        .accessibilityIdentifier("acc.id.nearby.stations.tab.title")
    }
    
    private var mapsTab: some TabContent<Never> {
        Tab {
            MapsScreen()
        } label: {
            Label(.mapsTabTitle, systemImage: "map")
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
