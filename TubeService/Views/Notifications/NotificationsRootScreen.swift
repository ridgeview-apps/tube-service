import DataStores
import Models
import SwiftUI

/// The root of the notifications modal: onboarding until notifications are set up, then managing them.
struct NotificationsRootScreen: View {

    /// Decided once, on appear: finishing onboarding sets notifications up, which mustn't swap the screen under the user.
    private enum Start {
        case undecided
        case onboarding
        case manage
    }

    @Environment(NotificationsDataStore.self) private var notifications

    @State private var start = Start.undecided

    /// The line the modal opens on, or every line when `nil`.
    let lineID: TrainLineID?

    var body: some View {
        Group {
            switch start {
            case .undecided:
                // The choice depends on the environment, which isn't available until the view appears.
                Color.clear
            case .onboarding:
                NotificationsOnboardingLineSetupScreen(defaultLineID: lineID)
            case .manage:
                manageRoot
            }
        }
        .onAppear {
            if start == .undecided {
                start = notifications.isConfigured ? .manage : .onboarding
            }
        }
    }

    /// A line opened from its status screen is the root, so there's nothing to go back to. Once it's set up it lists
    /// the other lines below its settings; until then it stays focused on turning it on, which finishes what the user
    /// came to do and closes the modal.
    @ViewBuilder
    private var manageRoot: some View {
        if let lineID {
            ManageSingleLineNotificationsScreen(lineID: lineID, showsOtherLines: true)
        } else {
            ManageAllLineNotificationsScreen()
        }
    }
}
