import Models
import SwiftUI

public struct NotificationsScheduleView: View {

    public struct ManageConfiguration {
        public let focusedLineIDs: [TrainLineID]
        public let otherLineIDs: [TrainLineID]
        public let onCancel: (() -> Void)?

        public init(
            focusedLineIDs: [TrainLineID],
            otherLineIDs: [TrainLineID],
            onCancel: (() -> Void)? = nil
        ) {
            self.focusedLineIDs = focusedLineIDs
            self.otherLineIDs = otherLineIDs
            self.onCancel = onCancel
        }
    }

    public enum Mode {
        case onboarding
        case manage(ManageConfiguration)
    }

    public let mode: Mode
    public let onDone: ([TrainLineID: LineNotificationSettings]) -> Void

    @State private var settings: [TrainLineID: LineNotificationSettings]
    @State private var expandedLineIDs: Set<TrainLineID> = []
    @State private var isOtherLinesExpanded: Bool = false
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
                switch mode {
                case .onboarding:
                    ForEach(sortedLineIDs, id: \.rawValue) { lineID in
                        lineScheduleCard(for: lineID)
                    }
                case .manage(let config):
                    ForEach(config.focusedLineIDs, id: \.rawValue) { lineID in
                        lineScheduleCard(for: lineID)
                    }
                    if !config.otherLineIDs.isEmpty {
                        otherLinesSection(config.otherLineIDs)
                    }
                }
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            if case .onboarding = mode {
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
        }
        .navigationTitle(Text(.notificationsScheduleNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if case .manage(let config) = mode {
                if let onCancel = config.onCancel {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(L10n.globalCancel, action: onCancel)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.globalDone) {
                        onDone(settings)
                    }
                }
            }
        }
    }

    private func currentSettings(for lineID: TrainLineID) -> LineNotificationSettings {
        settings[lineID] ?? LineNotificationSettings()
    }

    private func isSubSettingsDisabled(for lineID: TrainLineID) -> Bool {
        if case .manage = mode {
            return !currentSettings(for: lineID).isEnabled
        }
        return false
    }

    @ViewBuilder
    private func otherLinesSection(_ lineIDs: [TrainLineID]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    isOtherLinesExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(L10n.notificationsOtherLinesSectionTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isOtherLinesExpanded ? 90 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isOtherLinesExpanded {
                ForEach(lineIDs, id: \.rawValue) { lineID in
                    lineScheduleCard(for: lineID)
                }
            }
        }
    }

    @ViewBuilder
    private func lineScheduleCard(for lineID: TrainLineID) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader(for: lineID)

            Divider()

            VStack(spacing: 0) {
                settingsSummaryRow(for: lineID)
                if expandedLineIDs.contains(lineID) {
                    scheduleRow(for: lineID)
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
            if case .manage = mode {
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
    private func settingsSummaryRow(for lineID: TrainLineID) -> some View {
        let lineSettings = currentSettings(for: lineID)
        let isExpanded = expandedLineIDs.contains(lineID)
        Button {
            withAnimation(.spring(duration: 0.3)) {
                if isExpanded {
                    expandedLineIDs.remove(lineID)
                } else {
                    expandedLineIDs.insert(lineID)
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(L10n.notificationsLineAlertsLabel)
                    .foregroundStyle(.primary)
                Spacer(minLength: 8)
                if !isExpanded {
                    Text(lineSettings.schedulePreset.title)
                        .foregroundStyle(.secondary)
                }
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .font(.subheadline)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func scheduleRow(for lineID: TrainLineID) -> some View {
        let lineSettings = currentSettings(for: lineID)
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.notificationsConfirmationScheduleLabel)
                    .foregroundStyle(.primary)
                if let description = lineSettings.schedulePreset.description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
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
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.notificationsLineRecoveryAlertsLabel)
                    .foregroundStyle(.primary)
                Text(L10n.notificationsOnboardingFeatureRecoveryAlertsDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
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

    #Preview("Manage - from line (sheet)") {
        NavigationStack {
            NotificationsScheduleView(
                mode: .manage(
                    NotificationsScheduleView.ManageConfiguration(
                        focusedLineIDs: [.victoria],
                        otherLineIDs: TrainLineID.allCases
                            .filter { $0 != .victoria }
                            .sorted { $0.name < $1.name },
                        onCancel: {}
                    )
                ),
                initialSettings: [
                    .victoria: LineNotificationSettings(schedulePreset: .weekdayPeak),
                    .jubilee: LineNotificationSettings(isEnabled: false, schedulePreset: .anytime),
                    .central: LineNotificationSettings(schedulePreset: .weekends)
                ],
                onDone: { _ in }
            )
        }
    }

    #Preview("Manage - from settings (stack)") {
        NavigationStack {
            NotificationsScheduleView(
                mode: .manage(
                    NotificationsScheduleView.ManageConfiguration(
                        focusedLineIDs: [.victoria, .jubilee, .central]
                            .sorted { $0.name < $1.name },
                        otherLineIDs: TrainLineID.allCases
                            .filter { ![TrainLineID.victoria, .jubilee, .central].contains($0) }
                            .sorted { $0.name < $1.name }
                    )
                ),
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
