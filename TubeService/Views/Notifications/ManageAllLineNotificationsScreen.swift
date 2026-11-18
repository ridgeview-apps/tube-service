import DataStores
import Models
import PresentationViews
import SwiftUI

struct ManageAllLineNotificationsScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openSettings) private var openSettings
    @Environment(Navigator.self) private var navigator

    @State private var savingState: LoadingState = .loaded

    var body: some View {
        ManageAllLineNotificationsView(
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
        case .tappedOtherLine(let otherLineID), .addedLine(let otherLineID):
            navigator.push(.notifications(.line(lineID: otherLineID)))
        case .openSettings:
            openSettings()
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
