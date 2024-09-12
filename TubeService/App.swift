import DataStores
import SwiftUI

@main
@MainActor
struct RootScene: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appData = AppDataStore.shared
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environment(appData)
                .withEnvironmentDataStores(lineStatus: appData.lineStatus,
                                           stations: appData.stations,
                                           location: appData.location,
                                           localSearchCompleter: appData.localSearchCompleter)
        }
    }
}


// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.migrateLegacyValuesIfNeeded()
        return true
    }
}


extension View {
    
    func withEnvironmentDataStores(lineStatus: LineStatusDataStore,
                                   stations: StationsDataStore,
                                   location: LocationDataStore,
                                   localSearchCompleter: LocalSearchCompleter) -> some View {
        self
            .environment(lineStatus)
            .environment(stations)
            .environment(location)
            .environment(localSearchCompleter)
    }
}
