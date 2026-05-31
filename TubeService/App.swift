import DataStores
import SwiftUI

@main
@MainActor
struct RootScene: App {
    
    @State private var appData: AppDataStore = .current
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .withRootEnvironment(appData: appData)
        }
    }
}

private extension AppDataStore {
    static var current: AppDataStore {
#if DEBUG
        ProcessInfo.isRunningUITests ? .stub() : .live
#else
        .live
#endif
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
