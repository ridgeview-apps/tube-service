import DataStores
import SwiftUI

@main
@MainActor
struct RootScene: App {
    
    @State private var appData = AppDataStore(dependencies: .current)
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .withRootEnvironment(appData: appData)
        }
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
            .environment(appData.localSearchResults)
            .environment(appData.systemStatus)
    }
}
