import Foundation
import Testing

@testable import Models

struct NotificationScheduleSelectionTests {

    private let weekdays: [NotificationWeekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    private let peakWindows = [window("06:30", "09:30"), window("16:00", "19:00")]

    // MARK: - Reading server schedules

    @Test
    func readingGivesEachListedDayItsSchedule() {
        let selection = NotificationScheduleSelection(schedules: [
            NotificationSchedule(days: [.monday, .wednesday], allDay: false, windows: [window("07:00", "10:00")]),
            .allDay([.saturday])
        ])

        #expect(selection[.monday] == .times([window("07:00", "10:00")]))
        #expect(selection[.wednesday] == .times([window("07:00", "10:00")]))
        #expect(selection[.saturday] == .allDay)
        for day in [NotificationWeekday.tuesday, .thursday, .friday, .sunday] {
            #expect(selection[day] == .off)
        }
    }

    /// Schedules the old two-row card couldn't show used to be replaced by the default, and saved over on the next edit.
    @Test
    func readingThenSavingKeepsSchedulesThatArentPresets() {
        let schedules = [
            NotificationSchedule(days: [.monday, .tuesday], allDay: false, windows: [window("07:00", "10:00")]),
            NotificationSchedule(days: [.wednesday], allDay: false, windows: [window("06:30", "09:30")]),
            .allDay([.saturday, .sunday])
        ]

        #expect(NotificationScheduleSelection(schedules: schedules).schedules == schedules)
    }

    @Test
    func readingIgnoresDayAndWindowOrder() {
        let selection = NotificationScheduleSelection(schedules: [
            NotificationSchedule(days: [.friday, .monday], allDay: false, windows: peakWindows.reversed())
        ])

        #expect(selection == NotificationScheduleSelection(days: [.monday, .friday], schedule: .times(peakWindows)))
    }

    @Test
    func readingIgnoresWindowsSentWithAllDay() {
        let selection = NotificationScheduleSelection(schedules: [
            NotificationSchedule(days: [.sunday], allDay: true, windows: [window("09:00", "17:00")])
        ])

        #expect(selection[.sunday] == .allDay)
    }

    @Test
    func readingADayInSeveralSchedulesCombinesTheirTimes() {
        let selection = NotificationScheduleSelection(schedules: [
            NotificationSchedule(days: [.monday], allDay: false, windows: [window("16:00", "19:00")]),
            NotificationSchedule(days: [.monday], allDay: false, windows: [window("06:30", "09:30")])
        ])

        #expect(selection[.monday] == .times(peakWindows))
    }

    @Test
    func readingADayInSeveralSchedulesIsAllDayIfAnyIs() {
        let selection = NotificationScheduleSelection(schedules: [
            NotificationSchedule(days: [.monday, .tuesday], allDay: false, windows: [window("07:00", "10:00")]),
            .allDay([.monday]),
            NotificationSchedule(days: [.monday], allDay: false, windows: [window("16:00", "19:00")])
        ])

        #expect(selection[.monday] == .allDay)
        #expect(selection[.tuesday] == .times([window("07:00", "10:00")]))
    }

    @Test
    func readingMergesOverlappingWindows() {
        let selection = NotificationScheduleSelection(schedules: [
            NotificationSchedule(
                days: [.monday],
                allDay: false,
                windows: [window("07:00", "09:00"), window("08:00", "10:00")]
            )
        ])

        #expect(selection[.monday] == .times([window("07:00", "10:00")]))
    }

    @Test
    func readingNoSchedulesLeavesEveryDayOff() {
        let selection = NotificationScheduleSelection(schedules: [
            .allDay([]),
            NotificationSchedule(days: [.monday], allDay: false, windows: [])
        ])

        #expect(selection == NotificationScheduleSelection([:]))
        #expect(!selection.hasAnyDayOn)
    }

    // MARK: - Saving

    @Test
    func weekdayPeakHoursSavesOneSchedule() {
        let selection = NotificationScheduleSelection(days: weekdays, schedule: .times(peakWindows))

        #expect(selection.schedules == [NotificationSchedule(days: weekdays, allDay: false, windows: peakWindows)])
    }

    @Test
    func savingGroupsIdenticalDaysInWeekOrder() {
        let selection = NotificationScheduleSelection([
            .sunday: .times([window("10:00", "12:00")]),
            .wednesday: .times(peakWindows),
            .tuesday: .allDay,
            .monday: .times(peakWindows),
            .saturday: .allDay
        ])

        #expect(
            selection.schedules == [
                NotificationSchedule(days: [.monday, .wednesday], allDay: false, windows: peakWindows),
                .allDay([.tuesday, .saturday]),
                NotificationSchedule(days: [.sunday], allDay: false, windows: [window("10:00", "12:00")])
            ]
        )
    }

    @Test
    func savingLeavesOutDaysThatAreOff() {
        let selection = NotificationScheduleSelection([.thursday: .allDay, .friday: .off])

        #expect(selection.schedules == [.allDay([.thursday])])
    }

