import Models
import SwiftUI

public struct ManageSingleLineNotificationsView: View {

    public enum Action {
        case close
        case tappedOtherLine(TrainLineID)
        case addedLine(TrainLineID)
        case openSettings
        /// The pinned "Turn on notifications" button was tapped for a line that has no settings yet.
        case add(LineNotificationSettings)
        /// An existing line's settings were edited; each edit is saved as it's made.
        case update(LineNotificationSettings)
        case remove
        case resumeAlerts
    }

    private let lineID: TrainLineID
    private let existingSettings: LineNotificationSettings?
    private let showsOtherLines: Bool
    private let allSettings: [LineNotificationSettings]
    private let showsPermissionWarning: Bool
    private let showsPausedAlertsWarning: Bool
    private let savingState: LoadingState
    private let onAction: (Action) -> Void

    @State private var settings: LineNotificationSettings

    @State private var isOtherLinesExpanded = false
    @State private var saveFeedbackTrigger = false
    @State private var removeFeedbackTrigger = false

    public init(
        lineID: TrainLineID,
        existingSettings: LineNotificationSettings?,
        showsOtherLines: Bool,
        allSettings: [LineNotificationSettings] = [],
        showsPermissionWarning: Bool = false,
        showsPausedAlertsWarning: Bool = false,
        savingState: LoadingState = .loaded,
        onAction: @escaping (Action) -> Void
    ) {
        self.lineID = lineID
        self.existingSettings = existingSettings
        self.showsOtherLines = showsOtherLines
        self.allSettings = allSettings
        self.showsPermissionWarning = showsPermissionWarning
        self.showsPausedAlertsWarning = showsPausedAlertsWarning
        self.savingState = savingState
        self.onAction = onAction
        _settings = State(initialValue: existingSettings ?? .defaultValue(lineID: lineID))
    }

    // MARK: - Computed Properties

    private var isAddingSingleLine: Bool { existingSettings == nil }

    private var configuredLines: [LineNotificationSettings] {
        allSettings.filter { $0.lineID != lineID }.sorted { $0.lineID.name < $1.lineID.name }
    }

    private var unconfiguredLineIDs: [TrainLineID] {
        let configuredIDs = Set(allSettings.map(\.lineID))
        return TrainLineID.allCases
            .filter { $0 != lineID && !configuredIDs.contains($0) }
            .sorted { $0.name < $1.name }
    }

    // MARK: - Body

    public var body: some View {
        List {
            if showsPermissionWarning {
                permissionWarningRow
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 6, trailing: 20))
            }

            if showsPausedAlertsWarning {
                pausedAlertsWarningRow
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
            }

            if savingState != .loaded {
                LoadingStatusView(loadingState: savingState)
                    .defaultLoadingStatusStyle()
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
            }

            scheduleCard

