import DataStores
import PresentationViews
import SwiftUI


struct ManageNotificationsFlow: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(PurchaseStore.self) private var purchases

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
            LineNotificationManageScreen()
        }
    }

    private var paywallView: some View {
        TubeServicePlusView(context: .notifications)
    }
}
