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
            PaywallScreen(context: context, continuesAfterPurchase: true)
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
                        PaywallScreen(context: lapsedPaywallContext)
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

/// The paywall, shown by the Plus gate in place of a destination and when Plus lapses while a modal is open.
private struct PaywallScreen: View {

    @Environment(Navigator.self) private var navigator

    let context: PaywallContext
    /// Only the gate's paywall continues: a lapsed modal's own root swaps back in after a purchase.
    var continuesAfterPurchase = false

    var body: some View {
        TubeServicePlusView(context: context) { action in
            switch action {
            case .purchaseSuccess:
                if continuesAfterPurchase {
                    navigator.continueAfterPurchase()
                }
            }
        }
        .navigationTitle(Text(L10n.tubeServicePlusNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { CloseToolbarItem() }
    }
}

extension EnvironmentValues {
    /// Closes the modal a screen is shown in, even from a screen pushed inside it. `nil` outside a modal.
    @Entry var dismissModal: DismissAction?
    /// Whether a screen is the first one in its modal, where `CloseToolbarItem` shows.
    @Entry var isModalRoot = false
}
