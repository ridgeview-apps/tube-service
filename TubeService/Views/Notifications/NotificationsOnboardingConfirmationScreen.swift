import PresentationViews
import SwiftUI

struct NotificationsOnboardingConfirmationScreen: View {

    @Environment(\.dismissModal) private var dismissModal

    let lineSettings: [LineNotificationSettings]

    var body: some View {
        NotificationsOnboardingConfirmationView(lineSettings: lineSettings) {
            dismissModal?()
        }
    }
}
