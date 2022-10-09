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


// TODO - refactor this later to show other common toolbar items

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
}
