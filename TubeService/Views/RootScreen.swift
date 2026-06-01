import SwiftUI

struct RootScreen: View {
    
    @Environment(AppDataStore.self) var appData
    
    var body: some View {
        TabView {
            LineStatusScreen()
                .styledTabItem(imageName: "exclamationmark.circle",
                               title: .lineStatusTabTitle,
                               accessibilityID: "acc.id.line.status.tab.title")
            
            JourneyPlannerScreen()
                .styledTabItem(imageName: "point.topleft.down.curvedto.point.filled.bottomright.up",
                               title: .journeyPlannerTabTitle,
                               accessibilityID: "acc.id.journey.planner.tab.title")

            ArrivalsPickerScreen()
                .styledTabItem(imageName: "tram",
                               title: .arrivalsTabTitle,
                               accessibilityID: "acc.id.arrivals.tab.title")
            
            NearbyStationsScreen()
                .styledTabItem(imageName: "location",
                               title: .nearbyStationsTabTitle,
                               accessibilityID: "acc.id.nearby.stations.tab.title")
            
            MapsScreen()
                .styledTabItem(imageName: "map",
                               title: .mapsTabTitle, 
                               accessibilityID: "acc.id.maps.tab.title")
        }
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
