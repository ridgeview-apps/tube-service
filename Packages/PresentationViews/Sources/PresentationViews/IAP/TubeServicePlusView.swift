import Models
import SwiftUI

public struct TubeServicePlusView: View {

    public enum Action: Sendable {
        case unlockTapped
        case restoreTapped
    }

    let price: String?
    let onAction: (Action) -> Void

    public init(price: String? = nil, onAction: @escaping (Action) -> Void) {
        self.price = price
        self.onAction = onAction
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.15))
                            .frame(width: 88, height: 88)

                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(Color.accentColor)
                    }

                    VStack(spacing: 8) {
                        Text(.tubeServicePlusTitle)
                            .font(.title2.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text(.tubeServicePlusDescription)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    featureRow(
                        systemImage: "calendar",
                        title: .lineStatusHistoryFeatureTimelineTitle,
                        description: .lineStatusHistoryFeatureTimelineDescription
                    )
                    featureRow(
                        systemImage: "exclamationmark.bubble",
                        title: .lineStatusHistoryFeatureDisruptionsTitle,
                        description: .lineStatusHistoryFeatureDisruptionsDescription
                    )
                    featureRow(
                        systemImage: "arrow.trianglehead.2.clockwise.rotate.90",
                        title: .lineStatusHistoryFeatureRecoveryTitle,
                        description: .lineStatusHistoryFeatureRecoveryDescription
                    )
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle()

                Button {
                    onAction(.unlockTapped)
                } label: {
                    Label(.tubeServicePlusUnlockButtonTitle, systemImage: "lock.open.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                if let price {
                    Text(.tubeServicePlusPurchaseSubtitleWithPrice(price))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text(.tubeServicePlusPurchaseSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Text(.tubeServicePlusDeveloperNote)
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)

                Button {
                    onAction(.restoreTapped)
                } label: {
                    Text(.tubeServicePlusRestoreButtonTitle)
                        .font(.footnote)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
            .padding(20)
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
        }
        .scrollBounceBehavior(.basedOnSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .defaultMaxWidthWithFullBackground()
        .navigationTitle(.tubeServicePlusTitle)
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

#Preview("Price loaded") {
    NavigationStack {
        TubeServicePlusView(price: "£2.99", onAction: { _ in })
    }
}

#Preview("Price loading") {
    NavigationStack {
        TubeServicePlusView(onAction: { _ in })
    }
}
