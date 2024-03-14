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
                Image(systemName: "xmark")
                    .imageScale(.large)
            }
        }
    }
    
}

struct ResetButtonViewModifier<Message: View>: ViewModifier {
    @State var showAlert = false
    let enabled: Bool
    let alertTitle: LocalizedStringKey
    let onConfirm: () -> Void
    let alertMessage: () -> Message
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                Button {
                    showAlert = true
                } label: {
                    Text("global.button.title.reset")
                }
                .disabled(!enabled)
            }
            .alert(alertTitle,
                   isPresented: $showAlert) {
                Button(role: .destructive) {
                    onConfirm()
                } label: {
                    Text("global.button.title.reset")
                }
                Button(role: .cancel) {
                    showAlert = false
                } label: {
                    Text("global.button.title.cancel")
                }
            } message: {
                alertMessage()
            }

    }
}


struct SettingsToolBarButton: ViewModifier {
    @State private var showSettings: Bool = false
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                NavigationButton.Settings { showSettings = true }
            }
            .sheet(isPresented: $showSettings) {
                SettingsScreen()
            }
    }
}

extension View {
    func withSettingsToolbarButton() -> some View {
        self.modifier(SettingsToolBarButton())
    }
    
    func withResetToolbarButton(enabled: Bool = false,
                                alertTitle: LocalizedStringKey,
                                onConfirm: @escaping () -> Void,
                                alertMessage: @escaping () -> some View = { EmptyView() }) -> some View {
        self.modifier(ResetButtonViewModifier(enabled: enabled,
                                              alertTitle: alertTitle,
                                              onConfirm: onConfirm,
                                              alertMessage: alertMessage))
    }
}
