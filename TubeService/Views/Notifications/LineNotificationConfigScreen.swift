import DataStores
import Models
import PresentationViews
import SwiftUI

struct LineNotificationConfigScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss

    let lineID: TrainLineID

    private var existingSettings: LineNotificationSettings? {
        notifications.preferences?.lines.toLineNotificationSettings()
            .first { $0.lineID == lineID }
    }

    var body: some View {
        NavigationStack {
            LineNotificationConfigView(
                lineID: lineID,
                existingSettings: existingSettings,
                onAction: handleAction
            )
        }
    }

    private func handleAction(_ action: LineNotificationConfigView.Action) {
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
        }
    }

    private var currentLines: [LineNotificationSettings] {
        notifications.preferences?.lines.toLineNotificationSettings() ?? []
    }
}
