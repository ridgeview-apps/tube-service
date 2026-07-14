import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

enum NotificationsOnboardingRoute: Hashable {
    case initialPaywall
    case permissionDenied
    case confirmation
}

struct OnboardingNotificationsFlow: View {

    @Environment(\.openSettings) private var openSettings
    @Environment(\.dismiss) private var dismiss

    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(PurchaseStore.self) private var purchases

    @State private var router = Router<NotificationsOnboardingRoute>()

    private let initialNotificationSettings: [LineNotificationSettings]
    @State private var updatedNotificationSettings = [LineNotificationSettings]()

    init(defaultLineID: TrainLineID?) {
        initialNotificationSettings = defaultLineID.map { [.defaultValue(lineID: $0)] } ?? []
    }

    var body: some View {
        NavigationStack(path: $router.navigation.path) {
            rootView
                .navigationDestination(for: NotificationsOnboardingRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var rootView: some View {
        NotificationsOnboardingIntroView { action in
            switch action {
            case .getStarted:
                router.navigation.push(.initialPaywall)
            case .notNow:
                dismiss()
            }
        }
        .toolbar {
            NavigationButton.Close {
                dismiss()
            }
        }
    }

    @ViewBuilder
    private var initialPaywallView: some View {
        Group {
            if !purchases.hasTubeServicePlus {
                TubeServicePlusView(context: .notifications)
            } else {
                lineSettingsView
            }
        }
        .toolbar {
            NavigationButton.Close {
                dismiss()
            }
        }
    }

    private var lineSettingsView: some View {
        NotificationsOnboardingLineSetupView(
            initialItems: initialNotificationSettings
        ) { action in
            switch action {
            case .turnOnAlerts(let updatedValues):
                updatedNotificationSettings = updatedValues
                requestPushPermissionsAndFinish()
            }
        }
        .navigationBarBackButtonHidden()
    }

    private func requestPushPermissionsAndFinish() {
        Task {
            await notifications.requestAuthorizationAndRefreshStatus()
            if notifications.canReceivePushNotifications {
                pushPermissionsGranted()
            } else if notifications.isPermissionDenied {
                router.navigation.push(.permissionDenied)
            } else {
                assertionFailure("Authorization status still undetermined? (should be impossible after requesting push permissions)")
            }
        }

    }

    private var permissionDeniedView: some View {
        NotificationsOnboardingPermissionDeniedView { action in
            switch action {
            case .openSettings:
                openSettings()
            case .notNow:
                notifications.completeOnboarding(with: updatedNotificationSettings.toNotificationPreferencesUpdate())
                dismiss()
            }
        }
        .onChange(of: notifications.canReceivePushNotifications) { _, canReceivePush in
            if canReceivePush {
                pushPermissionsGranted()
            }
        }
    }

    private func pushPermissionsGranted() {
        notifications.completeOnboarding(with: updatedNotificationSettings.toNotificationPreferencesUpdate())
        router.navigation.push(.confirmation)
    }

    private var confirmationView: some View {
        NotificationsOnboardingConfirmationView(lineSettings: updatedNotificationSettings) {
            dismiss()
        }
    }

    @ViewBuilder
    private func destinationView(for route: NotificationsOnboardingRoute) -> some View {
        switch route {
        case .initialPaywall:
            initialPaywallView
        case .permissionDenied:
            permissionDeniedView
        case .confirmation:
            confirmationView
        }
    }
}
