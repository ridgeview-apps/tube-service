import DataStores
import Models
import Observation
import PresentationViews

// MARK: - Destination

enum Destination: Hashable {
    case journeyResults
    case lineStatusDetail(lineID: TrainLineID, request: LineStatusDataStore.LineStatusRequest)
    case lineStatusHistory(lineID: TrainLineID)
    case station(Station)
    case mapDetail(mapLink: MapLink)
    case debugSettings

    /// The paywall to show first, for a destination that needs Tube Service Plus.
    var paywallContext: PaywallContext? {
        switch self {
        case .lineStatusHistory: .statusHistory
        case .journeyResults, .lineStatusDetail, .station, .mapDetail, .debugSettings: nil
        }
    }
}

// MARK: - Modal

enum Modal: Hashable, Identifiable {
    case settings
    case systemStatus
    case journeyLocationPicker(JourneyPlannerForm.FieldID.LocationID)
    case journeyModePicker
    case notifications(lineID: TrainLineID?)
    /// Shown by the Plus gate rather than presented directly.
    case paywall(PaywallContext)

    var id: Self { self }

    /// The paywall to show first, for a modal that needs Tube Service Plus.
    var paywallContext: PaywallContext? {
        switch self {
        case .settings, .systemStatus, .journeyLocationPicker, .journeyModePicker, .notifications, .paywall: nil
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
        case present(Modal)
    }

    var path: [Destination] = []
    var modal: Modal?

    /// The navigator of the host that shows `modal`.
    private(set) var modalNavigator: Navigator?

    /// What to continue to once the paywall shown in its place completes a purchase.
    private var requestAwaitingPurchase: Request?

    private let purchases: PurchaseStore

    init(purchases: PurchaseStore) {
        self.purchases = purchases
    }

    func push(_ destination: Destination) {
        perform(.push(destination), paywallContext: destination.paywallContext)
    }

    func present(_ modal: Modal) {
        perform(.present(modal), paywallContext: modal.paywallContext)
    }

    func dismissModal() {
        modal = nil
    }

    func popToRoot() {
        path = []
    }

    /// Called by the paywall the Plus gate showed.
    func continueAfterPurchase() {
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
        case .present(let modal):
            show(modal)
        }
    }

    private func show(_ modal: Modal) {
        modalNavigator = Navigator(purchases: purchases)
        self.modal = modal
    }
}
