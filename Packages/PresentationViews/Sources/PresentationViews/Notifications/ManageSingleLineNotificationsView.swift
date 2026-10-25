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
        case resumeAlerts
    }

    private let lineID: TrainLineID
    private let existingSettings: LineNotificationSettings?
    private let showsPermissionWarning: Bool
    private let showsPausedAlertsWarning: Bool
    private let savingState: LoadingState
    private let onAction: (Action) -> Void

    @State private var settings: LineNotificationSettings

    @State private var saveFeedbackTrigger = false
    @State private var removeFeedbackTrigger = false

    public init(
        lineID: TrainLineID,
        existingSettings: LineNotificationSettings?,
        showsPermissionWarning: Bool = false,
        showsPausedAlertsWarning: Bool = false,
        savingState: LoadingState = .loaded,
        onAction: @escaping (Action) -> Void
    ) {
        self.lineID = lineID
        self.existingSettings = existingSettings
        self.showsPermissionWarning = showsPermissionWarning
        self.showsPausedAlertsWarning = showsPausedAlertsWarning
        self.savingState = savingState
        self.onAction = onAction
        _settings = State(initialValue: existingSettings ?? .defaultValue(lineID: lineID))
    }

    // MARK: - Computed Properties

    private var isAddingSingleLine: Bool { existingSettings == nil }

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
            // Both sit on the trailing side, opposite the back button to the list.
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

    #Preview("Alerts paused") {
        NavigationStack {
            ManageSingleLineNotificationsView(
                lineID: .jubilee,
                existingSettings: .defaultValue(lineID: .jubilee, isEnabled: false),
                onAction: { print($0) }
            )
        }
    }

    #Preview("All alerts paused + line paused") {
        NavigationStack {
            ManageSingleLineNotificationsView(
                lineID: .jubilee,
                existingSettings: .defaultValue(lineID: .jubilee, isEnabled: false),
                showsPausedAlertsWarning: true,
                onAction: { print($0) }
            )
        }
    }
#endif
