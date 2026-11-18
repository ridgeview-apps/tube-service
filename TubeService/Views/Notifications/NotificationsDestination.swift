import Models
import PresentationViews
import SwiftUI

enum NotificationsDestination: Hashable {
    /// Every line when `lineID` is `nil`.
    case root(lineID: TrainLineID?)
    case line(lineID: TrainLineID)
    case onboardingPermissionDenied([LineNotificationSettings])
    case onboardingConfirmation([LineNotificationSettings])

    var paywallContext: PaywallContext? {
        switch self {
        case .root: .notifications
        case .line, .onboardingPermissionDenied, .onboardingConfirmation: nil
        }
    }

    /// Onboarding's first step and the Manage screens bring their own close buttons.
    var hasOwnCloseButton: Bool {
        switch self {
        case .root, .line: true
        case .onboardingPermissionDenied, .onboardingConfirmation: false
        }
    }

    @MainActor
    @ViewBuilder
    var screen: some View {
        switch self {
        case .root(let lineID):
            NotificationsRootScreen(lineID: lineID)
        case .line(let lineID):
            ManageSingleLineNotificationsScreen(lineID: lineID, showsOtherLines: false)
        case .onboardingPermissionDenied(let lineSettings):
            NotificationsOnboardingPermissionDeniedScreen(lineSettings: lineSettings)
        case .onboardingConfirmation(let lineSettings):
            NotificationsOnboardingConfirmationScreen(lineSettings: lineSettings)
        }
    }
}
