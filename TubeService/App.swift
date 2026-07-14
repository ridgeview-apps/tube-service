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

// MARK: - Environment objects

extension View {

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

// MARK: - Sheets

extension View {
    func appSheetRouter(_ sheetRouter: Binding<SheetRouter>) -> some View {
        self
            .modifier(AppSheetRouterModifier(sheetRouter: sheetRouter))
    }
}

private struct AppSheetRouterModifier: ViewModifier {
    @Binding var sheetRouter: SheetRouter

    // These are only needed for iOS App on Mac sheets to work (they crash otherwise)
    @Environment(AppDataStore.self) private var macSheetDataStore
    @Environment(AppRouter.self) private var macSheetRouter

    func body(content: Content) -> some View {
        content
            .sheet(item: $sheetRouter.presentedSheet) { sheet in
                sheetContentView(sheet)
            }
            .fullScreenCover(item: $sheetRouter.presentedFullScreenSheet) { sheet in
                sheetContentView(sheet)
            }
    }

    @ViewBuilder
    private func sheetContentView(_ sheet: Sheet) -> some View {
        if ProcessInfo.processInfo.isiOSAppOnMac {
            SheetView(sheet: sheet)
                .appEnvironment(
                    dataStore: macSheetDataStore,
                    router: macSheetRouter
                )
        } else {
            SheetView(sheet: sheet)
        }
    }
}
