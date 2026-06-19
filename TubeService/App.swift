import DataStores
import SwiftUI

@main
@MainActor
struct RootScene: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appData = AppDataStore(dependencies: .current)

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.isRunningUnitTests {
                Text("Running unit tests...")
            } else {
                RootScreen()
                    .appLifecycle(appData: appData, appDelegate: appDelegate)
                    .withAppEnvironment(dataStore: appData)
            }
        }
    }
}

extension View {

    func withAppEnvironment(dataStore: AppDataStore) -> some View {
        self
            .rootSheetPresenter()
            .environment(dataStore)
            .environment(dataStore.lineStatus)
            .environment(dataStore.stations)
            .environment(dataStore.location)
            .environment(dataStore.localSearchResults)
            .environment(dataStore.systemStatus)
            .environment(dataStore.purchases)
            .environment(dataStore.notifications)
    }
}
