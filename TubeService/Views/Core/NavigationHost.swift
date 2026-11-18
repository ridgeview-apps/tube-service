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
                .navigationDestination(for: Destination.self, destination: destinationView)
        }
        .environment(navigator)
        .sheet(item: $navigator.modal) { modal in
            if ProcessInfo.processInfo.isiOSAppOnMac {
                ModalHost(modal: modal, presentingNavigator: navigator)
                    .appEnvironment(dataStore: appData, appNavigator: appNavigator)
            } else {
                ModalHost(modal: modal, presentingNavigator: navigator)
            }
        }
    }

    @ViewBuilder
    private func destinationView(_ destination: Destination) -> some View {
        switch destination {
        case .journeyResults:
            JourneyResultsScreen()
        case .lineStatusDetail(let lineID, let request):
            LineStatusDetailScreen(lineID: lineID, request: request)
        case .lineStatusHistory(let lineID):
            LineStatusHistoryScreen(lineID: lineID)
        case .station(let station):
            StationScreen(station: station)
        case .mapDetail(let mapLink):
            MapDetailView(mapLink: mapLink)
        case .debugSettings:
            DebugSettingsScreen()
        }
    }
}

/// A modal in a host of its own, with a close button unless the screen has its own way out.
private struct ModalHost: View {

    let modal: Modal
    let presentingNavigator: Navigator

    var body: some View {
        if case .notifications(let lineID) = modal {
            // The notifications flows still build their own stacks.
            NotificationsFlow(lineID: lineID)
        } else if let modalNavigator = presentingNavigator.modalNavigator {
            NavigationHost(navigator: modalNavigator) {
                root
            }
        }
    }

    @ViewBuilder
    private var root: some View {
        switch modal {
        case .settings:
            SettingsScreen()
                .withCloseToolbarButton()
        case .systemStatus:
            SystemStatusScreen()
                .withCloseToolbarButton()
        case .journeyLocationPicker(let fieldID):
            JourneyLocationPickerScreen(fieldID: fieldID)
                .withCloseToolbarButton()
        case .journeyModePicker:
            JourneyModePickerScreen()
        case .paywall(let context):
            TubeServicePlusView(context: context) { action in
                switch action {
                case .purchaseSuccess:
                    presentingNavigator.continueAfterPurchase()
                }
            }
            .withCloseToolbarButton()
        case .notifications:
            EmptyView()
        }
    }
}
