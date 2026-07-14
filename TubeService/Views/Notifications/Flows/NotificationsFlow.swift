import Models
import PresentationViews
import SwiftUI

struct NotificationsFlow: View {

    enum Context {
        enum ManageMode {
            case singleLine(TrainLineID)
            case all
        }
        case onboarding(defaultLineID: TrainLineID?)
        case manage(ManageMode)
    }

    let context: Context

    var body: some View {
        switch context {
        case let .onboarding(defaultLineID):
            OnboardingNotificationsFlow(defaultLineID: defaultLineID)
        case let .manage(mode):
            ManageNotificationsFlow(mode: mode)
        }
    }
}
