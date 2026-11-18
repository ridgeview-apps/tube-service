import DataStores
import Models
import SwiftUI

/// The root of the notifications modal: onboarding until notifications are set up, then managing them.
struct NotificationsRootScreen: View {

    /// Decided once, on appear, so finishing onboarding or turning a line on doesn't swap the screen under the user.
    private enum Start {
        case undecided
        case onboarding
        case addLine(TrainLineID)
        case manageAllLines
    }

    @Environment(NotificationsDataStore.self) private var notifications

    @State private var start = Start.undecided

    let openedFromLineID: TrainLineID?

    var body: some View {
        Group {
            switch start {
            case .undecided:
                // The choice depends on the environment, which isn't available until the view appears.
                Color.clear
            case .onboarding:
                NotificationsOnboardingLineSetupScreen(defaultLineID: openedFromLineID)
            case .addLine(let lineID):
                ManageSingleLineNotificationsScreen(lineID: lineID)
            case .manageAllLines:
                ManageAllLineNotificationsScreen()
            }
        }
        .onAppear {
            if case .undecided = start {
                start = initialStart
            }
        }
    }

    private var initialStart: Start {
        guard notifications.isConfigured else { return .onboarding }
        if let openedFromLineID,
            !notifications.linePreferences.contains(where: { $0.lineId == openedFromLineID.rawValue })
        {
            return .addLine(openedFromLineID)
        }
        // The same list as Settings, so notifications are managed in one place wherever they're opened from.
        return .manageAllLines
    }
}
