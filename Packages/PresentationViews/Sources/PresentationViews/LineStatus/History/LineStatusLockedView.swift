import Models
import SwiftUI

struct LineStatusLockedView: View {

    let lineID: TrainLineID
    let onAction: (LineStatusHistoryView.Action) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(lineID.backgroundColor.opacity(0.15))
                            .frame(width: 88, height: 88)

                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(lineID.backgroundColor)
                    }

                    VStack(spacing: 8) {
                        Text(.lineStatusHistoryLockedTitle)
                            .font(.title2.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text(.lineStatusHistoryLockedDescription(lineID.longName))
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
                .cardStyle()

                Button {
                    onAction(.unlockTapped)
                } label: {
                    Label(.lineStatusHistoryUnlockButtonTitle, systemImage: "lock.open.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(lineID.backgroundColor)

                Text(.lineStatusHistoryPurchasePlaceholder)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    private func featureRow(
        systemImage: String,
        title: LocalizedStringResource,
        description: LocalizedStringResource
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(lineID.backgroundColor)
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
