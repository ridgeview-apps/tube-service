import Models
import SwiftUI

public struct LineNotificationConfigView: View {

    public enum Action {
        case save(LineNotificationSettings)
        case remove
        case cancel
    }

    private let existingSettings: LineNotificationSettings?
    private let onAction: (Action) -> Void

    @State private var settings: LineNotificationSettings
    @State private var showRemoveConfirmation = false
    @State private var addConfirmed = false
    @State private var saveFeedbackTrigger = false
    @State private var removeFeedbackTrigger = false

    public init(
        lineID: TrainLineID,
        existingSettings: LineNotificationSettings?,
        onAction: @escaping (Action) -> Void
    ) {
        self.existingSettings = existingSettings
        self.onAction = onAction
        _settings = State(initialValue: existingSettings ?? .defaultValue(lineID: lineID))
    }

    private var lineID: TrainLineID { settings.lineID }

    private var hasUnsavedChanges: Bool {
        guard let existingSettings else { return true }
        return settings != existingSettings
    }

    public var body: some View {
        List {
            scheduleCard
            if existingSettings == nil {
                addButton
            } else {
                removeButton
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle(lineID.longName)
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Remove \(lineID.longName) notifications?",
            isPresented: $showRemoveConfirmation,
            titleVisibility: .visible
        ) {
            Button(String(localized: .globalRemove), role: .destructive) {
                removeFeedbackTrigger.toggle()
                onAction(.remove)
            }
        }
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
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
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
                Text(addConfirmed ? "Notifications on" : "Turn on \(lineID.longName) notifications")
            } icon: {
                Image(systemName: addConfirmed ? "checkmark.circle.fill" : "bell.badge")
                    .contentTransition(.symbolEffect(.replace))
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        }
        .allowsHitTesting(!addConfirmed)
        .foregroundStyle(addConfirmed ? Color.white : Color.accentColor)
        .cardStyle(backgroundColor: addConfirmed ? .green : Color.accentColor.opacity(0.08))
        .animation(.spring(duration: 0.3), value: addConfirmed)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
    }

    private var removeButton: some View {
        Button(role: .destructive) {
            showRemoveConfirmation = true
        } label: {
            Label(String(localized: .notificationsLineConfigRemoveButton), systemImage: "bell.slash")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
        }
        .foregroundStyle(.red)
        .cardStyle(backgroundColor: .red.opacity(0.08))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
    }

    // MARK: - Toolbar Buttons

    private var cancelButton: some View {
        Button {
            onAction(.cancel)
        } label: {
            Image(systemName: "xmark")
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
