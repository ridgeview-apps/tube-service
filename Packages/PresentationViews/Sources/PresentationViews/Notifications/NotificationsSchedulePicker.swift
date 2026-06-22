import Models
import SwiftUI

public struct NotificationsSchedulePicker: View {

    @Binding public var selectedPreset: NotificationSchedulePreset

    public init(selectedPreset: Binding<NotificationSchedulePreset>) {
        self._selectedPreset = selectedPreset
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(presets.enumerated()), id: \.element.preset) { index, item in
                scheduleRow(item)
                if index < presets.count - 1 {
                    Divider()
                        .padding(.leading, 44)
                }
            }
        }
    }

    private struct PresetItem {
        let preset: NotificationSchedulePreset
        let title: LocalizedStringResource
        let description: LocalizedStringResource
    }

    private let presets: [PresetItem] = [
        .init(
            preset: .weekdayPeak,
            title: .notificationsScheduleWeekdayPeakTitle,
            description: .notificationsScheduleWeekdayPeakDescription
        ),
        .init(
            preset: .weekdayAllDay,
            title: .notificationsScheduleWeekdayAllDayTitle,
            description: .notificationsScheduleWeekdayAllDayDescription
        ),
        .init(
            preset: .weekends,
            title: .notificationsScheduleWeekendsTitle,
            description: .notificationsScheduleWeekendsDescription
        ),
        .init(
            preset: .anytime,
            title: .notificationsScheduleAnytimeTitle,
            description: .notificationsScheduleAnytimeDescription
        )
    ]

    private func scheduleRow(_ item: PresetItem) -> some View {
        let isSelected = selectedPreset == item.preset
        return Button {
            selectedPreset = item.preset
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.body)
                    Text(item.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        @Previewable @State var preset = NotificationSchedulePreset.weekdayPeak
        NotificationsSchedulePicker(selectedPreset: $preset)
            .cardStyle()
            .padding()
    }
#endif
