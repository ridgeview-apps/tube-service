import Models
import SwiftUI

public struct ManageSingleLineNotificationsView: View {

    public enum Action {
        case cancel
        case tappedOtherLine(TrainLineID)
        case addedLine(TrainLineID)
        case openSettings
        case save(LineNotificationSettings)
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

    @State private var showDiscardChangesConfirmation = false
    @State private var showRemoveConfirmation = false
    @State private var isOtherLinesExpanded = false
    @State private var saveFeedbackTrigger = false
    @State private var removeFeedbackTrigger = false
    @State private var bellBounce = false

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

    private var hasUnsavedChanges: Bool {
        if let existingSettings {
            return settings != existingSettings
        } else {
            return settings != .defaultValue(lineID: lineID)
        }
    }

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

            if isAddingSingleLine {
                turnOnAlertsButton
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
            }

            if showsOtherLines {
                otherLinesSummarySection
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle(Text(.notificationsLineConfigNavTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.success, trigger: saveFeedbackTrigger)
        .sensoryFeedback(.warning, trigger: removeFeedbackTrigger)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { cancelButton }
            if !isAddingSingleLine {
                ToolbarItem(placement: .confirmationAction) { saveButton }
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
        LineScheduleCard(
            settings: $settings,
            accessory: isAddingSingleLine ? .none : .actionsMenu(onRemove: { showRemoveConfirmation = true })
        )
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 28, leading: 20, bottom: 6, trailing: 20))
        .confirmationDialog(
            String(localized: .notificationsLineConfigRemoveConfirmationTitle(lineID.longName)),
            isPresented: $showRemoveConfirmation,
            titleVisibility: .visible
        ) {
            Button(.globalRemove, role: .destructive, action: handleRemoveLine)
        } message: {
            Text(.notificationsLineConfigRemoveConfirmationMessage)
        }
    }

    private func handleRemoveLine() {
        removeFeedbackTrigger.toggle()
        onAction(.remove)
    }

    // MARK: - Turn On CTA

    /// Styled like onboarding's pinned "Turn on notifications" button; the line colour is kept for identity only.
    private var turnOnAlertsButton: some View {
        Button {
            saveFeedbackTrigger.toggle()
            onAction(.save(settings))
        } label: {
            Label {
                Text(.notificationsLineConfigTurnOnButton)
            } icon: {
                Image(systemName: "bell.fill")
                    .symbolEffect(.bounce, value: bellBounce)
            }
            .labelStyle(.titleAndIcon)
            .font(.body)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(savingState == .loading)
        .onAppear { bellBounce = true }
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

    private var cancelButton: some View {
        Button {
            if hasUnsavedChanges {
                showDiscardChangesConfirmation = true
            } else {
                onAction(.cancel)
            }
        } label: {
            Image(systemName: "xmark")
        }
        .confirmationDialog(
            Text(.notificationsManageDiscardChangesTitle),
            isPresented: $showDiscardChangesConfirmation,
            titleVisibility: .visible
        ) {
            Button(role: .destructive) {
                onAction(.cancel)
            } label: {
                Text(.notificationsManageDiscardChangesButton)
            }
            Button(role: .cancel) {
            } label: {
                Text(.notificationsManageKeepEditing)
            }
        }
    }

    private var saveButton: some View {
        Button {
            saveFeedbackTrigger.toggle()
            onAction(.save(settings))
        } label: {
            Text(.globalSave)
        }
        .disabled(!hasUnsavedChanges || savingState == .loading)
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
