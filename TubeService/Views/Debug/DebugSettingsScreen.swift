import DataStores
import Models
import SwiftUI
import UserNotifications

struct DebugSettingsScreen: View {
    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @AppStorage(
        UserDefaults.Keys.featureFlags.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var featureFlags: FeatureFlags = .default

    @AppStorage(
        UserDefaults.Keys.notificationState.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var notificationState: NotificationState = .default

    @Environment(\.appConfig) private var appConfig
    @Environment(NotificationsDataStore.self) private var notifications
    @Environment(PurchaseStore.self) private var purchases

    @State private var showDebugConfirmAlert = false
    @State private var copiedField: String?

    var body: some View {
        Form {
            Section {
                Toggle("Status History", isOn: $featureFlags.isStatusHistoryEnabled)
                Toggle("Notifications", isOn: $featureFlags.isNotificationsEnabled)
                Toggle("Bypass Paywall", isOn: $featureFlags.isPaywallBypassed)
                    .onChange(of: featureFlags.isPaywallBypassed) { _, newValue in
                        purchases.isPaywallBypassed = newValue
                    }
            } header: {
                Text("Feature Toggles")
            }
            Section {
                Button("Reset user defaults?") {
                    showDebugConfirmAlert = true
                }
            } header: {
                Text("User defaults")
            }
            .alert("Are you sure?", isPresented: $showDebugConfirmAlert) {
                Button("No", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    userPreferences = .default
                    notificationState = .default
                }
            }
            purchaseStoreSection
            pushNotificationsSection
        }
    }

    private var purchaseStoreSection: some View {
        let config = appConfig.purchaseStore
        return Section {
            expandedCopyableRow(label: "Plus Product ID", value: config.tubeServicePlusProductID)
            expandedCopyableRow(label: "Monthly Product ID", value: config.tubeServicePlusMonthlyProductID)
        } header: {
            Text("Purchase Store")
        } footer: {
            if let field = copiedField, isPurchaseStoreField(field) {
                Text("\(field) copied to clipboard")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var pushNotificationsSection: some View {
        let info = notifications.debugInfo
        return Section {
            debugRow(label: "Auth Status", value: info.authorizationStatus.debugDescription)
            debugRow(label: "Device Enabled", value: info.deviceEnabled.map { $0 ? "true" : "false" } ?? "nil")
            debugRow(label: "App Variant", value: info.appVariant ?? "nil")
            debugRow(label: "Onboarding Done", value: info.hasCompletedOnboarding ? "true" : "false")
            debugRow(label: "Configured Lines", value: "\(info.configuredLineCount)")
            copyableRow(label: "Device ID", value: info.deviceId)
            copyableRow(label: "Push Token", value: info.pushToken)
            expandedCopyableRow(label: "Last Registration Error", value: info.lastRegistrationError)
        } header: {
            Text("Push Notifications")
        } footer: {
            if let field = copiedField, !isPurchaseStoreField(field) {
                Text("\(field) copied to clipboard")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func isPurchaseStoreField(_ field: String) -> Bool {
        field == "Plus Product ID" || field == "Monthly Product ID"
    }

    private func debugRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .font(.caption)
                .monospaced()
        }
    }

    @ViewBuilder
    private func copyableRow(label: String, value: String?) -> some View {
        Button {
            guard let value else { return }
            UIPasteboard.general.string = value
            copiedField = label
        } label: {
            HStack {
                Text(label)
                    .foregroundStyle(.primary)
                Spacer()
                Text(value ?? "nil")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .monospaced()
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }
        .disabled(value == nil)
    }

    @ViewBuilder
    private func expandedCopyableRow(label: String, value: String?) -> some View {
        Button {
            guard let value else { return }
            UIPasteboard.general.string = value
            copiedField = label
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .foregroundStyle(.primary)
                Text(value ?? "nil")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .monospaced()
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .disabled(value == nil)
    }
}

extension UNAuthorizationStatus {
    fileprivate var debugDescription: String {
        switch self {
        case .notDetermined: "notDetermined"
        case .denied: "denied"
        case .authorized: "authorized"
        case .provisional: "provisional"
        case .ephemeral: "ephemeral"
        @unknown default: "unknown"
        }
    }
}
