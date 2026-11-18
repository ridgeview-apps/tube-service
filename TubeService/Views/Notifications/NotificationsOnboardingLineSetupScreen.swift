import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

struct NotificationsOnboardingLineSetupScreen: View {

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(Navigator.self) private var navigator

    private let initialNotificationSettings: [LineNotificationSettings]

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    init(defaultLineID: TrainLineID?) {
        var initialLineIDs = _userPreferences.wrappedValue.favouriteLineIDs
        if let defaultLineID, !initialLineIDs.contains(defaultLineID) {
            initialLineIDs.append(defaultLineID)
        }
        initialNotificationSettings = initialLineIDs.map { .defaultValue(lineID: $0) }
    }

    var body: some View {
        NotificationsOnboardingLineSetupView(
            initialItems: initialNotificationSettings
        ) { action in
            switch action {
            case .turnOnAlerts(let lineSettings):
                requestPushPermissionsAndFinish(with: lineSettings)
            }
        }
        .withCloseToolbarButton()
    }

    private func requestPushPermissionsAndFinish(with lineSettings: [LineNotificationSettings]) {
        Task {
            await notifications.requestAuthorizationAndRefreshStatus()
            if notifications.canReceivePushNotifications {
                notifications.completeOnboarding(with: lineSettings.toNotificationPreferencesUpdate())
                navigator.push(.notifications(.onboardingConfirmation(lineSettings)))
            } else if notifications.isPermissionDenied {
                navigator.push(.notifications(.onboardingPermissionDenied(lineSettings)))
            } else {
                assertionFailure("Authorization status still undetermined? (should be impossible after requesting push permissions)")
            }
        }
    }
}
