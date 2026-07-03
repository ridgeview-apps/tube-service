import Models
import SwiftUI

public struct LineNotificationConfigView: View {

    public enum Action {
        case save(LineNotificationSettings)
        case remove
        case cancel
    }

    @Environment(\.colorScheme) private var colorScheme

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
            } icon: {
                Image(systemName: addConfirmed ? "checkmark.circle.fill" : "bell.badge")
                    .contentTransition(.symbolEffect(.replace))
            }
            .ctaLabelStyle(weight: .medium)
        }
        .allowsHitTesting(!addConfirmed)
        .foregroundStyle(addConfirmed ? Color.white : Color.accentColor)
        .cardStyle(backgroundColor: addConfirmed ? .green : Color.accentColor.opacity(colorScheme == .dark ? 0.15 : 0.08))
        .animation(.spring(duration: 0.3), value: addConfirmed)
    }

    private var removeButton: some View {
        Button(role: .destructive) {
            showRemoveConfirmation = true
        } label: {
            Label(String(localized: .notificationsLineConfigRemoveButton(lineID.longName)), systemImage: "bell.slash")
                .ctaLabelStyle()
        }
        .foregroundStyle(.red)
        .cardStyle(backgroundColor: .red.opacity(colorScheme == .dark ? 0.15 : 0.08))
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
