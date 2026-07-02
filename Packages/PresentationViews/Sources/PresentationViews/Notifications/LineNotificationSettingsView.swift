import Models
import SwiftUI

public struct LineNotificationSettingsView: View {

    public enum Mode {
        case onboarding
        case manage
    }

    public enum Action {
        case done(items: [LineNotificationSettings], isEnabled: Bool)
        case cancel
        case openSettings
    }

    private let mode: Mode
    private let savedItems: [LineNotificationSettings]
    private let initialIsEnabled: Bool
    private let showPermissionWarning: Bool
    private let onAction: (Action) -> Void
    private let pendingLineIDs: Set<TrainLineID>

    @State private var items: [LineNotificationSettings]
    @State private var isEnabled: Bool
    @State private var showCancelConfirmation = false
    @State private var scrollTarget: TrainLineID?

    public init(
        mode: Mode,
        savedItems: [LineNotificationSettings],
        pendingItems: [LineNotificationSettings],
        initialIsEnabled: Bool,
        showPermissionWarning: Bool,
        onAction: @escaping (Action) -> Void
    ) {
        self.mode = mode
        self.savedItems = savedItems
        self.initialIsEnabled = initialIsEnabled
        self.showPermissionWarning = showPermissionWarning
        self.onAction = onAction
        self.pendingLineIDs = Set(pendingItems.map(\.lineID))
        let savedIDs = Set(savedItems.map(\.lineID))
        let merged = pendingItems.filter { !savedIDs.contains($0.lineID) } + savedItems
        _items = State(initialValue: merged)
        _isEnabled = State(initialValue: initialIsEnabled)
    }

    public var body: some View {
        ScrollViewReader { proxy in
            List {
                if mode == .manage {
                    if showPermissionWarning {
                        permissionWarningRow
                    } else {
                        muteAllRow
                    }
                }

                if mode == .onboarding || (isEnabled && !showPermissionWarning) {
                    lineItemsSection
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .onChange(of: scrollTarget) { _, id in
                guard let id else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(id, anchor: .bottom)
                }
                scrollTarget = nil
            }
        }
        .safeAreaInset(edge: .bottom) {
            if mode == .onboarding {
                pinnedDoneButton
            } else {
                Color.clear.frame(height: 20)
            }
        }
        .navigationTitle(Text(.notificationsManageNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if mode == .manage {
                ToolbarItem(placement: .cancellationAction) { cancelButton }
                ToolbarItem(placement: .confirmationAction) { doneButton }
            }
        }
        .confirmationDialog(
            Text(.notificationsManageDiscardChangesTitle),
            isPresented: $showCancelConfirmation,
            titleVisibility: .visible
        ) {
            Button(role: .destructive) {
                onAction(.cancel)
            } label: {
                Text(.notificationsManageDiscardChangesButton)
            }
            Button(role: .cancel) {
                showCancelConfirmation = false
            } label: {
                Text(.notificationsManageKeepEditing)
            }
        }
        .interactiveDismissDisabled(mode == .manage && hasUnsavedChanges)
    }

    // MARK: - Computed Properties

    private var hasUnsavedChanges: Bool {
        items != savedItems || isEnabled != initialIsEnabled
    }

    private var unaddedLineIDs: [TrainLineID] {
        let addedIDs = Set(items.map(\.lineID))
        return TrainLineID.allCases
            .filter { !addedIDs.contains($0) }
            .sorted { $0.name < $1.name }
    }

    // MARK: - Toolbar Buttons

    private var cancelButton: some View {
        Button {
            if hasUnsavedChanges {
                showCancelConfirmation = true
            } else {
                onAction(.cancel)
            }
        } label: {
            Image(systemName: "xmark")
        }
    }

    private var doneButton: some View {
        Button {
            onAction(.done(items: items, isEnabled: isEnabled))
        } label: {
            Text(.globalDone)
        }
        .disabled(!hasUnsavedChanges)
    }

    // MARK: - Line Items Section

    @ViewBuilder
    private var lineItemsSection: some View {
        ForEach($items) { $item in
            LineScheduleCard(
                settings: $item,
                showPendingBadge: pendingLineIDs.contains(item.lineID)
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
        }
        .onDelete { indexSet in
            items.remove(atOffsets: indexSet)
        }

        if !unaddedLineIDs.isEmpty {
            addLineRow
        }
    }

    // MARK: - Pinned Done Button (Onboarding)

    private var pinnedDoneButton: some View {
        Button {
            onAction(.done(items: items, isEnabled: true))
        } label: {
            Text(.globalDone)
                .font(.body)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.tint, in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(.white)
        }
        .disabled(items.isEmpty)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .background(.regularMaterial)
    }

    // MARK: - Permission Warning

    private var permissionWarningRow: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 20))
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text(.notificationsManagePermissionWarningTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Text(.notificationsManagePermissionWarningSubtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Button {
                    onAction(.openSettings)
                } label: {
                    Text(.notificationsManageOpenSettingsButton)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                }
                .buttonStyle(.plain)
                .padding(.top, 2)
            }
        }
        .padding(16)
        .cardStyle(borderColor: .orange.opacity(0.35), borderWidth: 1)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
    }

