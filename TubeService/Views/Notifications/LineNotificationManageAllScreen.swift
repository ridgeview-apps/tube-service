import DataStores
import Models
import PresentationViews
import SwiftUI

struct LineNotificationManageAllScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openSettings) private var openSettings

    @State private var savingState: LoadingState = .loaded
    @State private var sheetPresenter = SheetPresenter()

    var body: some View {
        LineNotificationManageAllView(
            isEnabled: !notifications.isDevicePaused,
            allSettings: currentLines,
            showsPermissionWarning: notifications.isPermissionDenied,
            savingState: savingState,
            onAction: handleAction
        )
        .sheetPresenter($sheetPresenter)
    }

    private func handleAction(_ action: LineNotificationManageAllView.Action) {
        switch action {
        case .cancel:
            dismiss()
        case .navigateTo(let lineID):
            sheetPresenter.show(
                .notificationsFlow(.manage(.singleLine(lineID)))
            )
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
