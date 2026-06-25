import Models
import SwiftUI

public struct NotificationsScheduleView: View {

    public enum Mode {
        case onboarding
        case manage
    }

    public let mode: Mode
    public let onDone: ([TrainLineID: LineNotificationSettings]) -> Void

    @State private var settings: [TrainLineID: LineNotificationSettings]
    private let sortedLineIDs: [TrainLineID]

    public init(
        mode: Mode = .onboarding,
        initialSettings: [TrainLineID: LineNotificationSettings],
        onDone: @escaping ([TrainLineID: LineNotificationSettings]) -> Void
    ) {
        self.mode = mode
        self.onDone = onDone
        _settings = State(initialValue: initialSettings)
        sortedLineIDs = initialSettings.keys.sorted(by: { $0.name < $1.name })
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(sortedLineIDs, id: \.rawValue) { lineID in
                    lineScheduleCard(for: lineID)
                }
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                onDone(settings)
            } label: {
                Text(.globalDone)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(20)
            .background(.bar)
        }
        .navigationTitle(Text(.notificationsScheduleNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func currentSettings(for lineID: TrainLineID) -> LineNotificationSettings {
        settings[lineID] ?? LineNotificationSettings()
    }

    private func isSubSettingsDisabled(for lineID: TrainLineID) -> Bool {
        mode == .manage && !currentSettings(for: lineID).isEnabled
    }

    @ViewBuilder
    private func lineScheduleCard(for lineID: TrainLineID) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader(for: lineID)

            Divider()

            VStack(spacing: 0) {
                scheduleRow(for: lineID)

                if mode == .manage {
                    Divider()
                    recoveryAlertsRow(for: lineID)
                }
            }
            .opacity(isSubSettingsDisabled(for: lineID) ? 0.4 : 1)
            .disabled(isSubSettingsDisabled(for: lineID))
        }
        .padding(16)
        .background(alignment: .leading) {
            lineID.backgroundColor.frame(width: 6)
        }
        .cardStyle()
    }

    private func cardHeader(for lineID: TrainLineID) -> some View {
        HStack {
            Text(lineID.longName)
                .font(.subheadline)
                .fontWeight(.semibold)
            if mode == .manage {
                Spacer(minLength: 8)
                Toggle(isOn: settingsBinding(for: lineID).isEnabled) {
                    Text(lineID.longName)
                }
                .labelsHidden()
            }
        }
        .padding(.bottom, 10)
    }

    @ViewBuilder
    private func scheduleRow(for lineID: TrainLineID) -> some View {
        let lineSettings = currentSettings(for: lineID)
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(L10n.notificationsConfirmationScheduleLabel)
                    .foregroundStyle(.secondary)
                Text(lineSettings.schedulePreset.description)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            Spacer(minLength: 8)
            Menu {
                Picker(
                    L10n.notificationsConfirmationScheduleLabel,
                    selection: settingsBinding(for: lineID).schedulePreset
                ) {
                    ForEach(NotificationSchedulePreset.allDisplayCases, id: \.self) { p in
                        Text(p.title).tag(p)
                    }
                }
                .labelsHidden()
            } label: {
                HStack(spacing: 4) {
                    Text(lineSettings.schedulePreset.title)
                        .multilineTextAlignment(.trailing)
                    Image(systemName: "chevron.up.chevron.down")
                        .imageScale(.small)
                }
                .foregroundStyle(.tint)
            }
            .menuOrder(.fixed)
            .buttonStyle(.plain)
        }
        .font(.subheadline)
        .padding(.vertical, 10)
    }

    private func recoveryAlertsRow(for lineID: TrainLineID) -> some View {
        Toggle(isOn: settingsBinding(for: lineID).notifyRecoveries) {
            VStack(alignment: .leading, spacing: 2) {
                Text(L10n.notificationsLineRecoveryAlertsLabel)
                    .foregroundStyle(.secondary)
                Text(L10n.notificationsOnboardingFeatureRecoveryAlertsDescription)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .font(.subheadline)
        .padding(.vertical, 10)
    }

    private func settingsBinding(for lineID: TrainLineID) -> Binding<LineNotificationSettings> {
        Binding(
            get: { settings[lineID] ?? LineNotificationSettings() },
            set: { settings[lineID] = $0 }
        )
    }
}


// MARK: - Previews

#if DEBUG
    #Preview("Onboarding") {
        NavigationStack {
            NotificationsScheduleView(
                mode: .onboarding,
                initialSettings: [
                    .victoria: LineNotificationSettings(schedulePreset: .weekdayPeak),
                    .jubilee: LineNotificationSettings(schedulePreset: .anytime),
                    .central: LineNotificationSettings(schedulePreset: .weekends)
                ],
                onDone: { _ in }
            )
        }
    }

    #Preview("Manage") {
        NavigationStack {
            NotificationsScheduleView(
                mode: .manage,
                initialSettings: [
                    .victoria: LineNotificationSettings(schedulePreset: .weekdayPeak),
                    .jubilee: LineNotificationSettings(isEnabled: false, schedulePreset: .anytime),
                    .central: LineNotificationSettings(schedulePreset: .weekends)
                ],
                onDone: { _ in }
            )
        }
    }
#endif
