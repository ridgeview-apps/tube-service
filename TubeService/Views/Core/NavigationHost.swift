import DataStores
import PresentationViews
import SwiftUI

/// The only way to build a navigation stack: it shows `root` in a stack driven by `navigator`, which it makes
/// available to every screen inside, and presents the navigator's modal in a host of its own.
struct NavigationHost<Root: View>: View {

    @Bindable var navigator: Navigator
    @ViewBuilder let root: () -> Root

    // Only needed for iOS App on Mac sheets, which crash otherwise.
    @Environment(AppDataStore.self) private var appData
    @Environment(AppNavigator.self) private var appNavigator

    var body: some View {
        NavigationStack(path: $navigator.path) {
            root()
                .navigationDestination(for: Destination.self) { $0.screen }
        }
        .environment(navigator)
        .sheet(item: $navigator.modal) { destination in
            if ProcessInfo.processInfo.isiOSAppOnMac {
                ModalHost(destination: destination, presentingNavigator: navigator)
                    .appEnvironment(dataStore: appData, appNavigator: appNavigator)
            } else {
                ModalHost(destination: destination, presentingNavigator: navigator)
            }
        }
    }
}

extension Destination {

    @MainActor
    @ViewBuilder
    fileprivate var screen: some View {
        switch self {
        case .journeyPlanner(let destination):
            destination.screen
        case .lineStatus(let destination):
            destination.screen
        case .notifications(let destination):
            destination.screen
        case .station(let destination):
            destination.screen
        case .mapDetail(let mapLink):
            MapDetailView(mapLink: mapLink)
        case .settings:
            SettingsScreen()
        case .debugSettings:
            DebugSettingsScreen()
        case .systemStatus:
            SystemStatusScreen()
        case .paywall(let context):
            PlusGatePaywallScreen(context: context)
        }
    }
}

/// A destination presented in a host of its own. Each screen brings its own way out, through `CloseToolbarItem` or
/// `dismissModal`.
private struct ModalHost: View {

    @Environment(PurchaseStore.self) private var purchases
    // This view is the sheet's content, so its dismiss action closes the whole sheet.
    @Environment(\.dismiss) private var dismiss

    let destination: Destination
    let presentingNavigator: Navigator

    /// The gate only checks on presentation, but Plus can lapse while the modal is open.
    private var lapsedPaywallContext: PaywallContext? {
        purchases.hasTubeServicePlus ? nil : destination.paywallContext
    }

    var body: some View {
        if let modalNavigator = presentingNavigator.modalNavigator {
            NavigationHost(navigator: modalNavigator) {
                Group {
                    if let lapsedPaywallContext {
                        // Subscribing again swaps the modal's root back in.
                        TubeServicePlusView(context: lapsedPaywallContext)
                            .toolbar { CloseToolbarItem() }
                    } else {
                        destination.screen
                    }
                }
                // Inside the root, so screens pushed on top don't inherit it.
                .environment(\.isModalRoot, true)
            }
            .environment(\.dismissModal, dismiss)
            .onChange(of: lapsedPaywallContext) { _, lapsedPaywallContext in
                if lapsedPaywallContext != nil {
                    modalNavigator.popToRoot()
                }
            }
        }
    }
}

/// The paywall the Plus gate shows in place of a destination, which continues to it after a purchase.
private struct PlusGatePaywallScreen: View {

    @Environment(Navigator.self) private var navigator

    let context: PaywallContext

    var body: some View {
        TubeServicePlusView(context: context) { action in
            switch action {
            case .purchaseSuccess:
                navigator.continueAfterPurchase()
            }
        }
        .toolbar { CloseToolbarItem() }
    }
}

extension EnvironmentValues {
    /// Closes the modal a screen is shown in, even from a screen pushed inside it. `nil` outside a modal.
    @Entry var dismissModal: DismissAction?
    /// Whether a screen is the first one in its modal, where `CloseToolbarItem` shows.
    @Entry var isModalRoot = false
}
