import DataStores
import PresentationViews
import StoreKit
import SwiftUI

@MainActor
struct TubeServicePlusScreen: View {

    @Environment(\.dismiss) var dismiss
    @Environment(PurchaseStore.self) var purchases

    var body: some View {
        SubscriptionStoreView(productIDs: ["com.ridgeviewapps.tubeservice.plus"]) {
            marketingContent
        }
        .onChange(of: purchases.hasTubeServicePlus) { _, isPlus in
            if isPlus { dismiss() }
        }
        .navigationTitle("Tube Service Plus")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var marketingContent: some View {
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
                    Text("Know Your Line, Better")
                        .font(.title2.weight(.bold))
                        .multilineTextAlignment(.center)

                    Text(
                        "Get the full picture of today's service — when disruptions started, how long they lasted, and when things got back to normal."
                    )
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                featureRow(
                    systemImage: "calendar",
                    title: "Daily Timeline",
                    description: "See a timeline of service changes across the day, updated throughout."
                )
                featureRow(
                    systemImage: "exclamationmark.bubble",
                    title: "Disruption History",
                    description: "Review recent disruptions, what caused them, and when they were resolved."
                )
                featureRow(
                    systemImage: "arrow.trianglehead.2.clockwise.rotate.90",
                    title: "Recovery Tracking",
                    description: "See when and how quickly the service returned to normal after disruptions."
                )
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()

            Text(
                "Tube Service is built by one person. Plus helps cover server costs and keeps the app free for everyone."
            )
            .font(.footnote)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
        }
        .padding(20)
    }

    private func featureRow(systemImage: String, title: String, description: String) -> some View {
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
            NavigationStack {
                TubeServicePlusScreen()
            }
        }
    }
#endif
