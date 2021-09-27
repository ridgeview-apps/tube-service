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
    
    struct Done: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text("navigation.done.button.title").bold()
            }
        }
    }
}

