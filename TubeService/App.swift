import DataStores
import SwiftUI

@main
@MainActor
struct RootScene: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appData = AppDataStore(dependencies: .current)
    @State private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.isRunningUnitTests {
                Text("Running unit tests...")
            } else {
                RootScreen()
                    .sheetPresenter($appRouter.sheetPresenter)
                    .appLifecycle(appData: appData, appDelegate: appDelegate, router: appRouter)
                    .appEnvironment(dataStore: appData, router: appRouter)
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
    func sheetPresenter(_ sheetPresenter: Binding<SheetPresenter>) -> some View {
        self
            .modifier(SheetPresenterModifier(sheetPresenter: sheetPresenter))
    }
}

private struct SheetPresenterModifier: ViewModifier {
    @Binding var sheetPresenter: SheetPresenter

    // These are only needed for iOS App on Mac sheets to work (they crash otherwise)
    @Environment(AppDataStore.self) private var appData
    @Environment(AppRouter.self) private var appRouter

    func body(content: Content) -> some View {
        content
            .sheet(item: $sheetPresenter.presentedSheet) { sheet in
                sheetContentView(sheet)
            }
            .fullScreenCover(item: $sheetPresenter.presentedFullScreenSheet) { sheet in
                sheetContentView(sheet)
            }
    }

    @ViewBuilder
    private func sheetContentView(_ sheet: Sheet) -> some View {
        if ProcessInfo.processInfo.isiOSAppOnMac {
            SheetView(sheet: sheet)
                .appEnvironment(
                    dataStore: appData,
                    router: appRouter
                )
        } else {
            SheetView(sheet: sheet)
        }
    }
}
