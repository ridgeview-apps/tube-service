import DataStores
import SwiftUI

@main
struct RootScene: App {
    
    @State private var appData: AppDataStore
    
    init() {
        appData = Self.makeAppDataStore()
    }
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environment(appData)
                .withEnvironmentDataStores(lineStatus: appData.lineStatus,
                                           stations: appData.stations,
                                           userPreferences: appData.userPreferences,
                                           location: appData.location)
        }
    }
    
    @MainActor
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
            .environment(lineStatus)
            .environment(stations)
            .environment(userPreferences)
            .environment(location)
    }
}
