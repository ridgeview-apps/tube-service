import DataStores
import PresentationViews
import SwiftUI

struct NotificationsOnboardingPermissionDeniedScreen: View {

    @Environment(\.openSettings) private var openSettings

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(Navigator.self) private var navigator

    let lineSettings: [LineNotificationSettings]

    var body: some View {
        NotificationsOnboardingPermissionDeniedView { action in
            switch action {
            case .openSettings:
                openSettings()
            case .notNow:
                notifications.completeOnboarding(with: lineSettings.toNotificationPreferencesUpdate())
                navigator.dismissPresentingModal()
            }
        }
        .onChange(of: notifications.canReceivePushNotifications) { _, canReceivePush in
            if canReceivePush {
                notifications.completeOnboarding(with: lineSettings.toNotificationPreferencesUpdate())
                navigator.push(.notifications(.onboardingConfirmation(lineSettings)))
            }
        }
    }
}
