import Foundation
import Testing

@testable import Models

struct NotificationScheduleTests {

    // MARK: - Decoding

    @Test
    func decodedLinePreferenceSchedules() throws {
        let json = """
            {
                "line_id": "victoria",
                "enabled": true,
                "severity_threshold": "minor_delays",
                "notify_recoveries": true,
                "schedules": [
                    {
                        "days": ["mon", "tue", "wed", "thu", "fri"],
                        "all_day": false,
                        "windows": [
                            { "start_time": "06:30:00", "end_time": "09:30:00" },
                            { "start_time": "16:00", "end_time": "19:00:00.000000" }
                        ]
                    }
                ]
            }
            """

        let preference = try decode(NotificationLinePreference.self, from: json)

        #expect(preference.schedules == [NotificationScheduleSelection.default.schedule])
    }

    @Test
    func decodedScheduleDefaultsMissingAllDayAndWindows() throws {
        let schedule = try decode(NotificationSchedule.self, from: #"{ "days": ["sat"] }"#)

        #expect(schedule == NotificationSchedule(days: [.saturday], allDay: false, windows: []))
    }

    @Test(arguments: ["24:00", "12:60", "noon", "12"])
    func decodingInvalidTimeOfDayThrows(time: String) {
        #expect(throws: DecodingError.self) {
            try decode(NotificationTimeOfDay.self, from: "\"\(time)\"")
        }
    }

    // MARK: - Encoding

    @Test
    func encodedScheduleUsesSnakeCaseAndHourMinuteTimes() throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .sortedKeys

        let data = try encoder.encode(NotificationScheduleSelection.default.schedule)

        #expect(
            String(decoding: data, as: UTF8.self)
                == #"{"all_day":false,"days":["mon","tue","wed","thu","fri"],"#
                + #""windows":[{"end_time":"09:30","start_time":"06:30"},"#
                + #"{"end_time":"19:00","start_time":"16:00"}]}"#
        )
    }

    @Test
    func allDayScheduleHasNoWindows() {
        let selection = NotificationScheduleSelection(days: [.saturday, .sunday], timeSlot: .allDay)

        #expect(selection.schedule == NotificationSchedule(days: [.saturday, .sunday], allDay: true, windows: []))
    }

    @Test
    func scheduleDaysAreSentInWeekOrder() {
        let selection = NotificationScheduleSelection(days: [.sunday, .wednesday, .monday], timeSlot: .peak)

        #expect(selection.schedule.days == [.monday, .wednesday, .sunday])
    }

    // MARK: - Mapping from server schedules

    @Test(arguments: [
        NotificationScheduleSelection(days: Set(NotificationWeekday.weekdays), timeSlot: .peak),
        NotificationScheduleSelection(days: Set(NotificationWeekday.weekdays), timeSlot: .allDay),
        NotificationScheduleSelection(days: Set(NotificationWeekday.weekend), timeSlot: .allDay),
        NotificationScheduleSelection(days: Set(NotificationWeekday.allCases), timeSlot: .allDay),
        NotificationScheduleSelection(days: [.tuesday, .saturday], timeSlot: .peak)
    ])
    func selectionRoundTripsThroughSchedule(selection: NotificationScheduleSelection) {
        #expect(NotificationScheduleSelection(schedules: [selection.schedule]) == selection)
    }

    /// The schedules the old presets (weekday peak, weekday all day, weekends, anytime) sent carry over unchanged.
    @Test
    func legacyPresetSchedulesCarryOver() {
        let weekdayPeak = NotificationSchedule(
            days: NotificationWeekday.weekdays,
            allDay: false,
            windows: [
                .init(startTime: .init(hour: 6, minute: 30), endTime: .init(hour: 9, minute: 30)),
                .init(startTime: .init(hour: 16, minute: 0), endTime: .init(hour: 19, minute: 0))
            ]
        )

        #expect(
            NotificationScheduleSelection(schedules: [weekdayPeak])
                == NotificationScheduleSelection(days: Set(NotificationWeekday.weekdays), timeSlot: .peak)
        )
        #expect(
            NotificationScheduleSelection(schedules: [.allDay(NotificationWeekday.weekdays)])
                == NotificationScheduleSelection(days: Set(NotificationWeekday.weekdays), timeSlot: .allDay)
        )
        #expect(
            NotificationScheduleSelection(schedules: [.allDay(NotificationWeekday.weekend)])
                == NotificationScheduleSelection(days: Set(NotificationWeekday.weekend), timeSlot: .allDay)
        )
        #expect(
            NotificationScheduleSelection(schedules: [.allDay(NotificationWeekday.allCases)])
                == NotificationScheduleSelection(days: Set(NotificationWeekday.allCases), timeSlot: .allDay)
        )
    }

    @Test
    func mappingIgnoresDayAndWindowOrder() {
        let schedules = [
            NotificationSchedule(
                days: [.friday, .monday, .wednesday, .tuesday, .thursday],
                allDay: false,
                windows: [
                    .init(startTime: .init(hour: 16, minute: 0), endTime: .init(hour: 19, minute: 0)),
                    .init(startTime: .init(hour: 6, minute: 30), endTime: .init(hour: 9, minute: 30))
                ]
            )
        ]

        #expect(NotificationScheduleSelection(schedules: schedules) == .default)
    }

    @Test
    func mappingIgnoresWindowsWhenAllDay() {
        let schedules = [
            NotificationSchedule(
                days: [.sunday, .saturday],
                allDay: true,
                windows: [.init(startTime: .init(hour: 9, minute: 0), endTime: .init(hour: 17, minute: 0))]
            )
        ]

        #expect(
            NotificationScheduleSelection(schedules: schedules)
                == NotificationScheduleSelection(days: [.saturday, .sunday], timeSlot: .allDay)
        )
    }

    // MARK: - Unsupported server schedules fall back to the default

    @Test
    func otherWindowsFallBackToDefault() {
        let schedules = [
            NotificationSchedule(
                days: [.saturday],
                allDay: false,
                windows: [.init(startTime: .init(hour: 7, minute: 0), endTime: .init(hour: 10, minute: 0))]
            )
        ]

        #expect(NotificationScheduleSelection(schedules: schedules) == .default)
    }

    @Test
    func morningPeakOnlyFallsBackToDefault() {
        let schedules = [
            NotificationSchedule(
                days: [.saturday],
                allDay: false,
                windows: [.init(startTime: .init(hour: 6, minute: 30), endTime: .init(hour: 9, minute: 30))]
            )
        ]

        #expect(NotificationScheduleSelection(schedules: schedules) == .default)
    }

    @Test
    func multipleSchedulesFallBackToDefault() {
        let schedules: [NotificationSchedule] = [.allDay([.monday]), .allDay([.saturday])]

        #expect(NotificationScheduleSelection(schedules: schedules) == .default)
    }

    @Test
    func emptySchedulesOrDaysFallBackToDefault() {
        #expect(NotificationScheduleSelection(schedules: []) == .default)
        #expect(NotificationScheduleSelection(schedules: [.allDay([])]) == .default)
    }

    @Test
    func timedScheduleWithoutWindowsFallsBackToDefault() {
        let schedules = [NotificationSchedule(days: [.monday], allDay: false, windows: [])]

        #expect(NotificationScheduleSelection(schedules: schedules) == .default)
    }
}

// MARK: - Private helpers

private extension NotificationScheduleTests {

    func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try JSONDecoder.tubeServiceModelDecoder.decode(type, from: Data(json.utf8))
    }
}
