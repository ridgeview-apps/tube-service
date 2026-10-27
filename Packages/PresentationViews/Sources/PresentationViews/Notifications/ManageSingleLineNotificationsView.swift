import Models
import SwiftUI

public struct ManageSingleLineNotificationsView: View {

    public enum Action {
        case close
        case openSettings
        /// The pinned "Turn on notifications" button was tapped for a line that has no settings yet.
        case add(LineNotificationSettings)
        /// An existing line's settings were edited; each edit is saved as it's made.
        case update(LineNotificationSettings)
        case remove
        case tappedOtherLine(TrainLineID)
    }

    private let lineID: TrainLineID
    private let existingSettings: LineNotificationSettings?
    private let otherLines: [LineNotificationSettings]
    private let showsPermissionWarning: Bool
    private let savingState: LoadingState
    private let onAction: (Action) -> Void

    @State private var settings: LineNotificationSettings

    /// Collapsed each time the screen opens, so it stays about this line until the user asks for the others.
    @State private var isOtherLinesExpanded = false
    @State private var showRemoveConfirmation = false
    @State private var saveFeedbackTrigger = false
    @State private var removeFeedbackTrigger = false
    @State private var pauseFeedbackTrigger = false

    /// - Parameter otherLines: Other set-up lines to list below an existing line's settings, so they're reachable
    ///   without going back. Leave empty where the screen was opened from the list of all lines.
    public init(
        lineID: TrainLineID,
        existingSettings: LineNotificationSettings?,
        otherLines: [LineNotificationSettings] = [],
        showsPermissionWarning: Bool = false,
        savingState: LoadingState = .loaded,
        onAction: @escaping (Action) -> Void
    ) {
        self.lineID = lineID
        self.existingSettings = existingSettings
        self.otherLines = otherLines.filter { $0.lineID != lineID }
        self.showsPermissionWarning = showsPermissionWarning
        self.savingState = savingState
        self.onAction = onAction
        _settings = State(initialValue: existingSettings ?? .defaultValue(lineID: lineID))
    }

    // MARK: - Computed Properties

    private var isAddingSingleLine: Bool { existingSettings == nil }

    private var showsPausedLineWarning: Bool { !isAddingSingleLine && !settings.isEnabled }

    /// A line being turned on stays focused on that line, so other lines only show once it's set up.
    private var showsOtherLines: Bool { !isAddingSingleLine && !otherLines.isEmpty }

    // MARK: - Body

    public var body: some View {
        List {
            if showsPermissionWarning {
                permissionWarningRow
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 6, trailing: 20))
            }

            if showsPausedLineWarning {
                pausedLineWarningRow
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

            // Set apart below the content, so they read as the end of the screen rather than its main action.
            // A paused line is resumed from the warning at the top, so only Remove is left here.
            if !isAddingSingleLine {
                VStack(spacing: 12) {
                    if settings.isEnabled {
                        pauseButton
                    }
                    removeButton
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 32, leading: 20, bottom: 12, trailing: 20))
            }

            if showsOtherLines {
                otherLinesSection
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 24, leading: 20, bottom: 12, trailing: 20))
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
        .sensoryFeedback(.selection, trigger: pauseFeedbackTrigger)
        .animation(.easeInOut(duration: 0.2), value: settings.isEnabled)
        .toolbar {
            // Nothing is saved for a new line until it's turned on, so closing cancels it;
            // an existing line's edits are already saved, so closing confirms them.
            // Both sit on the trailing side, clear of the back button when the screen is pushed.
            ToolbarItem(placement: .topBarTrailing) {
                closeButton(systemImage: isAddingSingleLine ? "xmark" : "checkmark")
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

    // MARK: - Paused Line Warning

    private var pausedLineWarningRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: 4) {
                    Text(.notificationsLineConfigPausedLineWarningTitle(lineID.longName))
                        .font(.subheadline.weight(.semibold))
                    Text(.notificationsLineConfigPausedLineWarningSubtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            // Saved like any other edit, through the settings change.
            Button {
                pauseFeedbackTrigger.toggle()
                settings.isEnabled = true
            } label: {
                Text(.notificationsLineConfigResumeLineButton)
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
        LineScheduleCard(
            settings: $settings,
            accessory: isAddingSingleLine ? .none : .status
        )
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 28, leading: 20, bottom: 6, trailing: 20))
    }

    // MARK: - Pause and Remove Buttons

    /// Pausing is easily undone from the warning it brings up, so unlike Remove it isn't confirmed.
    private var pauseButton: some View {
        Button {
            pauseFeedbackTrigger.toggle()
            settings.isEnabled = false
        } label: {
            Label {
                Text(.notificationsLineConfigPauseButton(lineID.longName))
            } icon: {
                Image(systemName: "bell.slash.fill")
            }
            .ctaLabelStyle()
        }
        .buttonStyle(.primary)
        .disabled(savingState == .loading)
    }

    private var removeButton: some View {
        Button {
            showRemoveConfirmation = true
        } label: {
            Label {
                Text(.notificationsLineConfigRemoveButton(lineID.longName))
            } icon: {
                Image(systemName: "trash.fill")
            }
            .ctaLabelStyle()
        }
        .buttonStyle(.primary(tint: .red))
        .disabled(savingState == .loading)
        .confirmationDialog(
            String(localized: .notificationsLineConfigRemoveConfirmationTitle(lineID.longName)),
            isPresented: $showRemoveConfirmation,
            titleVisibility: .visible
        ) {
            Button(.globalRemove, role: .destructive) {
                removeFeedbackTrigger.toggle()
                onAction(.remove)
            }
        } message: {
            Text(.notificationsLineConfigRemoveConfirmationMessage)
        }
    }

    // MARK: - Other Lines

    private var otherLinesSection: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    isOtherLinesExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Text(.notificationsOtherLinesSectionTitle)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                    if !isOtherLinesExpanded {
                        Text(otherLines.count, format: .number)
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                            .transition(.opacity)
                    }
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isOtherLinesExpanded ? 90 : 0))
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
                    settings: otherLines,
                    onSelect: { onAction(.tappedOtherLine($0)) }
                )
            }
        }
        .cardStyle()
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
                onAction: { print($0) }
            )
        }
    }

    #Preview("Editing existing") {
        NavigationStack {
            ManageSingleLineNotificationsView(
                lineID: .jubilee,
                existingSettings: .defaultValue(lineID: .jubilee),
                onAction: { print($0) }
            )
        }
    }

    #Preview("Editing with other lines") {
        NavigationStack {
            ManageSingleLineNotificationsView(
                lineID: .jubilee,
                existingSettings: .defaultValue(lineID: .jubilee),
                otherLines: [.victoria, .central, .northern].map { .defaultValue(lineID: $0) },
                onAction: { print($0) }
            )
        }
    }

    #Preview("Line paused") {
        NavigationStack {
            ManageSingleLineNotificationsView(
                lineID: .jubilee,
                existingSettings: .defaultValue(lineID: .jubilee, isEnabled: false),
                onAction: { print($0) }
            )
        }
    }
#endif
