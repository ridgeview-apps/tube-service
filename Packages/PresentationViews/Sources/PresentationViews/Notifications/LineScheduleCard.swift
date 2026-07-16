import Models
import SwiftUI

public struct LineScheduleCard: View {
    @Binding public var settings: LineNotificationSettings
    private let onRemove: (() -> Void)?

    @State private var showRemoveConfirmation = false

    public init(settings: Binding<LineNotificationSettings>, onRemove: (() -> Void)? = nil) {
        _settings = settings
        self.onRemove = onRemove
    }

    private var lineID: TrainLineID { settings.lineID }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            lineNameRow

            Divider()

            scheduleRow
            Divider()
            recoveryAlertsRow
        }
        .padding(16)
        .background(alignment: .leading) {
            lineID.backgroundColor.frame(width: 8)
        }
        .cardStyle()
        .overlay(alignment: .topTrailing) {
            removeButton
                .dynamicTypeSize(..<DynamicTypeSize.accessibility1)
                .offset(x: 10, y: -10)
        }
    }

    private var lineNameRow: some View {
        Text(lineID.longName)
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.bottom, 10)
    }

    @ViewBuilder
    private var removeButton: some View {
        if onRemove != nil {
            Button {
                showRemoveConfirmation = true
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .confirmationDialog(
                String(localized: .notificationsLineScheduleRemoveTitle(lineID.longName)),
                isPresented: $showRemoveConfirmation,
                titleVisibility: .visible
            ) {
                Button(.globalRemove, role: .destructive) {
                    onRemove?()
                }
            }
        }
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
            Text(.notificationsLineRecoveryAlertsLabel)
                .foregroundStyle(.primary)
        }
        .toggleStyle(.switch)
        .tint(lineID.backgroundColor)
        .font(.subheadline)
        .padding(.vertical, 10)
    }
}

// MARK: - Previews

#if DEBUG
    #Preview("Read-only") {
        LineScheduleCard(settings: .constant(.defaultValue(lineID: .victoria)))
            .padding(20)
    }

    #Preview("With remove button") {
        LineScheduleCard(
            settings: .constant(.defaultValue(lineID: .jubilee)),
            onRemove: {}
        )
        .padding(20)
    }
#endif
