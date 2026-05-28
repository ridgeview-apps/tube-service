import DataStores
import SwiftUI

@main
@MainActor
struct RootScene: App {
    
    @State private var appData: AppDataStore
    
    init() {
        if ProcessInfo.isRunningUITests {
            appData = .stub()
        } else {
            appData = .live
        }
    }
    
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
            .environment(appData.localSearchCompleter)
            .environment(appData.systemStatus)
    }
}
