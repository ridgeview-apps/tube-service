import Models
import SwiftUI

public struct LineNotificationConfigView: View {

    public enum Action {
        case save(LineNotificationSettings)
        case remove
        case cancel
        case navigateTo(TrainLineID)
    }

    private let existingSettings: LineNotificationSettings?
    private let allSettings: [LineNotificationSettings]
    private let showsOtherLines: Bool
    private let onAction: (Action) -> Void

    @State private var settings: LineNotificationSettings
    @State private var showRemoveConfirmation = false
    @State private var showDiscardChangesConfirmation = false
    @State private var isOtherLinesExpanded = false
    @State private var addConfirmed = false
    @State private var saveFeedbackTrigger = false
    @State private var removeFeedbackTrigger = false

    public init(
        lineID: TrainLineID,
        existingSettings: LineNotificationSettings?,
        allSettings: [LineNotificationSettings] = [],
        showsOtherLines: Bool = true,
        onAction: @escaping (Action) -> Void
    ) {
        self.existingSettings = existingSettings
        self.allSettings = allSettings
        self.showsOtherLines = showsOtherLines
        self.onAction = onAction
        _settings = State(initialValue: existingSettings ?? .defaultValue(lineID: lineID))
    }

    private var lineID: TrainLineID { settings.lineID }

    private var configuredOtherLines: [LineNotificationSettings] {
        allSettings.filter { $0.lineID != lineID }.sorted { $0.lineID.name < $1.lineID.name }
    }

    private var unconfiguredOtherLineIDs: [TrainLineID] {
        let configuredIDs = Set(allSettings.map(\.lineID))
        return TrainLineID.allCases
            .filter { $0 != lineID && !configuredIDs.contains($0) }
            .sorted { $0.name < $1.name }
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

    public var body: some View {
        List {
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

            if showsOtherLines {
                otherLinesSummarySection
                    .disabled(addConfirmed)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle(String(localized: .notificationsLineConfigNavTitle(lineID.longName)))
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
        if !configuredOtherLines.isEmpty {
            otherLinesCard
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 24, leading: 20, bottom: 12, trailing: 20))
        } else if !unconfiguredOtherLineIDs.isEmpty {
            addAnotherLineMenu
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
                        Text("\(configuredOtherLines.count)")
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
                ForEach(Array(configuredOtherLines.enumerated()), id: \.element.lineID) { index, lineSettings in
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
                if !unconfiguredOtherLineIDs.isEmpty {
                    Divider()
                        .padding(.leading, 40)
                    addAnotherLineMenu
                }
            }
        }
        .cardStyle()
    }

    private var addAnotherLineMenu: some View {
        AddLineMenu(
            lineIDs: unconfiguredOtherLineIDs,
            label: .notificationsLineConfigAddAnotherLine,
            onSelect: { onAction(.navigateTo($0)) }
        )
    }

    // MARK: - Toolbar Buttons

    private var cancelButton: some View {
        Button {
            if hasChangesToDiscard {
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
            LineNotificationConfigView(
                lineID: .central,
                existingSettings: nil,
                onAction: { print($0) }
            )
        }
    }

    #Preview("Editing existing") {
        NavigationStack {
            LineNotificationConfigView(
                lineID: .jubilee,
                existingSettings: .defaultValue(lineID: .jubilee),
                onAction: { print($0) }
            )
        }
    }
#endif
