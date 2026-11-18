import Models
import PresentationViews
import SwiftUI

enum NotificationsDestination: Hashable {
    case root(openedFromLineID: TrainLineID?)
    case line(lineID: TrainLineID)
    case onboardingPermissionDenied([LineNotificationSettings])
    case onboardingConfirmation([LineNotificationSettings])

    var paywallContext: PaywallContext? {
        switch self {
        case .root: .notifications
        case .line, .onboardingPermissionDenied, .onboardingConfirmation: nil
        }
    }

    @MainActor
    @ViewBuilder
    var screen: some View {
        switch self {
        case .root(let openedFromLineID):
            NotificationsRootScreen(openedFromLineID: openedFromLineID)
        case .line(let lineID):
            ManageSingleLineNotificationsScreen(lineID: lineID)
        case .onboardingPermissionDenied(let lineSettings):
            NotificationsOnboardingPermissionDeniedScreen(lineSettings: lineSettings)
        case .onboardingConfirmation(let lineSettings):
            NotificationsOnboardingConfirmationScreen(lineSettings: lineSettings)
        }
    }
}
