import DataStores
import Models
import PresentationViews
import StoreKit
import SwiftUI

enum NotificationOnboardingFlowStep {
    case intro
    case paywall
    case lineSelection
    case schedule
    case permissionDenied
}

@Observable
@MainActor
final class NotificationFlowStore {

    private(set) var selectedLines: Set<TrainLineID> = []
    private(set) var currentStep: NotificationOnboardingFlowStep = .intro

    func begin(
        with initialLineSelections: Set<TrainLineID>,
        skipIntro: Bool
    ) {
        self.selectedLines = initialLineSelections

        if skipIntro {
            proceed(to: .lineSelection)
        } else {
            proceed(to: .intro)
        }
    }

    func proceed(to nextStep: NotificationOnboardingFlowStep) {
        currentStep = nextStep
    }

    func lineSelectionDone(with newValues: Set<TrainLineID>) {
        self.selectedLines = newValues
        proceed(to: .schedule)
    }
}

struct NotificationsOnboardingFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseStore.self) private var purchaseStore

    @State private var flow: NotificationFlowStore!

    var body: some View {
        switch flow.currentStep {
        case .intro:
            NotificationsOnboardingIntroView(onAction: handleIntroAction)
        case .paywall:
            TubeServicePlusView(
                context: .notifications,
                autoDismissesOnPurchase: false,
                onAction: handlePaywallAction
            )
        case .lineSelection:
            EmptyView() // TODO
        case .schedule:
            EmptyView()  // TODO
        case .permissionDenied:
            EmptyView()  // TODO
        }
    }

    private func handleIntroAction(_ action: NotificationsOnboardingIntroView.Action) {
        switch action {
        case .getStarted:
            if purchaseStore.hasTubeServicePlus {
                flow.proceed(to: .lineSelection)
            } else {
                flow.proceed(to: .paywall)
            }
        case .notNow:
            dismiss()
        }
    }

    private func handleLineSelectionDone(_ selectedLines: Set<TrainLineID>) {
        flow.lineSelectionDone(with: selectedLines)
    }

    private func handlePaywallAction(_ action: TubeServicePlusView.Action) {
        switch action {
        case .purchaseSuccess:
            flow.proceed(to: .lineSelection)
        }
    }
}

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
                    EmptyView() // TODO
                case .schedule:
                    EmptyView()  // To be fixed later
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
        TubeServicePlusView(
            context: .notifications,
            autoDismissesOnPurchase: false
        ) {
            switch $0 {
            case .purchaseSuccess:
                onReplaceStack([.lineSelection])
            }
        }
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
