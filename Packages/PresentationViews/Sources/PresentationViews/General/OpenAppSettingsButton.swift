import SwiftUI

struct OpenSettingsButton: View {
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Button {
            openSettings()
        } label: {
            Label {
                Text("open.app.settings.button.title", bundle: .module)
            } icon: {
                Image(systemName: "gear")
                    .imageScale(.large)
            }
        }        
    }
    
    private func openSettings() {
        guard let openSettingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        openURL(openSettingsURL)
    }
}

#Preview {
    VStack {
        OpenSettingsButton()
        OpenSettingsButton()
            .buttonStyle(.primary)
    }
}
