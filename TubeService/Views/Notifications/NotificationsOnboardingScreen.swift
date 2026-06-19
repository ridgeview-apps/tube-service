import SwiftUI
import UIKit
import UserNotifications

@MainActor
struct NotificationsOnboardingScreen: View {

    @Environment(\.dismiss) var dismiss

    @State private var isRequesting = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                heroSection
                featuresCard
                enableButton
                notNowButton
            }
            .padding(20)
        }
        .navigationTitle("Line Status Alerts")
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
                Text("Stay Ahead of Disruptions")
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)

                Text("Get notified when your lines are disrupted and when service returns to normal.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var featuresCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            featureRow(
                systemImage: "exclamationmark.bubble",
                title: "Disruption Alerts",
                description: "Get notified when lines you follow are disrupted."
            )
            featureRow(
                systemImage: "checkmark.circle",
                title: "Recovery Alerts",
                description: "Know when service has returned to normal."
            )
            featureRow(
                systemImage: "clock",
                title: "Customisable Schedule",
                description: "Choose when you want to receive alerts."
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var enableButton: some View {
        Button {
            Task { await requestPermission() }
        } label: {
            Group {
                if isRequesting {
                    ProgressView()
                } else {
                    Text("Enable Notifications")
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 20)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(isRequesting)
    }

    private var notNowButton: some View {
        Button("Not Now") {
            dismiss()
        }
        .foregroundStyle(.secondary)
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

    private func requestPermission() async {
        isRequesting = true
        defer { isRequesting = false }
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } catch {
            // Permission request failed; dismiss anyway
        }
        dismiss()
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NavigationStack {
                NotificationsOnboardingScreen()
            }
        }
    }
#endif
