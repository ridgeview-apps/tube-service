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
                .withRootEnvironment(appData: appData)
        }
    }
}


// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppDataStore.shared.userDefaults.migrateLegacyValuesIfNeeded()
        return true
    }
}


extension View {
    
    func withRootEnvironment(appData: AppDataStore) -> some View {
        self
            .rootSheetPresenter()
            .environment(appData)
            .environment(appData.lineStatus)
            .environment(appData.stations)
            .environment(appData.location)
            .environment(appData.localSearchCompleter)
            .environment(appData.systemStatus)
    }
}
