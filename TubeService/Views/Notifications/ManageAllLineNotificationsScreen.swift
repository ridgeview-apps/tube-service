import DataStores
import Models
import PresentationViews
import SwiftUI

struct ManageAllLineNotificationsScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openSettings) private var openSettings
    @Environment(Router<ManageNotificationsRoute>.self) private var manageNotificationsRouter

    @State private var savingState: LoadingState = .loaded

    var body: some View {
        ManageAllLineNotificationsView(
            isEnabled: !notifications.isDevicePaused,
            allSettings: currentLines,
            showsPermissionWarning: notifications.isPermissionDenied,
            savingState: savingState,
            onAction: handleAction
        )
    }

    private func handleAction(_ action: ManageAllLineNotificationsView.Action) {
        switch action {
        case .cancel:
            dismiss()
        case .tappedOtherLine(let otherLineID):
            manageNotificationsRouter.navigation.push(.editLine(lineID: otherLineID))
        case .addedLine(let otherLineID):
            manageNotificationsRouter.navigation.push(.addLine(lineID: otherLineID))
        case .openSettings:
            openSettings()
        case .toggleEnabled(let enabled):
            Task {
                savingState = .loading
                do {
                    if enabled {
                        try await notifications.enableDevice()
                    } else {
                        try await notifications.disableDevice()
                    }
                    savingState = .loaded
                } catch {
                    savingState = .failure(errorMessage: error.toSaveErrorMessage())
                }
            }
        case .deleteAllSettings:
            Task {
                savingState = .loading
                do {
                    try await notifications.deleteDevice()
                    dismiss()
                } catch {
                    savingState = .failure(errorMessage: error.toSaveErrorMessage())
                }
            }
        }
    }

    private var currentLines: [LineNotificationSettings] {
        notifications.linePreferences.toLineNotificationSettings()
    }
}
