import DataStores
import Models
import PresentationViews
import SwiftUI

enum ManageNotificationsRoute: Hashable {
    case editLine(lineID: TrainLineID)
    case addLine(lineID: TrainLineID)
}

struct ManageNotificationsFlow: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(PurchaseStore.self) private var purchases

    let mode: NotificationsFlow.Context.ManageMode

    var body: some View {
        if !purchases.hasTubeServicePlus {
            NavigationStack {
                TubeServicePlusView(context: .notifications)
            }
        } else {
            ManageNotificationsStack(
                mode: mode,
                isLineSetUp: { lineID in
                    notifications.linePreferences.toLineNotificationSettings().contains { $0.lineID == lineID }
                }
            )
        }
    }
}

/// The navigation stack behind `ManageNotificationsFlow`, created once Tube Service Plus is unlocked so it can
/// start with the line's editor already on the path rather than pushing it after the sheet appears.
private struct ManageNotificationsStack: View {

    @Environment(\.dismiss) private var dismissSheet

    /// The line the flow was opened for, whose screen starts pushed over the list of all lines.
    @State private var openedLineID: TrainLineID?
    @State private var manageNotificationsRouter: Router<ManageNotificationsRoute>

    init(mode: NotificationsFlow.Context.ManageMode, isLineSetUp: (TrainLineID) -> Bool) {
        let router = Router<ManageNotificationsRoute>()
        switch mode {
        case let .singleLine(lineID):
            _openedLineID = State(initialValue: lineID)
            router.navigation.path = [isLineSetUp(lineID) ? .editLine(lineID: lineID) : .addLine(lineID: lineID)]
        case .all:
            _openedLineID = State(initialValue: nil)
        }
        _manageNotificationsRouter = State(initialValue: router)
    }

    var body: some View {
        NavigationStack(path: $manageNotificationsRouter.navigation.path) {
            ManageAllLineNotificationsScreen()
                .navigationDestination(for: ManageNotificationsRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(manageNotificationsRouter)
    }

    private func destinationView(for route: ManageNotificationsRoute) -> some View {
        let lineID =
            switch route {
            case .editLine(let lineID), .addLine(let lineID): lineID
            }
        // Back returns to the list, so the close button closes the whole sheet. Turning on the line the flow was
        // opened for finishes what the user came to do, so it closes the sheet too; a line added from the list
        // goes back to the list.
        return ManageSingleLineNotificationsScreen(
            lineID: lineID,
            onClose: { dismissSheet() },
            onAdded: {
                if lineID == openedLineID {
                    dismissSheet()
                } else {
                    manageNotificationsRouter.navigation.goBack()
                }
            }
        )
    }
}
