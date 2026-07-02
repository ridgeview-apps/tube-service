import DataStores
import PresentationViews
import SwiftUI


struct ManageNotificationsFlow: View {

    @Environment(\.openSettings) private var openSettings
    @Environment(\.dismiss) private var dismiss

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(PurchaseStore.self) private var purchases

    let savedNotificationSettings: [LineNotificationSettings]
    let pendingNotificationSettings: [LineNotificationSettings]
    let initialIsEnabled: Bool

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
        LineNotificationSettingsView(
            mode: .manage,
            savedItems: savedNotificationSettings,
            pendingItems: pendingNotificationSettings,
            initialIsEnabled: initialIsEnabled,
            showPermissionWarning: notifications.isPermissionDenied
        ) { action in
            switch action {
            case .cancel:
                dismiss()
            case .done(let updatedValues, let isEnabled):
                dismiss()
                Task {
                    await notifications.savePreferences(
                        update: updatedValues.toNotificationPreferencesUpdate(),
                        deviceEnabled: isEnabled
                    )
                }
            case .openSettings:
                openSettings()
            }
        }
    }
}
