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
    @State private var pendingUpdateCount = 0

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
        case .close:
            dismiss()
        case .tappedOtherLine(let otherLineID):
            manageNotificationsRouter.navigation.push(.editLine(lineID: otherLineID))
        case .addedLine(let otherLineID):
            manageNotificationsRouter.navigation.push(.addLine(lineID: otherLineID))
        case .openSettings:
            openSettings()
        case .add(let newSettings):
            Task {
                savingState = .loading
                do {
                    try await notifications.updateLinePreferences(with: .add(newSettings))
                    dismiss()
                } catch {
                    savingState = .failure(errorMessage: error.toSaveErrorMessage())
                }
            }
        case .update(let updatedSettings):
            // Saved in the background without a loading state, so the controls stay usable between edits.
            // Each update carries every editable field and the store sends them in order, so only the last
            // pending one decides the outcome: an earlier failure is superseded by a later success.
            pendingUpdateCount += 1
            savingState = .loaded
            Task {
                var failure: Error?
                do {
                    try await notifications.updateLinePreferences(with: .update(updatedSettings))
                } catch {
                    failure = error
                }
                pendingUpdateCount -= 1
                if pendingUpdateCount == 0, let failure {
                    savingState = .failure(errorMessage: failure.toSaveErrorMessage())
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
