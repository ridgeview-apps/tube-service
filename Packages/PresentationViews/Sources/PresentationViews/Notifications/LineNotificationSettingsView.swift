import Models
import SwiftUI

public struct LineNotificationSettingsView: View {

    public enum Mode {
        case singleLine(lineID: TrainLineID, existingSettings: LineNotificationSettings?, showsOtherLines: Bool)
        case manageAll(isEnabled: Bool)
    }

    public enum Action {
        case save(LineNotificationSettings)
        case remove
        case cancel
        case navigateTo(TrainLineID)
        case toggleEnabled(Bool)
    }

    private let mode: Mode
    private let allSettings: [LineNotificationSettings]
    private let onAction: (Action) -> Void

    @State private var settings: LineNotificationSettings
    @State private var isEnabled: Bool
    @State private var showRemoveConfirmation = false
    @State private var showDiscardChangesConfirmation = false
    @State private var isOtherLinesExpanded = false
    @State private var addConfirmed = false
    @State private var saveFeedbackTrigger = false
    @State private var removeFeedbackTrigger = false

    public init(
        mode: Mode,
        allSettings: [LineNotificationSettings] = [],
        onAction: @escaping (Action) -> Void
    ) {
        self.mode = mode
        self.allSettings = allSettings
        self.onAction = onAction
        switch mode {
        case .singleLine(let lineID, let existingSettings, _):
            _settings = State(initialValue: existingSettings ?? .defaultValue(lineID: lineID))
            _isEnabled = State(initialValue: true)
        case .manageAll(let initialIsEnabled):
            _settings = State(initialValue: .defaultValue(lineID: .central))
            _isEnabled = State(initialValue: initialIsEnabled)
        }
    }

    // MARK: - Computed Properties

    private var lineID: TrainLineID { settings.lineID }

    private var existingSettings: LineNotificationSettings? {
        guard case .singleLine(_, let s, _) = mode else { return nil }
        return s
    }

    private var configuredLines: [LineNotificationSettings] {
        switch mode {
        case .singleLine(let lineID, _, _):
            return allSettings.filter { $0.lineID != lineID }.sorted { $0.lineID.name < $1.lineID.name }
        case .manageAll:
            return allSettings.sorted { $0.lineID.name < $1.lineID.name }
        }
    }

    private var unconfiguredLineIDs: [TrainLineID] {
        let configuredIDs = Set(allSettings.map(\.lineID))
        switch mode {
        case .singleLine(let lineID, _, _):
            return TrainLineID.allCases
                .filter { $0 != lineID && !configuredIDs.contains($0) }
                .sorted { $0.name < $1.name }
        case .manageAll:
            return TrainLineID.allCases
                .filter { !configuredIDs.contains($0) }
                .sorted { $0.name < $1.name }
        }
    }

    private var hasUnsavedChanges: Bool {
        guard let existingSettings else { return true }
        return settings != existingSettings
    }

    private var hasChangesToDiscard: Bool {
        if let existingSettings {
            return settings != existingSettings
        } else {
            return settings != .defaultValue(lineID: lineID)
        }
    }

    // MARK: - Body

    public var body: some View {
        List {
            switch mode {
            case .singleLine:
                singleLineContent
            case .manageAll:
                manageAllContent
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.success, trigger: addConfirmed)
        .sensoryFeedback(.success, trigger: saveFeedbackTrigger)
        .sensoryFeedback(.warning, trigger: removeFeedbackTrigger)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { cancelButton }
            if existingSettings != nil {
                ToolbarItem(placement: .confirmationAction) { saveButton }
            }
        }
    }

    private var navigationTitle: String {
        switch mode {
        case .singleLine(let lineID, _, _):
            return String(localized: .notificationsLineConfigNavTitle(lineID.longName))
        case .manageAll:
            return String(localized: .notificationsLineAlertsNavigationTitle)
        }
    }

    // MARK: - Single Line Content

    @ViewBuilder
    private var singleLineContent: some View {
        Group {
            scheduleCard
            Group {
                if existingSettings == nil {
                    addButton
                } else {
                    removeButton
                }
            }
            .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)

        if case .singleLine(_, _, let showsOtherLines) = mode, showsOtherLines {
            otherLinesSummarySection
                .disabled(addConfirmed)
        }
    }

    // MARK: - Manage All Content

