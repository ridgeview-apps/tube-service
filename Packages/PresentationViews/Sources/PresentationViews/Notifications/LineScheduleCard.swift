import Models
import SwiftUI

public struct LineScheduleCard: View {

    /// What the header shows alongside the line name.
    public enum Accessory {
        case none
        /// The line's on or paused status under its name. Pausing and resuming are left to the screen's own buttons.
        case status
        case removeButton(onRemove: () -> Void)
    }

    @Binding public var settings: LineNotificationSettings
    private let accessory: Accessory

    private let barWidth: CGFloat = 8

    public init(settings: Binding<LineNotificationSettings>, accessory: Accessory = .none) {
        _settings = settings
        self.accessory = accessory
    }

    private var lineID: TrainLineID { settings.lineID }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.bottom, 10)

            Divider()

            // The rows' own 44pt height provides the spacing between them and below the divider.
            VStack(alignment: .leading, spacing: 0) {
                NotificationDaysPicker(days: $settings.schedule.days)
                timeSlotPicker
            }
            // Faded while paused but still editable, so the schedule can be set before resuming.
            .opacity(settings.isEnabled ? 1 : 0.5)
        }
        .padding(16)
        // Content keeps its full 16pt inset from the bar's inner edge, not from the card's edge.
        .padding(.leading, barWidth)
        // The side bar is the card's only use of the line colour; controls use the accent colour.
        .background(alignment: .leading) {
            lineID.backgroundColor.frame(width: barWidth)
        }
        .cardStyle()
        .animation(.easeInOut(duration: 0.2), value: settings.isEnabled)
    }

    // MARK: - Header

    @ViewBuilder
    private var header: some View {
        switch accessory {
        case .none, .status:
            headerLabel
        case .removeButton(let onRemove):
            HStack(spacing: 8) {
                headerLabel
                    .frame(maxWidth: .infinity, alignment: .leading)
                removeButton(onRemove: onRemove)
            }
        }
    }

    private var headerLabel: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(lineID.longName)
                .font(.subheadline)
                .fontWeight(.semibold)
            if showsStatus {
                HStack(spacing: 4) {
                    Image(systemName: settings.isEnabled ? "bell.and.waves.left.and.right.fill" : "bell.slash.fill")
                        .contentTransition(.symbolEffect(.replace))
                    Text(settings.isEnabled ? .notificationsLineConfigStatusOn : .globalPaused)
                }
                .font(.footnote)
                // As on the line status button: the accent colour marks notifications as on, orange flags a pause.
                .foregroundStyle(settings.isEnabled ? Color.accentColor : .orange)
                .accessibilityElement(children: .combine)
            }
        }
    }

    /// Only existing lines, which can be paused, show whether they're on or paused.
    private var showsStatus: Bool {
        if case .status = accessory { return true }
        return false
    }

    private func removeButton(onRemove: @escaping () -> Void) -> some View {
        Button(role: .destructive, action: onRemove) {
            Label {
                Text(.notificationsLineConfigRemoveButton(lineID.longName))
            } icon: {
                Image(systemName: "trash")
            }
            .labelStyle(.iconOnly)
            // Trailing-aligned so the icon lines up with the schedule chevrons; the tap area extends leftwards.
            .frame(minWidth: 44, minHeight: 44, alignment: .trailing)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .tint(.adaptiveRed)
        // Keeps the header row the same height as the other variants despite the 44pt tap target.
        .padding(.vertical, -10)
    }

    // MARK: - Schedule

    /// The time slot row, with the slot's times (if any) under the value.
    private var timeSlotPicker: some View {
        let timeSlot = settings.schedule.timeSlot

        return ScheduleMenuRow(
            title: .notificationsLineScheduleTimeLabel,
            value: String(localized: timeSlot.title),
            detail: timeSlot.timesDescription
        ) {
            // Toggles rather than a Picker: menus document title-and-subtitle labels for toggles, not picker options.
            ForEach(NotificationTimeSlot.allCases, id: \.self) { option in
                Toggle(isOn: selectionBinding(for: option)) {
                    Text(option.title)
                    if let times = option.timesDescription {
                        Text(times)
                    }
                }
            }
        }
    }

    /// On when `option` is selected; turning it on selects it. Turning the selected option off does nothing,
    /// so exactly one time slot is always selected, as with a picker.
    private func selectionBinding(for option: NotificationTimeSlot) -> Binding<Bool> {
        Binding(
            get: { settings.schedule.timeSlot == option },
            set: { isOn in
                if isOn { settings.schedule.timeSlot = option }
            }
        )
    }
}

// MARK: - Previews

#if DEBUG
    #Preview("Onboarding (remove)") {
        LineScheduleCard(
            settings: .constant(.defaultValue(lineID: .jubilee)),
            accessory: .removeButton(onRemove: {})
        )
        .padding(20)
    }

    #Preview("Existing line (status)") {
        @Previewable @State var settings = LineNotificationSettings.defaultValue(lineID: .victoria)
        LineScheduleCard(settings: $settings, accessory: .status)
            .padding(20)
    }

    #Preview("Paused, all day") {
        @Previewable @State var settings = LineNotificationSettings.defaultValue(
            lineID: .circle,
            isEnabled: false,
            schedule: .init(days: Set(NotificationWeekday.weekend), timeSlot: .allDay)
        )
        LineScheduleCard(settings: $settings, accessory: .status)
            .padding(20)
    }

    #Preview("New line, dark mode") {
        LineScheduleCard(settings: .constant(.defaultValue(lineID: .northern)))
            .padding(20)
            .preferredColorScheme(.dark)
    }

    #Preview("Accessibility size") {
        @Previewable @State var settings = LineNotificationSettings.defaultValue(lineID: .hammersmithAndCity)
        ScrollView {
            LineScheduleCard(settings: $settings, accessory: .status)
                .padding(20)
        }
        .dynamicTypeSize(.accessibility3)
    }
#endif
