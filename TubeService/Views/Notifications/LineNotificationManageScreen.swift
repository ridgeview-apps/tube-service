import DataStores
import Models
import PresentationViews
import SwiftUI

struct LineNotificationManageScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openSettings) private var openSettings

    @State private var selectedLine: LineSelection?
    @State private var savingState: LoadingState = .loaded

    var body: some View {
        LineNotificationSettingsView(
            mode: .manageAll(isEnabled: notifications.device?.enabled ?? true),
            allSettings: currentLines,
            showsPermissionWarning: notifications.isPermissionDenied,
            savingState: savingState,
            onAction: handleAction
        )
        .sheet(item: $selectedLine) { selection in
            LineNotificationSettingsScreen(lineID: selection.lineID, showsOtherLines: false)
                .iOSAppOnMacSheetEnvironment(notifications)
        }
    }

    private func handleAction(_ action: LineNotificationSettingsView.Action) {
        switch action {
        case .navigateTo(let lineID):
            selectedLine = LineSelection(lineID: lineID)
        case .toggleEnabled(let isEnabled):
            Task {
                savingState = .loading
                do {
                    if isEnabled {
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
        case .cancel:
            dismiss()
        case .openSettings:
            openSettings()
        case .resumeAlerts:
            Task {
                savingState = .loading
                do {
                    try await notifications.enableDevice()
                    savingState = .loaded
                } catch {
                    savingState = .failure(errorMessage: error.toSaveErrorMessage())
                }
            }
        case .save, .remove:
            break
        }
    }

    private var currentLines: [LineNotificationSettings] {
        notifications.preferences?.lines.toLineNotificationSettings() ?? []
    }
}

private struct LineSelection: Identifiable {
    let lineID: TrainLineID
    var id: TrainLineID { lineID }
}