    @Test
    func dayGroupsGroupIdenticalDaysInWeekOrder() {
        let selection = NotificationScheduleSelection([
            .sunday: .allDay,
            .tuesday: .times(peakWindows),
            .monday: .allDay,
            .wednesday: .off
        ])

        #expect(selection.dayGroups.map(\.schedule) == [.allDay, .times(peakWindows)])
        #expect(selection.dayGroups.map(\.days) == [[.monday, .sunday], [.tuesday]])
    }

    // MARK: - Presets

    @Test
    func defaultIsWeekdayPeakHours() {
        #expect(
            NotificationScheduleSelection.default.schedules == [
                NotificationSchedule(days: weekdays, allDay: false, windows: peakWindows)
            ]
        )
    }

    @Test
    func presetsMatchTheirSchedulesHoweverTheyWereBuilt() {
        var everyDayPeakHours = NotificationScheduleSelection([:])
        for day in NotificationWeekday.allCases {
            everyDayPeakHours[day] = .times(peakWindows.reversed())
        }
        let weekdaysAllDay = NotificationScheduleSelection(schedules: [.allDay([.friday, .monday, .wednesday]), .allDay([.tuesday, .thursday])])

        #expect(
            NotificationSchedulePreset(matching: NotificationScheduleSelection(days: weekdays, schedule: .times(peakWindows)))
                == .weekdayPeakHours
        )
        #expect(NotificationSchedulePreset(matching: weekdaysAllDay) == .weekdaysAllDay)
        #expect(NotificationSchedulePreset(matching: everyDayPeakHours) == .everyDayPeakHours)
        #expect(
            NotificationSchedulePreset(matching: NotificationScheduleSelection(days: NotificationWeekday.allCases, schedule: .allDay))
                == .everyDayAllDay
        )
    }

    @Test
    func scheduleCloseToAPresetMatchesNone() {
        var weekdayPeakHoursPlusSaturday = NotificationScheduleSelection(days: weekdays, schedule: .times(peakWindows))
        weekdayPeakHoursPlusSaturday[.saturday] = .times(peakWindows)
        var weekdaysAllDayButFridayPeak = NotificationScheduleSelection(days: weekdays, schedule: .allDay)
        weekdaysAllDayButFridayPeak[.friday] = .times(peakWindows)

        #expect(NotificationSchedulePreset(matching: weekdayPeakHoursPlusSaturday) == nil)
        #expect(NotificationSchedulePreset(matching: weekdaysAllDayButFridayPeak) == nil)
    }

    // MARK: - Merging windows

    @Test
    func overlappingWindowsAreMerged() {
        var selection = NotificationScheduleSelection([:])
        selection[.monday] = .times([window("08:00", "10:00"), window("07:00", "09:00")])

        #expect(selection[.monday] == .times([window("07:00", "10:00")]))
    }

    @Test
    func windowInsideAnotherIsMerged() {
        var selection = NotificationScheduleSelection([:])
        selection[.monday] = .times([window("07:00", "12:00"), window("08:00", "09:00")])

        #expect(selection[.monday] == .times([window("07:00", "12:00")]))
    }

    @Test
    func duplicateWindowsAreMerged() {
        var selection = NotificationScheduleSelection([:])
        selection[.monday] = .times([window("07:00", "09:00"), window("07:00", "09:00")])

        #expect(selection[.monday] == .times([window("07:00", "09:00")]))
    }

    @Test
    func adjacentWindowsAreMerged() {
        var selection = NotificationScheduleSelection([:])
        selection[.monday] = .times([window("09:00", "10:00"), window("07:00", "09:00")])

        #expect(selection[.monday] == .times([window("07:00", "10:00")]))
    }

    @Test
    func windowsThatDontTouchAreKeptInTimeOrder() {
        var selection = NotificationScheduleSelection([:])
        selection[.monday] = .times([window("16:00", "19:00"), window("06:30", "09:30")])

        #expect(selection[.monday] == .times(peakWindows))
    }

    /// The API rejects windows that don't end after they start.
    @Test
    func emptyAndBackwardsWindowsAreDropped() {
        var selection = NotificationScheduleSelection([:])
        selection[.monday] = .times([window("09:00", "09:00"), window("07:00", "10:00"), window("22:00", "06:00")])
        selection[.tuesday] = .times([window("09:00", "09:00")])

        #expect(selection[.monday] == .times([window("07:00", "10:00")]))
        #expect(selection[.tuesday] == .off)
    }

    @Test
    func dayWithNoTimesIsOff() {
        var selection = NotificationScheduleSelection([.monday: .allDay])
        selection[.monday] = .times([])

        #expect(selection[.monday] == .off)
        #expect(!selection.hasAnyDayOn)
    }
}

// MARK: - Private helpers

/// A window from `HH:mm` strings, e.g. `window("06:30", "09:30")`.
private func window(_ start: String, _ end: String) -> NotificationScheduleWindow {
    NotificationScheduleWindow(startTime: time(start), endTime: time(end))
}

private func time(_ string: String) -> NotificationTimeOfDay {
    let components = string.split(separator: ":").compactMap { Int($0) }
    return NotificationTimeOfDay(hour: components[0], minute: components[1])
}
