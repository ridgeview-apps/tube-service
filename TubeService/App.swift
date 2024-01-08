import DataStores
import SwiftUI

@main
struct RootScene: App {
    
    @StateObject private var appData = makeAppDataStore()
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(appData)
                .withEnvironmentDataStores(lineStatus: appData.lineStatus,
                                           stations: appData.stations,
                                           userPreferences: appData.userPreferences,
                                           location: appData.location)
        }
    }
    
    private static func makeAppDataStore() -> AppDataStore {
#if DEBUG
        if ProcessInfo.isRunningUITests { return .stub() }
#endif
        
        return .real
    }
}


extension View {
    
    func withEnvironmentDataStores(lineStatus: LineStatusDataStore,
                                   stations: StationsDataStore,
                                   userPreferences: UserPreferencesDataStore,
                                   location: LocationDataStore) -> some View {
        self
            .environmentObject(lineStatus)
            .environmentObject(stations)
            .environmentObject(userPreferences)
            .environmentObject(location)
    }
}
