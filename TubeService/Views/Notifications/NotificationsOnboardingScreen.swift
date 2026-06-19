import DataStores
import Models
import PresentationViews
import StoreKit
import SwiftUI
import UIKit
import UserNotifications

@MainActor
struct NotificationsOnboardingScreen: View {

    let preselectedLine: TrainLineID?

    @Environment(\.dismiss) var dismiss
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
            introContent
                .navigationDestination(for: OnboardingStep.self) { step in
                    switch step {
                    case .paywall:
                        paywallDestination
                    case .lineSelection:
                        NotificationsLineSelectionScreen(
                            selectedLineIDs: $selectedLineIDs,
                            onContinue: { path.append(.schedule) }
                        )
                    case .schedule:
                        NotificationsScheduleScreen(
                            selectedPreset: $selectedPreset,
                            onContinue: { Task { await requestPermissionAndAdvance() } }
                        )
                    case .confirmation:
                        confirmationContent
                    case .permissionDenied:
                        permissionDeniedContent
                    }
                }
        }
    }

    // MARK: - Intro

    private var introContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                heroSection
                featuresCard
                getStartedButton
                notNowButton
            }
            .padding(20)
        }
        .navigationTitle(Text(L10n.notificationsOnboardingNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .withCloseToolbarButton()
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 88, height: 88)

                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }

            VStack(spacing: 8) {
                Text(L10n.notificationsOnboardingHeroTitle)
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)

                Text(L10n.notificationsOnboardingHeroDescription)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var featuresCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            featureRow(
                systemImage: "exclamationmark.bubble",
                title: L10n.notificationsOnboardingFeatureDisruptionAlertsTitle,
                description: L10n.notificationsOnboardingFeatureDisruptionAlertsDescription
            )
            featureRow(
                systemImage: "checkmark.circle",
                title: L10n.notificationsOnboardingFeatureRecoveryAlertsTitle,
                description: L10n.notificationsOnboardingFeatureRecoveryAlertsDescription
            )
            featureRow(
                systemImage: "clock",
                title: L10n.notificationsOnboardingFeatureScheduleTitle,
                description: L10n.notificationsOnboardingFeatureScheduleDescription
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var getStartedButton: some View {
        Button {
            if purchases.hasTubeServicePlus {
                path.append(.lineSelection)
            } else {
                path.append(.paywall)
            }
        } label: {
            Text(L10n.globalGetStarted)
                .frame(maxWidth: .infinity)
                .frame(height: 20)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }

    private var notNowButton: some View {
        Button {
            dismiss()
        } label: {
            Text(L10n.globalNotNow)
        }
        .foregroundStyle(.secondary)
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

    // MARK: - Confirmation

    private var confirmationContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 88, height: 88)

                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.green)
                    }

                    VStack(spacing: 8) {
                        Text(L10n.notificationsConfirmationTitle)
                            .font(.title2.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text(L10n.notificationsConfirmationDescription)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                selectedLinesCard
            }
            .padding(20)
        }
        .navigationTitle(Text(L10n.notificationsConfirmationNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Text(L10n.globalDone)
                }
            }
        }
    }

    private var selectedLinesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(selectedLineIDs.sorted(by: { $0.name < $1.name }), id: \.rawValue) { lineID in
                HStack(spacing: 10) {
                    Circle()
                        .fill(lineID.backgroundColor)
                        .frame(width: 12, height: 12)
                    Text(lineID.name)
                        .font(.subheadline)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    // MARK: - Permission denied

    private var permissionDeniedContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.15))
                            .frame(width: 88, height: 88)

                        Image(systemName: "bell.slash.fill")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(.orange)
                    }

                    VStack(spacing: 8) {
                        Text(L10n.notificationsPermissionDeniedTitle)
                            .font(.title2.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text(L10n.notificationsPermissionDeniedDescription)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text(L10n.openAppSettingsButtonTitle)
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                notNowButton
            }
            .padding(20)
        }
        .navigationTitle(Text(L10n.notificationsPermissionDeniedNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helpers

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

    private func featureRow(
        systemImage: String,
        title: LocalizedStringResource,
        description: LocalizedStringResource
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(Color.accentColor)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NotificationsOnboardingScreen(preselectedLine: .victoria)
        }
    }
#endif
