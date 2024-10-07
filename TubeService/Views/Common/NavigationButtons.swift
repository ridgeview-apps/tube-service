import SwiftUI

enum NavigationButton {
    
    struct Settings: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: "gear")
                    .imageScale(.large)
            }
        }
    }
    
    struct Close: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
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

extension View {
    func withSettingsToolbarButton() -> some View {
        self.modifier(SettingsToolBarButton())
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
