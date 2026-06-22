import DataStores
import Models
import PresentationViews
import StoreKit
import SwiftUI

@MainActor
struct NotificationsOnboardingContent: View {

    enum Step: Hashable {
        case paywall
        case lineSelection
        case schedule
        case permissionDenied
    }

    let preselectedLine: TrainLineID?
    let onDismiss: () -> Void
    let onNavigate: (Step) -> Void
    let onReplaceStack: ([Step]) -> Void

    @Environment(\.openSettings) var openSettings
    @Environment(PurchaseStore.self) var purchases
    @Environment(NotificationsDataStore.self) var notifications

    @State private var selectedLineIDs: Set<TrainLineID>
    @State private var selectedPreset: NotificationSchedulePreset

    init(
        preselectedLine: TrainLineID? = nil,
        onDismiss: @escaping () -> Void,
        onNavigate: @escaping (Step) -> Void,
        onReplaceStack: @escaping ([Step]) -> Void
    ) {
        self.preselectedLine = preselectedLine
        self.onDismiss = onDismiss
        self.onNavigate = onNavigate
        self.onReplaceStack = onReplaceStack
        _selectedLineIDs = State(initialValue: preselectedLine.map { [$0] } ?? [])
        _selectedPreset = State(initialValue: .weekdayPeak)
    }

    var body: some View {
        NotificationsOnboardingIntroView(onAction: handleIntroAction)
            .navigationDestination(for: Step.self) { step in
                switch step {
                case .paywall:
                    paywallDestination
                case .lineSelection:
                    NotificationsLineSelectionView(
                        initialSelection: selectedLineIDs,
                        onContinue: { selected in
                            selectedLineIDs = selected
                            onNavigate(.schedule)
                        }
                    )
                case .schedule:
                    NotificationsOnboardingScheduleView(
                        selectedLineIDs: selectedLineIDs,
                        initialPreset: selectedPreset,
                        onDone: { preset in
                            selectedPreset = preset
                            Task { await checkPermissionAndAdvance() }
                        }
                    )
                case .permissionDenied:
                    NotificationsOnboardingPermissionDeniedView(onAction: handlePermissionDeniedAction)
                        .onSceneDidBecomeActive {
                            Task { await checkPermissionAndAdvance(pushIfDenied: false) }
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
                onReplaceStack([.lineSelection])
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
                onNavigate(.lineSelection)
            } else {
                onNavigate(.paywall)
            }
        case .notNow:
            onDismiss()
        }
    }

    private func handlePermissionDeniedAction(_ action: NotificationsOnboardingPermissionDeniedView.Action) {
        switch action {
        case .openSettings:
            openSettings()
        case .notNow:
            onDismiss()
        }
    }

    // MARK: - Permission

    private func checkPermissionAndAdvance(pushIfDenied: Bool = true) async {
        await notifications.requestAuthorization()
        switch notifications.authorizationStatus {
        case .authorized, .ephemeral, .provisional:
            notifications.schedulePreferencesUpdate(makePreferencesUpdate())
            onDismiss()
        default:
            if pushIfDenied {
                onNavigate(.permissionDenied)
            }
        }
    }

    private func makePreferencesUpdate() -> NotificationPreferencesUpdate {
        return NotificationPreferencesUpdate(
            lines: selectedLineIDs.map { lineID in
                NotificationLinePreferenceUpdate(
                    lineId: lineID.rawValue,
                    schedulePreset: selectedPreset
                )
            }
        )
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NavigationStack {
                NotificationsOnboardingContent(
                    preselectedLine: .victoria,
                    onDismiss: {},
                    onNavigate: { _ in },
                    onReplaceStack: { _ in }
                )
            }
        }
    }
#endif
