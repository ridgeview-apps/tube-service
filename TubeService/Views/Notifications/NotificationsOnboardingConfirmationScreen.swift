import PresentationViews
import SwiftUI

struct NotificationsOnboardingConfirmationScreen: View {

    @Environment(Navigator.self) private var navigator

    let lineSettings: [LineNotificationSettings]

    var body: some View {
        NotificationsOnboardingConfirmationView(lineSettings: lineSettings) {
            navigator.dismissPresentingModal()
        }
    }
}
