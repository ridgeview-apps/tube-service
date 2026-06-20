import Models
import SwiftUI

public struct NotificationsOnboardingIntroView: View {

    public enum Action: Sendable {
        case getStarted
        case notNow
    }

    public let onAction: (Action) -> Void

    public init(onAction: @escaping (Action) -> Void) {
        self.onAction = onAction
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                heroSection
                featuresCard
                getStartedButton
                notNowButton
            }
            .padding(20)
        }
        .navigationTitle(Text(.notificationsOnboardingNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
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
                Text(.notificationsOnboardingHeroTitle)
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)

                Text(.notificationsOnboardingHeroDescription)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var featuresCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            featureRow(
                systemImage: "exclamationmark.bubble",
                title: .notificationsOnboardingFeatureDisruptionAlertsTitle,
                description: .notificationsOnboardingFeatureDisruptionAlertsDescription
            )
            featureRow(
                systemImage: "checkmark.circle",
                title: .notificationsOnboardingFeatureRecoveryAlertsTitle,
                description: .notificationsOnboardingFeatureRecoveryAlertsDescription
            )
            featureRow(
                systemImage: "clock",
                title: .notificationsOnboardingFeatureScheduleTitle,
                description: .notificationsOnboardingFeatureScheduleDescription
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var getStartedButton: some View {
        Button {
            onAction(.getStarted)
        } label: {
            Text(.globalGetStarted)
                .frame(maxWidth: .infinity)
                .frame(height: 20)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }

    private var notNowButton: some View {
        Button {
            onAction(.notNow)
        } label: {
            Text(.globalNotNow)
        }
        .foregroundStyle(.secondary)
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
        NavigationStack {
            NotificationsOnboardingIntroView(onAction: { _ in })
        }
    }
#endif
