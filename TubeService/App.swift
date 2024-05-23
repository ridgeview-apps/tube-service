import DataStores
import SwiftUI

@main
@MainActor
struct RootScene: App {
    @State private var appData = AppDataStore.shared
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environment(appData)
                .withEnvironmentDataStores(lineStatus: appData.lineStatus,
                                           stations: appData.stations,
                                           userPreferences: appData.userPreferences,
                                           location: appData.location,
                                           localSearchCompleter: appData.localSearchCompleter)
        }
    }
}


extension View {
    
    func withEnvironmentDataStores(lineStatus: LineStatusDataStore,
                                   stations: StationsDataStore,
                                   userPreferences: UserPreferencesDataStore,
                                   location: LocationDataStore,
                                   localSearchCompleter: LocalSearchCompleter) -> some View {
        self
            .environment(lineStatus)
            .environment(stations)
            .environment(userPreferences)
            .environment(location)
            .environment(localSearchCompleter)
    }
}
