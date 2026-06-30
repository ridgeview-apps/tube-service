import Models
import SwiftUI

public struct NotificationSettingsView: View {

    public enum Mode {
        case onboarding
        case manage
    }

    public enum Action {
        case done(items: [LineNotificationSettings], isMuted: Bool)
        case cancel
        case openSettings
    }

    private let mode: Mode
    private let initialItems: [LineNotificationSettings]
    private let initialIsMuted: Bool
    private let showPermissionWarning: Bool
    private let onAction: (Action) -> Void

    @State private var items: [LineNotificationSettings]
    @State private var isMuted: Bool
    @State private var showCancelConfirmation = false
    @State private var scrollTarget: TrainLineID?

    public init(
        mode: Mode,
        initialItems: [LineNotificationSettings],
        initialIsMuted: Bool,
        showPermissionWarning: Bool,
        onAction: @escaping (Action) -> Void
    ) {
        self.mode = mode
        self.initialItems = initialItems
        self.initialIsMuted = initialIsMuted
        self.showPermissionWarning = showPermissionWarning
        self.onAction = onAction
        _items = State(initialValue: initialItems)
        _isMuted = State(initialValue: initialIsMuted)
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

                if mode == .onboarding || (!isMuted && !showPermissionWarning) {
                    ForEach(items) { item in
                        lineScheduleCard(for: item.lineID)
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
                ToolbarItem(placement: .cancellationAction) {
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
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onAction(.done(items: items, isMuted: isMuted))
                    } label: {
                        Text(.globalDone)
                    }
                    .disabled(!hasUnsavedChanges)
                }
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
        items != initialItems || isMuted != initialIsMuted
    }

    private var unaddedLineIDs: [TrainLineID] {
        let addedIDs = Set(items.map(\.lineID))
        return TrainLineID.allCases
            .filter { !addedIDs.contains($0) }
            .sorted { $0.name < $1.name }
    }

    // MARK: - Pinned Done Button (Onboarding)

    private var pinnedDoneButton: some View {
        Button {
            onAction(.done(items: items, isMuted: false))
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
        Toggle(isOn: Binding(get: { !isMuted }, set: { isMuted = !$0 })) {
            HStack(spacing: 12) {
                Image(systemName: isMuted ? "bell.slash.fill" : "bell.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(isMuted ? .orange : Color.accentColor)
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

    // MARK: - Schedule Cards

    @ViewBuilder
    private func lineScheduleCard(for lineID: TrainLineID) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(lineID.longName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.bottom, 10)

            Divider()

            scheduleRow(for: lineID)
            Divider()
            recoveryAlertsRow(for: lineID)
        }
        .padding(16)
        .background(alignment: .leading) {
            lineID.backgroundColor.frame(width: 6)
        }
        .cardStyle()
    }

    @ViewBuilder
    private func scheduleRow(for lineID: TrainLineID) -> some View {
        let item = currentItem(for: lineID)
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(.notificationsManageScheduleLabel)
                    .foregroundStyle(.primary)
                if let description = item.schedulePreset.description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 8)
            Menu {
                Picker(
                    L10n.notificationsConfirmationScheduleLabel,
                    selection: itemBinding(for: lineID).schedulePreset
                ) {
                    ForEach(NotificationSchedulePreset.allDisplayCases, id: \.self) { p in
                        Text(p.title).tag(p)
                    }
                }
                .labelsHidden()
            } label: {
                HStack(spacing: 4) {
                    Text(item.schedulePreset.title)
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
        Toggle(isOn: itemBinding(for: lineID).notifyRecoveries) {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.notificationsLineRecoveryAlertsLabel)
                    .foregroundStyle(.primary)
                Text(L10n.notificationsOnboardingFeatureRecoveryAlertsDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .toggleStyle(.checkmark(tint: lineID.backgroundColor))
        .font(.subheadline)
        .padding(.vertical, 10)
    }

    // MARK: - Helpers

    private func currentItem(for lineID: TrainLineID) -> LineNotificationSettings {
        items.first(where: { $0.lineID == lineID }) ?? .defaultValue(lineID: lineID)
    }

    private func itemBinding(for lineID: TrainLineID) -> Binding<LineNotificationSettings> {
        Binding(
            get: { currentItem(for: lineID) },
            set: { newValue in
                if let index = items.firstIndex(where: { $0.lineID == lineID }) {
                    items[index] = newValue
                }
            }
        )
    }
}


// MARK: - Previews

#if DEBUG
    #Preview("Manage") {
        NavigationStack {
            NotificationSettingsView(
                mode: .manage,
                initialItems: [.victoria, .jubilee, .central, .northern]
                    .map { .defaultValue(lineID: $0) },
                initialIsMuted: false,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Onboarding") {
        NavigationStack {
            NotificationSettingsView(
                mode: .onboarding,
                initialItems: [.victoria].map { .defaultValue(lineID: $0) },
                initialIsMuted: false,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Manage - Paused") {
        NavigationStack {
            NotificationSettingsView(
                mode: .manage,
                initialItems: [.victoria, .jubilee].map { .defaultValue(lineID: $0) },
                initialIsMuted: true,
                showPermissionWarning: false
            ) { _ in }
        }
    }

    #Preview("Manage - Permission Denied") {
        NavigationStack {
            NotificationSettingsView(
                mode: .manage,
                initialItems: [.victoria, .jubilee].map { .defaultValue(lineID: $0) },
                initialIsMuted: false,
                showPermissionWarning: true
            ) { _ in }
        }
    }
#endif
