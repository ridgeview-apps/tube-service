import DataStores
import Models
import PresentationViews
import StoreKit
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

    var initialNotificationSettings: [LineNotificationSettings] {
        switch mode {
        case .onboarding:
            switch context {
            case .lineDetail(let trainLineID):
                return [.defaultValue(lineID: trainLineID)]
            case .globalSettings:
                return []
            }
        case .manage:
            return notifications.preferences?.lines.toLineNotificationSettings() ?? []
        }
    }

    var body: some View {
        switch mode {
        case .onboarding:
            OnboardingNotificationsFlow(
                initialNotificationSettings: initialNotificationSettings
            )
        case .manage:
            ManageNotificationsFlow(
                initialNotificationSettings: initialNotificationSettings,
                initialIsMuted: notifications.device?.enabled ?? true
            )
        }
    }
}
