import SwiftUI

struct OpenSettingsButton: View {
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Button {
            openSettings()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "gear")
                    .imageScale(.large)
                Text("open.app.settings.button.title", bundle: .module)
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
