import DataStores
import Shared
import SwiftUI

@main
@MainActor
struct RootScene: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appData = AppDataStore(dependencies: .current)
    @State private var appNavigator = AppNavigator()

    init() {
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
                    .sheetPresenter($appNavigator.sheetPresenter)
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
    @Environment(AppNavigator.self) private var appNavigator

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
                    appNavigator: appNavigator
                )
        } else {
            SheetView(sheet: sheet)
        }
    }
}
