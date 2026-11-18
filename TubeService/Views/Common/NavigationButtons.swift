import SwiftUI
import PresentationViews

struct SettingsToolBarButton: ViewModifier {
    @Environment(AppNavigator.self) private var appNavigator

    func body(content: Content) -> some View {
        content
            .toolbar {
                NavigationButton.Settings {
                    appNavigator.showSheet(.settings)
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

    func asModalScreen() -> some View {
        NavigationStack {
            self.withCloseToolbarButton()
        }
    }
}
