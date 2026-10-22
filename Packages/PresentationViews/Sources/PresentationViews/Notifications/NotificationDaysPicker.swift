import Models
import SwiftUI

/// A "Days" row whose menu holds a toggle per weekday, showing a summary of the selected days, e.g. "Mon–Fri".
///
/// The menu stays open so several days can be changed at once. The last selected day is disabled,
/// because the API requires at least one day.
struct NotificationDaysPicker: View {
    @Binding var days: Set<NotificationWeekday>

    var body: some View {
        ScheduleMenuRow(
            title: .notificationsLineScheduleDaysLabel,
            value: NotificationScheduleSelection.daysDescription(for: days)
        ) {
            ForEach(NotificationWeekday.allCases, id: \.self) { day in
                Toggle(day.fullSymbol, isOn: binding(for: day))
                    .disabled(days == [day])
            }
        }
        .menuActionDismissBehavior(.disabled)
    }

    private func binding(for day: NotificationWeekday) -> Binding<Bool> {
        Binding(
            get: { days.contains(day) },
            set: { isOn in
                if isOn {
                    days.insert(day)
                } else {
                    days.remove(day)
                }
            }
        )
    }
}
