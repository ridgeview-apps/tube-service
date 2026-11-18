import PresentationViews
import SwiftUI

struct NotificationsOnboardingConfirmationScreen: View {

    @Environment(\.dismissModal) private var dismissModal

    let lineSettings: [LineNotificationSettings]

    var body: some View {
        NotificationsOnboardingConfirmationView(lineSettings: lineSettings)
            .navigationTitle(Text(L10n.notificationsConfirmationNavigationTitle))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        dismissModal?()
                    }
                }
            }
    }
}
