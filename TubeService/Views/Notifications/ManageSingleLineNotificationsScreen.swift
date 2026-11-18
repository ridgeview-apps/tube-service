import DataStores
import Models
import PresentationViews
import SwiftUI

struct ManageSingleLineNotificationsScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openSettings) private var openSettings
    @Environment(\.dismissModal) private var dismissModal

    @State private var savingState: LoadingState = .loaded
    @State private var pendingUpdateCount = 0

    let lineID: TrainLineID

    var body: some View {
        ManageSingleLineNotificationsView(
            lineID: lineID,
            existingSettings: existingSettings(for: lineID),
            showsPermissionWarning: notifications.isPermissionDenied,
            savingState: savingState,
            onAction: handleAction
        )
        .navigationTitle(Text(L10n.notificationsLineConfigNavTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Nothing is saved for a new line until it's turned on, so closing cancels it;
            // an existing line's edits are already saved, so closing confirms them.
            // Both sit on the trailing side, clear of the back button when the screen is pushed.
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: isAddingLine ? .close : .confirm) {
                    dismissModal?()
                }
            }
        }
    }

    private var isAddingLine: Bool {
        existingSettings(for: lineID) == nil
    }

    private func handleAction(_ action: ManageSingleLineNotificationsView.Action) {
        switch action {
        case .openSettings:
            openSettings()
        case .add(let newSettings):
            Task {
                savingState = .loading
                do {
                    try await notifications.updateLinePreferences(with: .add(newSettings))
                    // Pushed from the list, this goes back to it so several lines can be added in a row.
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
        }
    }

    private func existingSettings(for lineID: TrainLineID) -> LineNotificationSettings? {
        notifications.linePreferences.toLineNotificationSettings().first { $0.lineID == lineID }
    }
}
