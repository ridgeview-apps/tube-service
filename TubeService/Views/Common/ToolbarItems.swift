import PresentationViews
import Shared
import SwiftUI

/// Opens Settings, from a tab's root screen.
struct SettingsToolbarItem: ToolbarContent {
    @Environment(Navigator.self) private var navigator

    var body: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                navigator.present(.settings)
            } label: {
                Label(L10n.settingsNavigationTitle, systemImage: "gearshape")
            }
        }
    }
}

/// The standard close button, shown only on the first screen of a modal: pushed screens go back instead.
struct CloseToolbarItem: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isModalRoot) private var isModalRoot

    var body: some ToolbarContent {
        if isModalRoot {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .close) {
                    dismiss()
                }
                .accessibilityIdentifier(AccessibilityID.NavigationButton.close)
            }
        }
    }
}
