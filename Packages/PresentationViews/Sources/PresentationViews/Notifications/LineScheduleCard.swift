import Models
import SwiftUI

public struct LineScheduleCard: View {
    @Binding public var settings: LineNotificationSettings

    public init(settings: Binding<LineNotificationSettings>) {
        _settings = settings
    }

    private var lineID: TrainLineID { settings.lineID }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(lineID.longName)
                .font(.subheadline)
                .fontWeight(.semibold)
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
