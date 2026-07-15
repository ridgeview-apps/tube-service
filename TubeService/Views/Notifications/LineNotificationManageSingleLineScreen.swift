import DataStores
import Models
import PresentationViews
import SwiftUI

struct LineNotificationManageSingleLineScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openSettings) private var openSettings

    @State private var savingState: LoadingState = .loaded
    @State private var selectedOtherLineID: TrainLineID?

    let lineID: TrainLineID
    let showsOtherLines: Bool

    init(lineID: TrainLineID, showsOtherLines: Bool) {
        self.lineID = lineID
        self.showsOtherLines = showsOtherLines
    }

    var body: some View {
        LineNotificationSingleLineView(
            lineID: lineID,
            existingSettings: existingSettings(for: lineID),
            showsOtherLines: showsOtherLines,
            allSettings: currentLines,
            showsPermissionWarning: notifications.isPermissionDenied,
            showsPausedAlertsWarning: notifications.isDevicePaused,
            savingState: savingState,
            onAction: handleAction
        )
        .sheet(item: $selectedOtherLineID) { otherLineID in
            NavigationStack {
                LineNotificationManageSingleLineScreen(lineID: otherLineID, showsOtherLines: false)
            }
        }
    }

    private func handleAction(_ action: LineNotificationSingleLineView.Action) {
        switch action {
        case .cancel:
            dismiss()
        case .tappedOtherLine(let targetLineID):
            selectedOtherLineID = targetLineID
        case .openSettings:
            openSettings()
        case .save(let updatedSettings):
            Task {
                var updatedLines = currentLines.filter { $0.lineID != lineID }
                updatedLines.append(updatedSettings)
                savingState = .loading
                do {
                    try await notifications.savePreferences(with: updatedLines.toNotificationPreferencesUpdate())
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
                    try await notifications.savePreferences(with: updatedLines.toNotificationPreferencesUpdate())
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
