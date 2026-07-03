import DataStores
import Models
import PresentationViews
import SwiftUI

struct NotificationsFlow: View {
    @Environment(NotificationsDataStore.self) private var notifications

    private var savedNotificationSettings: [LineNotificationSettings] {
        notifications.preferences?.lines.toLineNotificationSettings() ?? []
    }

    enum Context {
        case lineDetail(TrainLineID)
        case globalSettings
    }

    enum Mode {
        case onboarding
        case manage
    }

    let context: Context
    let mode: Mode

    private var onboardingInitialSettings: [LineNotificationSettings] {
        switch context {
        case .lineDetail(let trainLineID):
            return [.defaultValue(lineID: trainLineID)]
        case .globalSettings:
            return []
        }
    }

    var body: some View {
        switch mode {
        case .onboarding:
            OnboardingNotificationsFlow(initialNotificationSettings: onboardingInitialSettings)
        case .manage:
            manageFlow
        }
    }

    private var manageFlow: some View {
        ManageNotificationsFlow(
            savedNotificationSettings: savedNotificationSettings,
            initialIsEnabled: notifications.device?.enabled ?? true
        )
    }
}