    // MARK: - Mute All

    private var muteAllRow: some View {
        Toggle(isOn: $isEnabled) {
            HStack(spacing: 12) {
                Image(systemName: isEnabled ? "bell.fill" : "bell.slash.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(isEnabled ? Color.accentColor : .orange)
                    .contentTransition(.symbolEffect(.replace))
                Text(.notificationsManagePauseAllTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .tint(Color.accentColor)
        .padding(16)
        .cardStyle()
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
    }

    // MARK: - Add Line

    private var addLineRow: some View {
        Menu {
            ForEach(unaddedLineIDs, id: \.self) { lineID in
                Button(lineID.name) {
                    items.append(.defaultValue(lineID: lineID))
                    scrollTarget = lineID
                }
            }
        } label: {
            Label {
                Text(.notificationsManageAddLineButton)
            } icon: {
                Image(systemName: "plus.circle.fill")
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.tint)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .dashedCardStyle()
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
    }
}


// MARK: - Line Schedule Card

private struct LineScheduleCard: View {
    @Binding var settings: LineNotificationSettings
    let showPendingBadge: Bool

    private var lineID: TrainLineID { settings.lineID }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(lineID.longName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if showPendingBadge {
                    PendingBadge()
                }
            }
            .padding(.bottom, 10)

            Divider()

            scheduleRow
            Divider()
            recoveryAlertsRow
        }
        .padding(16)
        .background(alignment: .leading) {
            lineID.backgroundColor.frame(width: 6)
        }
        .cardStyle()
    }

    private var scheduleRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(.notificationsManageScheduleLabel)
                    .foregroundStyle(.primary)
                if let description = settings.schedulePreset.description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 8)
            Menu {
                Picker(
                    String(localized: .notificationsConfirmationScheduleLabel),
                    selection: $settings.schedulePreset
                ) {
                    ForEach(NotificationSchedulePreset.allDisplayCases, id: \.self) { p in
                        Text(p.title).tag(p)
                    }
                }
                .labelsHidden()
            } label: {
                HStack(spacing: 4) {
                    Text(settings.schedulePreset.title)
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

    private var recoveryAlertsRow: some View {
        Toggle(isOn: $settings.notifyRecoveries) {
            VStack(alignment: .leading, spacing: 4) {
                Text(.notificationsLineRecoveryAlertsLabel)
                    .foregroundStyle(.primary)
                Text(.notificationsOnboardingFeatureRecoveryAlertsDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .opacity(settings.notifyRecoveries ? 1 : 0.4)
            .animation(.easeInOut(duration: 0.2), value: settings.notifyRecoveries)
        }
        .toggleStyle(.checkmark(tint: lineID.backgroundColor))
        .font(.subheadline)
        .padding(.vertical, 10)
    }
}


// MARK: - Pending Badge

private struct PendingBadge: View {
    @State private var triggered = false

    var body: some View {
        Text("New")
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.tint, in: Capsule())
            .foregroundStyle(.white)
            .keyframeAnimator(initialValue: CGFloat(1.0), trigger: triggered) { content, scale in
                content.scaleEffect(scale)
            } keyframes: { _ in
                KeyframeTrack {
                    SpringKeyframe(1.12, duration: 0.3, spring: .bouncy)
                    SpringKeyframe(1.0, duration: 0.3, spring: .bouncy)
                    SpringKeyframe(1.12, duration: 0.3, spring: .bouncy)
                    SpringKeyframe(1.0, duration: 0.3, spring: .bouncy)
                }
            }
            .onAppear { triggered = true }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview("Manage") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .manage,
                savedItems: [.victoria, .jubilee, .central, .northern]
                    .map { .defaultValue(lineID: $0) },
                pendingItems: [],
                initialIsEnabled: true,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Manage - With Pending Line") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .manage,
                savedItems: [.victoria, .jubilee].map { .defaultValue(lineID: $0) },
                pendingItems: [.defaultValue(lineID: .central)],
                initialIsEnabled: true,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Onboarding") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .onboarding,
                savedItems: [.victoria].map { .defaultValue(lineID: $0) },
                pendingItems: [],
                initialIsEnabled: true,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Manage - Paused") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .manage,
                savedItems: [.victoria, .jubilee].map { .defaultValue(lineID: $0) },
                pendingItems: [],
                initialIsEnabled: false,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Manage - Permission Denied") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .manage,
                savedItems: [.victoria, .jubilee].map { .defaultValue(lineID: $0) },
                pendingItems: [],
                initialIsEnabled: true,
                showPermissionWarning: true
            ) { _ in }
        }
    }
#endif
