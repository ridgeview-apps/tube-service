import DataStores
import Models
import PresentationViews
import SwiftUI

struct LineNotificationSettingsScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openSettings) private var openSettings

    @State private var selectedOtherLine: LineSelection?
    @State private var savingState: LoadingState = .loaded

    let lineID: TrainLineID
    let showsOtherLines: Bool

    init(lineID: TrainLineID, showsOtherLines: Bool = true) {
        self.lineID = lineID
        self.showsOtherLines = showsOtherLines
    }

    var body: some View {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .singleLine(
                    lineID: lineID,
                    existingSettings: existingSettings(for: lineID),
                    showsOtherLines: showsOtherLines
                ),
                allSettings: currentLines,
                showsPermissionWarning: notifications.isPermissionDenied,
                showsPausedAlertsWarning: notifications.isDevicePaused,
                savingState: savingState,
                onAction: handleAction
            )
        }
        .sheet(item: $selectedOtherLine) { selection in
            LineNotificationSettingsScreen(lineID: selection.lineID, showsOtherLines: false)
                .iOSAppOnMacSheetEnvironment(notifications)
        }
    }

    private func handleAction(_ action: LineNotificationSettingsView.Action) {
        switch action {
        case .save(let updatedSettings):
            Task {
                var updatedLines = currentLines.filter { $0.lineID != lineID }
                updatedLines.append(updatedSettings)
                savingState = .loading
                do {
                    try await notifications.savePreferences(update: updatedLines.toNotificationPreferencesUpdate())
                    dismiss()
                } catch {
                    savingState = .failure(errorMessage: error.toSaveErrorMessage())
                }
            }
        case .remove:
            Task {
                let updatedLines = currentLines.filter { $0.lineID != lineID }
                savingState = .loading
                do {
                    try await notifications.savePreferences(update: updatedLines.toNotificationPreferencesUpdate())
                    dismiss()
                } catch {
                    savingState = .failure(errorMessage: error.toSaveErrorMessage())
                }
            }
        case .cancel:
            dismiss()
        case .navigateTo(let targetLineID):
            selectedOtherLine = LineSelection(lineID: targetLineID)
        case .toggleEnabled, .deleteAllSettings:
            break
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
        }
    }

    private func existingSettings(for lineID: TrainLineID) -> LineNotificationSettings? {
        currentLines.first { $0.lineID == lineID }
    }

    private var currentLines: [LineNotificationSettings] {
        notifications.linePreferences.toLineNotificationSettings()
    }
}

private struct LineSelection: Identifiable {
    let lineID: TrainLineID
    var id: TrainLineID { lineID }
}
