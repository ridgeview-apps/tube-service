import DataStores
import Models
import PresentationViews
import StoreKit
import SwiftUI

@MainActor
struct NotificationsOnboardingScreen: View {

    let preselectedLine: TrainLineID?

    @Environment(\.dismiss) var dismiss
    @Environment(PurchaseStore.self) var purchases

    @State private var path: [OnboardingStep] = []
    @State private var selectedLineIDs: Set<TrainLineID>
    @State private var selectedPreset: NotificationSchedulePreset = .weekdayPeak

    enum OnboardingStep: Hashable {
        case paywall
        case lineSelection
        case schedule
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
                            onContinue: {
                                // Stage 4c: permission request + save
                                dismiss()
                            }
                        )
                    }
                }
        }
    }

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
