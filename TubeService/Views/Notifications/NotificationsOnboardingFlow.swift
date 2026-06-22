import DataStores
import Models
import PresentationViews
import RidgeviewCore
import StoreKit
import SwiftUI

@MainActor
struct NotificationsOnboardingFlow: View {

    let preselectedLine: TrainLineID?

    @Environment(\.dismiss) var dismiss
    @Environment(\.openSettings) var openSettings
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
                            initialSelection: selectedLineIDs,
                            onContinue: { selected in
                                selectedLineIDs = selected
                                path.append(.schedule)
                            }
                        )
                    case .schedule:
                        NotificationsScheduleView(
                            initialPreset: selectedPreset,
                            onContinue: { preset in
                                selectedPreset = preset
                                Task { await checkPermissionAndAdvance() }
                            }
                        )
                    case .confirmation:
                        NotificationsOnboardingConfirmationView(
                            selectedLineIDs: selectedLineIDs,
                            selectedSchedulePreset: selectedPreset,
                            onDone: { dismiss() }
                        )
                    case .permissionDenied:
                        NotificationsOnboardingPermissionDeniedView(onAction: handlePermissionDeniedAction)
                            .onSceneDidBecomeActive {
                                Task { await checkPermissionAndAdvance() }
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
            openSettings()
        case .notNow:
            dismiss()
        }
    }

    // MARK: - Permission

    private func checkPermissionAndAdvance() async {
        await notifications.requestAuthorization()
        switch notifications.authorizationStatus {
        case .authorized, .ephemeral, .provisional:
            notifications.schedulePreferencesUpdate(makePreferencesUpdate())
            path = [.confirmation]
        default:
            if path.last != .permissionDenied {
                path.append(.permissionDenied)
            }
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
