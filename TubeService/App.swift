import DataStores
import SwiftUI

@main
@MainActor
struct RootScene: App {

    @State private var appData = AppDataStore(dependencies: .current)

    var body: some Scene {
        WindowGroup {
            RootScreen()
                .withAppEnvironment(dataStore: appData)
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
    }
}
