import DataStores
import Shared
import SwiftUI

@main
@MainActor
struct RootScene: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appData: AppDataStore
    @State private var appNavigator: AppNavigator

    init() {
        let appData = AppDataStore(dependencies: .current)
        _appData = State(initialValue: appData)
        _appNavigator = State(initialValue: AppNavigator(purchases: appData.purchases))
        #if DEBUG
            TubeUITestLaunchConfiguration.fromProcessEnvironment()?.applyProcessSettings()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.isRunningUnitTests {
                Text("Running unit tests...")
            } else {
                RootScreen()
                    .appLifecycle(appData: appData, appDelegate: appDelegate, appNavigator: appNavigator)
                    .appEnvironment(dataStore: appData, appNavigator: appNavigator)
            }
        }
    }
}

// MARK: - Environment objects

extension View {

    func appEnvironment(
        dataStore: AppDataStore,
        appNavigator: AppNavigator
    ) -> some View {
        self
            .environment(appNavigator)
            .environment(dataStore)
            .environment(dataStore.lineStatus)
            .environment(dataStore.stations)
            .environment(dataStore.busStops)
            .environment(dataStore.location)
            .environment(dataStore.localSearchResults)
            .environment(dataStore.systemStatus)
            .environment(dataStore.purchases)
            .environment(dataStore.notifications)
            .environment(dataStore.journeyPlanner)
            .environment(\.clock, dataStore.clock)
            .environment(\.pausesRepeatingAnimations, ProcessInfo.isRunningUITests)
            // The iPad otherwise restores whichever layout it last showed, which would change the screenshots. On iOS
            // 27 the forced sidebar logs "Modifying state during view update" at launch and, in portrait, swallows
            // some taps, so UI tests run the iPad in landscape (see UITestCase).
            .environment(\.adaptableTabBarPlacement, ProcessInfo.isRunningUITests ? .sidebar : .automatic)
    }
}
