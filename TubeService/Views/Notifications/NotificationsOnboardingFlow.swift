import DataStores
import Models
import PresentationViews
import RidgeviewCore
import StoreKit
import SwiftUI
import UIKit
import UserNotifications

@MainActor
struct NotificationsOnboardingFlow: View {

    let preselectedLine: TrainLineID?

    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(PurchaseStore.self) var purchases
    @Environment(NotificationsDataStore.self) var notifications

    @State private var path: [OnboardingStep] = []
    @State private var selectedLineIDs: Set<TrainLineID>
    @State private var selectedPreset: NotificationSchedulePreset = .weekdayPeak

    enum OnboardingStep: Hashable {
        case paywall
        case lineSelection
        case schedule
        case confirmation
        case permissionDenied
    }

    init(preselectedLine: TrainLineID? = nil) {
        self.preselectedLine = preselectedLine
        _selectedLineIDs = State(initialValue: preselectedLine.map { [$0] } ?? [])
    }

    var body: some View {
        NavigationStack(path: $path) {
            NotificationsOnboardingIntroView(onAction: handleIntroAction)
                .withCloseToolbarButton()
                .navigationDestination(for: OnboardingStep.self) { step in
                    switch step {
                    case .paywall:
                        paywallDestination
                    case .lineSelection:
                        NotificationsLineSelectionView(
                            selectedLineIDs: $selectedLineIDs,
                            onContinue: { path.append(.schedule) }
                        )
                    case .schedule:
                        NotificationsScheduleView(
                            selectedPreset: $selectedPreset,
                            onContinue: { Task { await requestPermissionAndAdvance() } }
                        )
                    case .confirmation:
                        NotificationsOnboardingConfirmationView(
                            selectedLineIDs: selectedLineIDs,
                            onDone: { dismiss() }
                        )
                    case .permissionDenied:
                        NotificationsOnboardingPermissionDeniedView(onAction: handlePermissionDeniedAction)
                            .onSceneDidBecomeActive {
                                Task { await recheckPermissionAndAdvance() }
                            }
                    }
                }
        }
    }

    // MARK: - Paywall

    private var paywallDestination: some View {
        SubscriptionStoreView(productIDs: ["com.ridgeviewapps.tubeservice.plus"]) {
            TubeServicePlusMarketingContent(context: .notifications)
        }
        .onChange(of: purchases.hasTubeServicePlus) { _, isPlus in
            if isPlus {
                path = [.lineSelection]
            }
        }
        .navigationTitle("Tube Service Plus")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Actions

    private func handleIntroAction(_ action: NotificationsOnboardingIntroView.Action) {
        switch action {
        case .getStarted:
            if purchases.hasTubeServicePlus {
                path.append(.lineSelection)
            } else {
                path.append(.paywall)
            }
        case .notNow:
            dismiss()
        }
    }

    private func handlePermissionDeniedAction(_ action: NotificationsOnboardingPermissionDeniedView.Action) {
        switch action {
        case .openSettings:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                openURL(url)
            }
        case .notNow:
            dismiss()
        }
    }

    // MARK: - Permission

    private func requestPermissionAndAdvance() async {
        let center = UNUserNotificationCenter.current()
        let currentStatus = await center.notificationSettings().authorizationStatus

        switch currentStatus {
        case .authorized, .ephemeral, .provisional:
            notifications.pendingPreferencesUpdate = makePreferencesUpdate()
            UIApplication.shared.registerForRemoteNotifications()
            path.append(.confirmation)
        case .denied:
            path.append(.permissionDenied)
        case .notDetermined:
            do {
                let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
                if granted {
                    notifications.pendingPreferencesUpdate = makePreferencesUpdate()
                    UIApplication.shared.registerForRemoteNotifications()
                    path.append(.confirmation)
                } else {
                    path.append(.permissionDenied)
                }
            } catch {
                path.append(.permissionDenied)
            }
        @unknown default:
            path.append(.permissionDenied)
        }
    }

    private func recheckPermissionAndAdvance() async {
        let status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        switch status {
        case .authorized, .ephemeral, .provisional:
            notifications.pendingPreferencesUpdate = makePreferencesUpdate()
            UIApplication.shared.registerForRemoteNotifications()
            path = [.confirmation]
        default:
            break
        }
    }

    private func makePreferencesUpdate() -> NotificationPreferencesUpdate {
        NotificationPreferencesUpdate(
            enabled: true,
            lineIds: selectedLineIDs.map(\.rawValue),
            severityThreshold: .minorDelays,
            notifyRecoveries: true,
            schedulePreset: selectedPreset,
            customSchedules: []
        )
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NotificationsOnboardingFlow(preselectedLine: .victoria)
        }
    }
#endif
