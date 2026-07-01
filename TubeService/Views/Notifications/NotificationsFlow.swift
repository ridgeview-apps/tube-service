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

    var onboardingInitialSettings: [LineNotificationSettings] {
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
            OnboardingNotificationsFlow(
                initialNotificationSettings: onboardingInitialSettings
            )
        case .manage:
            let saved = savedNotificationSettings
            ManageNotificationsFlow(
                savedNotificationSettings: saved,
                pendingNotificationSettings: pendingItems(savedItems: saved),
                initialIsMuted: notifications.device?.enabled ?? true
            )
        }
    }

    private func pendingItems(savedItems: [LineNotificationSettings]) -> [LineNotificationSettings] {
        guard case .lineDetail(let lineID) = context,
            !savedItems.contains(where: { $0.lineID == lineID })
        else { return [] }
        return [.defaultValue(lineID: lineID)]
    }
}
