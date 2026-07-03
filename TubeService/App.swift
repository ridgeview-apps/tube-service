import DataStores
import SwiftUI

@main
@MainActor
struct RootScene: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appData = AppDataStore(dependencies: .current)
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.isRunningUnitTests {
                Text("Running unit tests...")
            } else {
                RootScreen()
                    .appSheetRouter($router.sheetRouter)
                    .appLifecycle(appData: appData, appDelegate: appDelegate, router: router)
                    .appEnvironment(dataStore: appData, router: router)
            }
        }
    }
}

extension View {

    func appSheetRouter(_ sheetRouter: Binding<SheetRouter>) -> some View {
        self
            .sheet(item: sheetRouter.presentedSheet) { sheet in
                SheetView(sheet: sheet)
            }
            .fullScreenCover(item: sheetRouter.presentedFullScreenSheet) { sheet in
                SheetView(sheet: sheet)
            }
    }

    func appEnvironment(
        dataStore: AppDataStore,
        router: AppRouter
    ) -> some View {
        self
            .environment(router)
            .environment(dataStore)
            .environment(dataStore.lineStatus)
            .environment(dataStore.stations)
            .environment(dataStore.location)
            .environment(dataStore.localSearchResults)
            .environment(dataStore.systemStatus)
            .environment(dataStore.purchases)
            .environment(dataStore.notifications)
            .environment(dataStore.journeyPlanner)
    }
}
