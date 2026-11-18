import DataStores
import PresentationViews
import SwiftUI

struct NotificationsOnboardingPermissionDeniedScreen: View {

    @Environment(\.openSettings) private var openSettings

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(Navigator.self) private var navigator
    @Environment(\.dismissModal) private var dismissModal

    let lineSettings: [LineNotificationSettings]

    var body: some View {
        NotificationsOnboardingPermissionDeniedView { action in
            switch action {
            case .openSettings:
                openSettings()
            case .notNow:
                notifications.completeOnboarding(with: lineSettings.toNotificationPreferencesUpdate())
                dismissModal?()
            }
        }
        .navigationTitle(Text(L10n.notificationsPermissionDeniedNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: notifications.canReceivePushNotifications) { _, canReceivePush in
            if canReceivePush {
                notifications.completeOnboarding(with: lineSettings.toNotificationPreferencesUpdate())
                navigator.push(.notifications(.onboardingConfirmation(lineSettings)))
            }
        }
    }
}