    @ViewBuilder
    private var manageAllContent: some View {
        muteAllRow
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 6, trailing: 20))

        if !configuredLines.isEmpty || !unconfiguredLineIDs.isEmpty {
            allLinesCard
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 12, trailing: 20))
        }
    }

    // MARK: - Mute All Row

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
        .onChange(of: isEnabled) { _, newValue in
            onAction(.toggleEnabled(newValue))
        }
    }

    // MARK: - All Lines Card

    private var allLinesCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(configuredLines.enumerated()), id: \.element.lineID) { index, lineSettings in
                if index > 0 {
                    Divider()
                        .padding(.leading, 40)
                }
                Button {
                    onAction(.navigateTo(lineSettings.lineID))
                } label: {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(lineSettings.lineID.backgroundColor)
                            .frame(width: 12, height: 12)
                        Text(lineSettings.lineID.name)
                            .foregroundStyle(.primary)
                        Spacer()
                        Text(lineSettings.schedulePreset.title)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                            .font(.caption.weight(.semibold))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            if !unconfiguredLineIDs.isEmpty {
                if !configuredLines.isEmpty {
                    Divider()
                        .padding(.leading, 40)
                }
                addLineMenu
            }
        }
        .cardStyle()
    }

    // MARK: - Schedule Card

    private var scheduleCard: some View {
        LineScheduleCard(settings: $settings)
            .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 6, trailing: 20))
    }

    // MARK: - Add / Remove Buttons

    private var addButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                addConfirmed = true
            }
            Task {
                try? await Task.sleep(for: .milliseconds(1200))
                onAction(.save(settings))
            }
        } label: {
            Label {
                Text(
                    addConfirmed
                        ? .notificationsLineConfigAddConfirmed(lineID.longName)
                        : .notificationsLineConfigAddButton(lineID.longName)
                )
                .contentTransition(.opacity)
            } icon: {
                Image(systemName: addConfirmed ? "checkmark.circle.fill" : "bell.badge")
                    .contentTransition(.symbolEffect(.replace))
            }
            .ctaLabelStyle(weight: .regular)
        }
        .allowsHitTesting(!addConfirmed)
        .foregroundStyle(lineID.textColor)
        .cardStyle(backgroundColor: lineID.backgroundColor)
        .animation(.spring(duration: 0.3), value: addConfirmed)
    }

    private var removeButton: some View {
        Button(role: .destructive) {
            showRemoveConfirmation = true
        } label: {
            Label {
                Text(String(localized: .notificationsLineConfigRemoveButton(lineID.longName)))
                    .foregroundStyle(.primary)
            } icon: {
                Image(systemName: "bell.slash")
                    .foregroundStyle(.red)
            }
            .ctaLabelStyle()
        }
        .cardStyle()
        .confirmationDialog(
            Text(.notificationsLineConfigRemoveConfirmation),
            isPresented: $showRemoveConfirmation,
            titleVisibility: .visible
        ) {
            Button(String(localized: .notificationsLineConfigStopAlertsButton), role: .destructive) {
                removeFeedbackTrigger.toggle()
                onAction(.remove)
            }
        }
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
                ForEach(Array(configuredLines.enumerated()), id: \.element.lineID) { index, lineSettings in
                    Divider()
                        .padding(.leading, 40)
                    Button {
                        onAction(.navigateTo(lineSettings.lineID))
                    } label: {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(lineSettings.lineID.backgroundColor)
                                .frame(width: 12, height: 12)
                            Text(lineSettings.lineID.name)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(lineSettings.schedulePreset.title)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.tertiary)
                                .font(.caption.weight(.semibold))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                if !unconfiguredLineIDs.isEmpty {
                    Divider()
                        .padding(.leading, 40)
                    addLineMenu
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Add Line Menu

    private var addLineMenu: some View {
        AddLineMenu(
            lineIDs: unconfiguredLineIDs,
            label: addLineMenuLabel,
            onSelect: { onAction(.navigateTo($0)) }
        )
    }

    private var addLineMenuLabel: LocalizedStringResource {
        switch mode {
        case .singleLine: return .notificationsLineConfigAddAnotherLine
        case .manageAll: return .notificationsManageAddLineButton
        }
    }

    // MARK: - Toolbar Buttons

    private var cancelButton: some View {
        Button {
            if case .singleLine = mode, hasChangesToDiscard {
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
        .disabled(!hasUnsavedChanges)
    }
}


// MARK: - Style helpers

fileprivate extension View {
    func ctaLabelStyle(weight: Font.Weight = .regular) -> some View {
        self
            .font(.subheadline.weight(weight))
            .frame(maxWidth: .infinity)
            .padding(16)
    }
}

// MARK: - Previews

#if DEBUG
    import ModelStubs

    #Preview("New line") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .singleLine(lineID: .central, existingSettings: nil, showsOtherLines: true),
                onAction: { print($0) }
            )
        }
    }

    #Preview("Editing existing") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .singleLine(lineID: .jubilee, existingSettings: .defaultValue(lineID: .jubilee), showsOtherLines: true),
                onAction: { print($0) }
            )
        }
    }

    #Preview("Manage all") {
        NavigationStack {
            LineNotificationSettingsView(
                mode: .manageAll(isEnabled: true),
                allSettings: [.victoria, .jubilee, .central, .northern].map { .defaultValue(lineID: $0) },
                onAction: { print($0) }
            )
        }
    }
#endif
