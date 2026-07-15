import DataStores
import PresentationViews
import SwiftUI


struct ManageNotificationsFlow: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(PurchaseStore.self) private var purchases

    let mode: NotificationsFlow.Context.ManageMode

    var body: some View {
        NavigationStack {
            rootView
        }
    }

    @ViewBuilder
    private var rootView: some View {
        if !purchases.hasTubeServicePlus {
            paywallView
        } else {
            switch mode {
            case let .singleLine(lineID):
                ManageSingleLineNotificationsScreen(lineID: lineID, showsOtherLines: true)
            case .all:
                ManageAllLineNotificationsScreen()
            }
        }
    }

    private var paywallView: some View {
        TubeServicePlusView(context: .notifications)
    }
}
