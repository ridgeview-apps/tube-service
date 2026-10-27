import DataStores
import Models
import PresentationViews
import SwiftUI

enum ManageNotificationsRoute: Hashable {
    case editLine(lineID: TrainLineID)
    case addLine(lineID: TrainLineID)
}

struct ManageNotificationsFlow: View {

    @Environment(PurchaseStore.self) private var purchases

    let mode: NotificationsFlow.Context.ManageMode

    var body: some View {
        if !purchases.hasTubeServicePlus {
            NavigationStack {
                TubeServicePlusView(context: .notifications)
            }
        } else {
            ManageNotificationsStack(mode: mode)
        }
    }
}

/// The navigation stack behind `ManageNotificationsFlow`, shown once Tube Service Plus is unlocked.
private struct ManageNotificationsStack: View {

    @Environment(\.dismiss) private var dismissSheet

    @State private var manageNotificationsRouter = Router<ManageNotificationsRoute>()

    let mode: NotificationsFlow.Context.ManageMode

    var body: some View {
        NavigationStack(path: $manageNotificationsRouter.navigation.path) {
            rootView
                .navigationDestination(for: ManageNotificationsRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(manageNotificationsRouter)
    }

    /// A line opened from its status screen is the root, so there's nothing to go back to. Once it's set up it
    /// lists the other lines below its settings; until then it stays focused on turning it on, which finishes what
    /// the user came to do and closes the sheet.
    @ViewBuilder
    private var rootView: some View {
        switch mode {
        case let .singleLine(lineID):
            ManageSingleLineNotificationsScreen(
                lineID: lineID,
                showsOtherLines: true,
                onClose: { dismissSheet() },
                onAdded: { dismissSheet() }
            )
        case .all:
            ManageAllLineNotificationsScreen()
        }
    }

    /// Pushed screens keep their close button closing the whole sheet. A line added from the list goes back to the
    /// list, so several can be added in a row.
    private func destinationView(for route: ManageNotificationsRoute) -> some View {
        let lineID =
            switch route {
            case .editLine(let lineID), .addLine(let lineID): lineID
            }
        return ManageSingleLineNotificationsScreen(
            lineID: lineID,
            showsOtherLines: false,
            onClose: { dismissSheet() },
            onAdded: { manageNotificationsRouter.navigation.goBack() }
        )
    }
}
