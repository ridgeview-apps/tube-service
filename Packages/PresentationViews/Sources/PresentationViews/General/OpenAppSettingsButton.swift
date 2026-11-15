import SwiftUI

struct OpenSettingsButton: View {

    @Environment(\.openURL) var openURL

    var body: some View {
        Button {
            openSettings()
        } label: {
            Text(.globalSettings)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .controlSize(.small)
    }

    private func openSettings() {
        guard let openSettingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        openURL(openSettingsURL)
    }
}

#Preview {
    OpenSettingsButton()
}
