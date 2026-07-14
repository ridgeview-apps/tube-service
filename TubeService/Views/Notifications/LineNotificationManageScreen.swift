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
    @State private var isEnabled: Bool = true

    var body: some View {
        LineNotificationSettingsView(
            mode: .manageAll(isEnabled: $isEnabled),
            allSettings: currentLines,
            showsPermissionWarning: notifications.isPermissionDenied,
            savingState: savingState,
            onAction: handleAction
        )
        .onChange(of: notifications.isDevicePaused, initial: true) { _, isPaused in
            isEnabled = !isPaused
        }
        .sheet(item: $selectedLine) { selection in
            LineNotificationSettingsScreen(lineID: selection.lineID, showsOtherLines: false)
                .iOSAppOnMacSheetEnvironment(notifications)
        }
    }

    private func handleAction(_ action: LineNotificationSettingsView.Action) {
        switch action {
        case .cancel:
            dismiss()
        case .navigateTo(let lineID):
            selectedLine = LineSelection(lineID: lineID)
        case .openSettings:
            openSettings()
        case .manageAll(let manageAction):
            handleManageAllAction(manageAction)
        case .singleLine:
            break
        }
    }

    private func handleManageAllAction(_ action: LineNotificationSettingsView.Action.ManageAllAction) {
        switch action {
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
                    isEnabled = !notifications.isDevicePaused
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

private struct LineSelection: Identifiable {
    let lineID: TrainLineID
    var id: TrainLineID { lineID }
}
