import Models
import PresentationViews
import SwiftUI

struct JourneyModePickerScreen: View {

    let onDone: (Set<ModeID>) -> Void

    @State private var pendingModeIDs: Set<ModeID>
    @State private var originalModeIDs: Set<ModeID>
    @State private var showingDiscardConfirmation = false

    @Environment(\.dismiss) private var dismiss

    init(initialModeIDs: Set<ModeID>, onDone: @escaping (Set<ModeID>) -> Void) {
        self._pendingModeIDs = State(initialValue: initialModeIDs)
        self._originalModeIDs = State(initialValue: initialModeIDs)
        self.onDone = onDone
    }

    private var hasUnsavedChanges: Bool { pendingModeIDs != originalModeIDs }

    var body: some View {
        NavigationStack {
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
                            onDone(pendingModeIDs)
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
}
