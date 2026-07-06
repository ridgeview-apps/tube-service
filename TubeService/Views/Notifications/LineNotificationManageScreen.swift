import DataStores
import Models
import PresentationViews
import SwiftUI

struct LineNotificationManageScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss

    @State private var selectedLine: LineSelection?

    var body: some View {
        LineNotificationSettingsView(
            mode: .manageAll(isEnabled: notifications.device?.enabled ?? true),
            allSettings: currentLines,
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
                await notifications.savePreferences(
                    update: currentLines.toNotificationPreferencesUpdate(),
                    deviceEnabled: isEnabled
                )
            }
        case .deleteAllSettings:
            Task {
                await notifications.deleteDevice()
                dismiss()
            }
        case .cancel:
            dismiss()
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
