import DataStores
import Models
import PresentationViews
import SwiftUI

struct LineNotificationSettingsScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss

    @State private var selectedOtherLine: LineSelection?

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
            dismiss()
            Task {
                var updatedLines = currentLines.filter { $0.lineID != lineID }
                updatedLines.append(updatedSettings)
                await notifications.savePreferences(
                    update: updatedLines.toNotificationPreferencesUpdate(),
                    deviceEnabled: notifications.device?.enabled ?? true
                )
            }
        case .remove:
            dismiss()
            Task {
                let updatedLines = currentLines.filter { $0.lineID != lineID }
                await notifications.savePreferences(
                    update: updatedLines.toNotificationPreferencesUpdate(),
                    deviceEnabled: notifications.device?.enabled ?? true
                )
            }
        case .cancel:
            dismiss()
        case .navigateTo(let targetLineID):
            selectedOtherLine = LineSelection(lineID: targetLineID)
        case .toggleEnabled, .deleteAllSettings:
            break
        }
    }

    private func existingSettings(for lineID: TrainLineID) -> LineNotificationSettings? {
        currentLines.first { $0.lineID == lineID }
    }

    private var currentLines: [LineNotificationSettings] {
        notifications.preferences?.lines.toLineNotificationSettings() ?? []
    }
}

private struct LineSelection: Identifiable {
    let lineID: TrainLineID
    var id: TrainLineID { lineID }
}