            Text(.notificationsLineConfigExplainer)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 24, bottom: 6, trailing: 24))

            if showsOtherLines {
                otherLinesSummarySection
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        // New lines are saved from the pinned button; edits to existing lines are saved as they're made.
        .turnOnNotificationsBar(isShown: isAddingSingleLine, isDisabled: savingState == .loading) {
            saveFeedbackTrigger.toggle()
            onAction(.add(settings))
        }
        .onChange(of: settings) { _, newSettings in
            // Skips the reset below, which puts back what's already saved.
            guard let existingSettings, newSettings != existingSettings else { return }
            onAction(.update(newSettings))
        }
        .onChange(of: savingState) { _, newState in
            // A failed save leaves the server unchanged, so the controls go back to what's saved.
            if case .failure = newState, let existingSettings {
                settings = existingSettings
            }
        }
        .navigationTitle(Text(.notificationsLineConfigNavTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.success, trigger: saveFeedbackTrigger)
        .sensoryFeedback(.warning, trigger: removeFeedbackTrigger)
        .toolbar {
            // Nothing is saved for a new line until it's turned on, so closing cancels it;
            // an existing line's edits are already saved, so closing confirms them.
            if isAddingSingleLine {
                ToolbarItem(placement: .cancellationAction) { closeButton(systemImage: "xmark") }
            } else {
                ToolbarItem(placement: .confirmationAction) { closeButton(systemImage: "checkmark") }
            }
        }
    }

    // MARK: - Permission Warning

    private var permissionWarningRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: 4) {
                    Text(.notificationsManagePermissionWarningTitle)
                        .font(.subheadline.weight(.semibold))
                    Text(.notificationsManagePermissionWarningSubtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                onAction(.openSettings)
            } label: {
                Text(.notificationsManageOpenSettingsButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .controlSize(.regular)
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - Paused Alerts Warning

    private var pausedAlertsWarningRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: 4) {
                    Text(.notificationsLineConfigPausedAlertsWarningTitle)
                        .font(.subheadline.weight(.semibold))
                    Text(.notificationsLineConfigPausedAlertsWarningSubtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                onAction(.resumeAlerts)
            } label: {
                Text(.notificationsLineConfigResumeAlertsButton)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .controlSize(.regular)
            .disabled(savingState == .loading)
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - Schedule Card

    private var scheduleCard: some View {
        // Existing lines get a menu to pause or resume them (saved with the rest of the edit) or remove them.
        // The card confirms the removal itself, so `handleRemoveLine` only runs once confirmed.
        LineScheduleCard(
            settings: $settings,
            accessory: isAddingSingleLine ? .none : .actionsMenu(onRemove: handleRemoveLine)
        )
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 28, leading: 20, bottom: 6, trailing: 20))
    }

    private func handleRemoveLine() {
        removeFeedbackTrigger.toggle()
        onAction(.remove)
    }

    // MARK: - Other Lines Summary

    @ViewBuilder
    private var otherLinesSummarySection: some View {
        if !configuredLines.isEmpty {
            otherLinesCard
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 24, leading: 20, bottom: 12, trailing: 20))
        } else if !unconfiguredLineIDs.isEmpty {
            addLineMenu
                .dashedCardStyle()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 24, leading: 20, bottom: 12, trailing: 20))
        }
    }

    private var otherLinesCard: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    isOtherLinesExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Text(.notificationsLineConfigOtherLineAlerts)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                    if !isOtherLinesExpanded {
                        Text("\(configuredLines.count)")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                            .transition(.opacity)
                    }
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isOtherLinesExpanded ? 90 : 0))
                        .animation(.spring(duration: 0.3), value: isOtherLinesExpanded)
                        .foregroundStyle(.tertiary)
                        .font(.caption.weight(.semibold))
                }
                .padding(.horizontal, 16)
                .frame(minHeight: 52)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isOtherLinesExpanded {
                Divider()
                    .padding(.leading, 40)
                LineNotificationSettingsSummary(
                    settings: configuredLines,
                    onSelect: { onAction(.tappedOtherLine($0)) }
                )
                if !unconfiguredLineIDs.isEmpty {
                    Divider()
                        .padding(.leading, 40)
                    addLineMenu
                }
            }
        }
        .cardStyle()
    }

    private var addLineMenu: some View {
        AddLineMenu(
            lineIDs: unconfiguredLineIDs,
            label: .notificationsLineConfigAddAnotherLine,
            onSelect: { onAction(.addedLine($0)) }
        )
    }

    // MARK: - Toolbar

    private func closeButton(systemImage: String) -> some View {
        Button {
            onAction(.close)
        } label: {
            Label {
                Text(isAddingSingleLine ? .globalCancel : .globalDone)
            } icon: {
                Image(systemName: systemImage)
            }
            .labelStyle(.iconOnly)
        }
    }
}

// MARK: - Previews

#if DEBUG
    import ModelStubs

    #Preview("New line") {
        NavigationStack {
            ManageSingleLineNotificationsView(
                lineID: .jubilee,
                existingSettings: nil,
                showsOtherLines: true,
                onAction: { print($0) }
            )
        }
    }

    #Preview("Editing existing") {
        NavigationStack {
            ManageSingleLineNotificationsView(
                lineID: .jubilee,
                existingSettings: .defaultValue(lineID: .jubilee),
                showsOtherLines: true,
                onAction: { print($0) }
            )
        }
    }

    #Preview("Alerts paused") {
        NavigationStack {
            ManageSingleLineNotificationsView(
                lineID: .jubilee,
                existingSettings: .defaultValue(lineID: .jubilee, isEnabled: false),
                showsOtherLines: true,
                onAction: { print($0) }
            )
        }
    }

    #Preview("All alerts paused + line paused") {
        NavigationStack {
            ManageSingleLineNotificationsView(
                lineID: .jubilee,
                existingSettings: .defaultValue(lineID: .jubilee, isEnabled: false),
                showsOtherLines: true,
                showsPausedAlertsWarning: true,
                onAction: { print($0) }
            )
        }
    }
#endif
