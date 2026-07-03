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
    private let initialItems: [LineNotificationSettings]
    private let initialIsEnabled: Bool
    private let showPermissionWarning: Bool
    private let onAction: (Action) -> Void

    @State private var items: [LineNotificationSettings]
    @State private var isEnabled: Bool
    @State private var showCancelConfirmation = false
    @State private var scrollTarget: TrainLineID?

    public init(
        mode: Mode,
        initialItems: [LineNotificationSettings],
        initialIsEnabled: Bool,
        showPermissionWarning: Bool,
        onAction: @escaping (Action) -> Void
    ) {
        self.mode = mode
        self.initialItems = initialItems
        self.initialIsEnabled = initialIsEnabled
        self.showPermissionWarning = showPermissionWarning
        self.onAction = onAction
        _items = State(initialValue: initialItems)
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
                        if !isEnabled {
                            pausedFooterRow
                        }
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
        guard !showPermissionWarning else {
            return false
        }
        let hasChanges = items != initialItems || isEnabled != initialIsEnabled
        return hasChanges
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
            LineScheduleCard(settings: $item)
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

    // MARK: - Paused Footer

    private var pausedFooterRow: some View {
        Text(.notificationsManageAlertsPausedSubtitle)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 2, leading: 20, bottom: 6, trailing: 20))
    }

    // MARK: - Add Line

    private var addLineRow: some View {
        Menu {
            debugAddAllButtons
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

    @ViewBuilder
    private var debugAddAllButtons: some View {
        #if DEBUG
            if unaddedLineIDs.count > 1 {
                Button("Add all lines") {
                    for lineID in unaddedLineIDs {
                        items.append(.defaultValue(lineID: lineID))
                    }
                    scrollTarget = unaddedLineIDs.last
                }
                Button("Add all lines (anytime)") {
                    for lineID in unaddedLineIDs {
                        items.append(.defaultValue(lineID: lineID, schedulePreset: .anytime))
                    }
                    scrollTarget = unaddedLineIDs.last
                }
            }
        #endif
    }
}


// MARK: - Previews

#if DEBUG
    #Preview("Manage") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .manage,
                initialItems: [.victoria, .jubilee, .central, .northern]
                    .map { .defaultValue(lineID: $0) },
                initialIsEnabled: true,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Onboarding") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .onboarding,
                initialItems: [.victoria].map { .defaultValue(lineID: $0) },
                initialIsEnabled: true,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Manage - Paused") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .manage,
                initialItems: [.victoria, .jubilee].map { .defaultValue(lineID: $0) },
                initialIsEnabled: false,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Manage - Permission Denied") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .manage,
                initialItems: [.victoria, .jubilee].map { .defaultValue(lineID: $0) },
                initialIsEnabled: true,
                showPermissionWarning: true
            ) { _ in }
        }
    }
#endif
