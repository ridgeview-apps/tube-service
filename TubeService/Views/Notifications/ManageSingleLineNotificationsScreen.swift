import DataStores
import Models
import PresentationViews
import SwiftUI

struct ManageSingleLineNotificationsScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openSettings) private var openSettings
    @Environment(Router<ManageNotificationsRoute>.self) private var manageNotificationsRouter

    @State private var savingState: LoadingState = .loaded

    let lineID: TrainLineID
    let showsOtherLines: Bool

    init(lineID: TrainLineID, showsOtherLines: Bool) {
        self.lineID = lineID
        self.showsOtherLines = showsOtherLines
    }

    var body: some View {
        ManageSingleLineNotificationsView(
            lineID: lineID,
            existingSettings: existingSettings(for: lineID),
            showsOtherLines: showsOtherLines,
            allSettings: currentLines,
            showsPermissionWarning: notifications.isPermissionDenied,
            showsPausedAlertsWarning: notifications.isDevicePaused,
            savingState: savingState,
            onAction: handleAction
        )
    }

    private func handleAction(_ action: ManageSingleLineNotificationsView.Action) {
        switch action {
        case .cancel:
            dismiss()
        case .tappedOtherLine(let otherLineID):
            manageNotificationsRouter.navigation.push(.editLine(lineID: otherLineID))
        case .addedLine(let otherLineID):
            manageNotificationsRouter.navigation.push(.addLine(lineID: otherLineID))
        case .openSettings:
            openSettings()
        case .save(let updatedSettings):
            let patch: NotificationPreferencesPatch =
                existingSettings(for: lineID) == nil ? .add(updatedSettings) : .update(updatedSettings)
            Task {
                savingState = .loading
                do {
                    try await notifications.updateLinePreferences(with: patch)
                    dismiss()
                } catch {
                    savingState = .failure(errorMessage: error.toSaveErrorMessage())
                }
            }
        case .remove:
            Task {
                savingState = .loading
                do {
                    try await notifications.updateLinePreferences(with: .remove(lineID))
                    dismiss()
                } catch {
                    savingState = .failure(errorMessage: error.toSaveErrorMessage())
                }
            }
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
