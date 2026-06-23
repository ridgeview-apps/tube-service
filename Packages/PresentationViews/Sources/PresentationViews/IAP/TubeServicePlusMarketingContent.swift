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
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 88, height: 88)

                    Image(systemName: iconName)
                        .font(.system(size: 36, weight: .semibold))
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

            VStack(alignment: .leading, spacing: 16) {
                featureRow(
                    systemImage: "calendar",
                    title: .tubeServicePlusFeatureTimelineTitle,
                    description: .tubeServicePlusFeatureTimelineDescription
                )
                featureRow(
                    systemImage: "exclamationmark.bubble",
                    title: .tubeServicePlusFeatureDisruptionsTitle,
                    description: .tubeServicePlusFeatureDisruptionsDescription
                )
                featureRow(
                    systemImage: "arrow.trianglehead.2.clockwise.rotate.90",
                    title: .tubeServicePlusFeatureRecoveryTitle,
                    description: .tubeServicePlusFeatureRecoveryDescription
                )
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()

            Text(.tubeServicePlusDeveloperNote)
                .font(.footnote)
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

#Preview("Status History") {
    TubeServicePlusMarketingContent(context: .statusHistory)
        .padding()
}

#Preview("Notifications") {
    TubeServicePlusMarketingContent(context: .notifications)
        .padding()
}
