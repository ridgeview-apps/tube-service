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

    @State private var manageNotificationsRouter = Router<ManageNotificationsRoute>()
    @Namespace private var zoomNamespace

    var body: some View {
        NavigationStack(path: $manageNotificationsRouter.navigation.path) {
            rootView
                .navigationDestination(for: ManageNotificationsRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(manageNotificationsRouter)
        .environment(\.lineSelectionZoomNamespace, zoomNamespace)
    }

    @ViewBuilder
    private var rootView: some View {
        if !purchases.hasTubeServicePlus {
            paywallView
        } else {
            Group {
                switch mode {
                case let .singleLine(lineID):
                    ManageSingleLineNotificationsScreen(lineID: lineID, showsOtherLines: true)
                case .all:
                    ManageAllLineNotificationsScreen()
                }
            }
        }
    }

    private var paywallView: some View {
        TubeServicePlusView(context: .notifications)
    }

    @ViewBuilder
    private func destinationView(for route: ManageNotificationsRoute) -> some View {
        switch route {
        case .editLine(let lineID):
            manageSingleLineScreen(lineID: lineID, zoomSourceID: lineID)
        case .addLine(let lineID):
            manageSingleLineScreen(lineID: lineID, zoomSourceID: "addLineMenu")
        }
    }

    private func manageSingleLineScreen(lineID: TrainLineID, zoomSourceID: some Hashable) -> some View {
        ManageSingleLineNotificationsScreen(lineID: lineID, showsOtherLines: false)
            .navigationBarBackButtonHidden()
            .navigationTransition(.zoom(sourceID: zoomSourceID, in: zoomNamespace))

    }
}
