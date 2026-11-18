import DataStores
import Models
import PresentationViews
import SwiftUI

struct NotificationsFlow: View {

    /// Decided once, on appear: finishing onboarding sets notifications up, which mustn't swap the flow under the user.
    private enum Start {
        case undecided
        case onboarding
        case manage
    }

    @Environment(NotificationsDataStore.self) private var notifications

    @State private var start = Start.undecided

    /// The line the flow opens on, or every line when `nil`.
    let lineID: TrainLineID?

    var body: some View {
        Group {
            switch start {
            case .undecided:
                // The choice depends on the environment, which isn't available until the view appears.
                Color.clear
            case .onboarding:
                OnboardingNotificationsFlow(defaultLineID: lineID)
            case .manage:
                ManageNotificationsFlow(mode: lineID.map { .singleLine($0) } ?? .all)
            }
        }
        .onAppear {
            if start == .undecided {
                start = notifications.isConfigured ? .manage : .onboarding
            }
        }
    }
}
