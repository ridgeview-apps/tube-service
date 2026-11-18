import Models
import PresentationViews
import SwiftUI

/// Saves a custom preset, which the journey results reload for.
struct JourneyModePickerScreen: View {

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @State private var pendingModeIDs: Set<ModeID>
    @State private var originalModeIDs: Set<ModeID>
    @State private var showingDiscardConfirmation = false

    @Environment(\.dismiss) private var dismiss

    init() {
        let initialModeIDs =
            if case .custom(let modeIDs) = _userPreferences.wrappedValue.journeyModePreset {
                modeIDs
            } else {
                JourneyModePreset.trainAndBus.modeIDs
            }
        self._pendingModeIDs = State(initialValue: initialModeIDs)
        self._originalModeIDs = State(initialValue: initialModeIDs)
    }

    private var hasUnsavedChanges: Bool { pendingModeIDs != originalModeIDs }

    var body: some View {
        JourneyModePickerView(selection: $pendingModeIDs)
            .navigationTitle(Text(L10n.journeyModePickerNavigationTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.globalCancel) {
                        if hasUnsavedChanges {
                            showingDiscardConfirmation = true
                        } else {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.globalDone) {
                        userPreferences.journeyModePreset = .custom(pendingModeIDs)
                        dismiss()
                    }
                    .disabled(!hasUnsavedChanges)
                }
            }
            .confirmationDialog(
                Text(L10n.journeyModePickerDiscardAction),
                isPresented: $showingDiscardConfirmation,
                titleVisibility: .visible
            ) {
                Button(L10n.journeyModePickerDiscardAction, role: .destructive) {
                    dismiss()
                }
                Button(L10n.journeyModePickerKeepEditing, role: .cancel) {}
            } message: {
                Text(L10n.journeyModePickerDiscardMessage)
            }
            .interactiveDismissDisabled(hasUnsavedChanges)
    }
}
