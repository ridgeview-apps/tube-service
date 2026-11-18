import DataStores
import Models
import Observation
import PresentationViews

// MARK: - Destination

/// A screen to push or present: the caller decides which.
enum Destination: Hashable, Identifiable {
    case journeyPlanner(JourneyPlannerDestination)
    case lineStatus(LineStatusDestination)
    case notifications(NotificationsDestination)
    case station(Station)
    case mapDetail(mapLink: MapLink)
    case settings
    case debugSettings
    case systemStatus
    /// Shown by the Plus gate rather than pushed or presented directly.
    case paywall(PaywallContext)

    var id: Self { self }

    /// The paywall to show first, for a destination that needs Tube Service Plus.
    var paywallContext: PaywallContext? {
        switch self {
        case .lineStatus(let destination): destination.paywallContext
        case .notifications(let destination): destination.paywallContext
        case .journeyPlanner, .station, .mapDetail, .settings, .debugSettings, .systemStatus, .paywall: nil
        }
    }

    /// Whether the screen brings its own way out when presented, so its host doesn't add a close button.
    var hasOwnCloseButton: Bool {
        switch self {
        case .journeyPlanner(let destination): destination.hasOwnCloseButton
        case .notifications(let destination): destination.hasOwnCloseButton
        case .lineStatus, .station, .mapDetail, .settings, .debugSettings, .systemStatus, .paywall: false
        }
    }
}

// MARK: - Navigator

/// The navigation stack and modal of one `NavigationHost`. Screens push and present through the nearest one in the
/// environment, so they work the same whichever host shows them.
@Observable
@MainActor
final class Navigator {

    private enum Request {
        case push(Destination)
        case present(Destination)
    }

    var path: [Destination] = []
    var modal: Destination?

    /// The navigator of the host that shows `modal`.
    private(set) var modalNavigator: Navigator?

    /// The navigator whose modal this one's host is shown in.
    @ObservationIgnored private weak var presentingNavigator: Navigator?

    /// What to continue to once the paywall shown in its place completes a purchase.
    private var requestAwaitingPurchase: Request?

    private let purchases: PurchaseStore

    init(purchases: PurchaseStore) {
        self.purchases = purchases
    }

    func push(_ destination: Destination) {
        perform(.push(destination), paywallContext: destination.paywallContext)
    }

    func present(_ destination: Destination) {
        perform(.present(destination), paywallContext: destination.paywallContext)
    }

    func dismissModal() {
        modal = nil
    }

    /// Closes the modal this navigator's host is shown in, from any screen in its stack.
    func dismissPresentingModal() {
        guard let presentingNavigator else {
            assertionFailure("Not shown in a modal: was a destination that closes its modal pushed instead?")
            return
        }
        presentingNavigator.dismissModal()
    }

    func popToRoot() {
        path = []
    }

    /// Called by the Plus gate's paywall, from the modal it's shown in.
    func continueAfterPurchase() {
        guard let presentingNavigator else {
            assertionFailure("The Plus gate's paywall is only ever presented")
            return
        }
        presentingNavigator.resumeRequestAwaitingPurchase()
    }

    private func resumeRequestAwaitingPurchase() {
        dismissModal()
        guard let request = requestAwaitingPurchase else { return }
        requestAwaitingPurchase = nil
        perform(request, paywallContext: nil)
    }

    private func perform(_ request: Request, paywallContext: PaywallContext?) {
        if let paywallContext, !purchases.hasTubeServicePlus {
            requestAwaitingPurchase = request
            show(.paywall(paywallContext))
            return
        }
        switch request {
        case .push(let destination):
            path.append(destination)
        case .present(let destination):
            show(destination)
        }
    }

    private func show(_ destination: Destination) {
        let modalNavigator = Navigator(purchases: purchases)
        modalNavigator.presentingNavigator = self
        self.modalNavigator = modalNavigator
        modal = destination
    }
}
