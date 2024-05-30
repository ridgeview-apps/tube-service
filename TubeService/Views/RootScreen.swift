import SwiftUI

struct RootScreen: View {
    
    var body: some View {
        TabView {
            LineStatusScreen()
                .styledTabItem(imageName: "exclamationmark.circle",
                               title: .lineStatusTabTitle,
                               accessibilityID: "acc.id.line.status.tab.title")
            
            JourneyPlannerScreen()
                .styledTabItem(imageName: "app.connected.to.app.below.fill",
                               title: .journeyPlannerTabTitle,
                               accessibilityID: "acc.id.journey.planner.tab.title")

            ArrivalsPickerScreen()
                .styledTabItem(imageName: "tram.fill",
                               title: .arrivalsTabTitle,
                               accessibilityID: "acc.id.arrivals.tab.title")
            
            NearbyStationsScreen()
                .styledTabItem(imageName: "location.fill",
                               title: .nearbyStationsTabTitle,
                               accessibilityID: "acc.id.nearby.stations.tab.title")
            
            MapsScreen()
                .styledTabItem(imageName: "map.fill",
                               title: .mapsTabTitle, 
                               accessibilityID: "acc.id.maps.tab.title")
        }
    }
}


// MARK: - Previews

#if DEBUG

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        return RootScreen()
                .withStubbedEnvironment()
    }
}

#endif
