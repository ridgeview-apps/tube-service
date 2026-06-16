import SwiftUI

enum NavigationButton {

    struct Settings: View {
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Image(systemName: "gearshape")
            }
        }
    }

    struct Close: View {
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Image(systemName: "xmark.circle.fill")
            }
            .foregroundStyle(.secondary)
        }
    }

}

struct SettingsToolBarButton: ViewModifier {
    @Environment(\.showSheet) var showSheet

    func body(content: Content) -> some View {
        content
            .toolbar {
                NavigationButton.Settings {
                    showSheet(.settings)
                }
            }
    }
}

struct CloseToolbarButtonModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss

    func body(content: Content) -> some View {
        content
            .toolbar {
                NavigationButton.Close {
                    dismiss()
                }
            }
    }
}

extension View {
    func withSettingsToolbarButton() -> some View {
        self.modifier(SettingsToolBarButton())
    }

    func withCloseToolbarButton() -> some View {
        self.modifier(CloseToolbarButtonModifier())
    }

    func defaultModalScreen(onTapClose: (() -> Void)?) -> some View {
        NavigationStack {
            toolbar {
                NavigationButton.Close {
                    onTapClose?()
                }
            }
        }
    }
}
