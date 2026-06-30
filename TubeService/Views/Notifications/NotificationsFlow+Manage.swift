import DataStores
import PresentationViews
import SwiftUI


struct ManageNotificationsFlow: View {

    @Environment(\.openSettings) private var openSettings
    @Environment(\.dismiss) private var dismiss

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(PurchaseStore.self) private var purchases

    let initialNotificationSettings: [LineNotificationSettings]
    let initialIsMuted: Bool
    @State private var updatedNotificationSettings = [LineNotificationSettings]()

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
            lineSettingsView
        }
    }

    private var paywallView: some View {
        TubeServicePlusView(context: .notifications)
    }

    private var lineSettingsView: some View {
        NotificationSettingsView(
            mode: .manage,
            initialItems: initialNotificationSettings,
            initialIsMuted: false,
            showPermissionWarning: notifications.isPermissionDenied
        ) { action in
            switch action {
            case .cancel:
                dismiss()
            case .done(let updatedValues, _):
                updatedNotificationSettings = updatedValues
                saveUpdatedSettingsAndFinish()
            case .openSettings:
                openSettings()
            }
        }
    }

    private func saveUpdatedSettingsAndFinish() {
        Task {
            await notifications.requestAuthorizationAndRefreshStatus()
            if notifications.isPermissionDenied {
                notifications.schedulePreferencesUpdate(updatedNotificationSettings.toNotificationPreferencesUpdate())
                dismiss()
            }
        }
    }
}
