import SwiftUI

public enum PaywallContext: Sendable {
    case statusHistory
    case notifications
}

public struct TubeServicePlusMarketingContent: View {

    let context: PaywallContext

    public init(context: PaywallContext = .statusHistory) {
        self.context = context
    }

    public var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 64, height: 64)

                    Image(systemName: iconName)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }

                VStack(spacing: 8) {
                    Text(title)
                        .font(.title2.weight(.bold))
                        .multilineTextAlignment(.center)

                    Text(description)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                ForEach(features) { feature in
                    featureRow(feature)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()

            Text(.tubeServicePlusDeveloperNote)
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
    }

    private var iconName: String {
        switch context {
        case .statusHistory: "clock.arrow.trianglehead.counterclockwise.rotate.90"
        case .notifications: "bell.badge.fill"
        }
    }

    private var title: LocalizedStringResource {
        switch context {
        case .statusHistory: .tubeServicePlusTitle
        case .notifications: .tubeServicePlusNotificationsTitle
        }
    }

    private var description: LocalizedStringResource {
        switch context {
        case .statusHistory: .tubeServicePlusDescription
        case .notifications: .tubeServicePlusNotificationsDescription
        }
    }

    private var features: [Feature] {
        switch context {
        case .statusHistory:
            [
                Feature(
                    id: "status-timeline",
                    systemImage: "calendar",
                    title: .tubeServicePlusFeatureTimelineTitle,
                    description: .tubeServicePlusFeatureTimelineDescription
                ),
                Feature(
                    id: "status-recovery",
                    systemImage: "arrow.trianglehead.2.clockwise.rotate.90",
                    title: .tubeServicePlusFeatureRecoveryTitle,
                    description: .tubeServicePlusFeatureRecoveryDescription
                ),
                // Plus unlocks both features, so each paywall mentions the other.
                Feature(
                    id: "status-also-notifications",
                    systemImage: "bell.badge",
                    title: .tubeServicePlusFeatureAlsoNotificationsTitle,
                    description: .tubeServicePlusFeatureAlsoNotificationsDescription
                )
            ]
        case .notifications:
            [
                Feature(
                    id: "notifications-lines",
                    systemImage: "tram.fill",
                    title: .tubeServicePlusFeatureNotificationsLinesTitle,
                    description: .tubeServicePlusFeatureNotificationsLinesDescription
                ),
                Feature(
                    id: "notifications-recovery",
                    systemImage: "checkmark.circle",
                    title: .tubeServicePlusFeatureNotificationsRecoveryTitle,
                    description: .tubeServicePlusFeatureNotificationsRecoveryDescription
                ),
                Feature(
                    id: "notifications-schedules",
                    systemImage: "calendar.badge.clock",
                    title: .tubeServicePlusFeatureNotificationsSchedulesTitle,
                    description: .tubeServicePlusFeatureNotificationsSchedulesDescription
                ),
                Feature(
                    id: "notifications-also-status-history",
                    systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                    title: .tubeServicePlusFeatureAlsoStatusHistoryTitle,
                    description: .tubeServicePlusFeatureAlsoStatusHistoryDescription
                )
            ]
        }
    }

    private func featureRow(_ feature: Feature) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: feature.systemImage)
                .font(.headline)
                .foregroundStyle(Color.accentColor)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(feature.title)
                    .font(.headline)
                Text(feature.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private struct Feature: Identifiable {
        let id: String
        let systemImage: String
        let title: LocalizedStringResource
        let description: LocalizedStringResource
    }
}


// MARK: - Previews

#Preview("Status History") {
    TubeServicePlusMarketingContent(context: .statusHistory)
        .padding()
}

#Preview("Notifications") {
    TubeServicePlusMarketingContent(context: .notifications)
        .padding()
}
