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

        #expect(preference.schedules == NotificationSchedulePreset.weekdayPeak.schedules)
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
    func encodedScheduleUsesSnakeCaseAndFullTimes() throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .sortedKeys

        let data = try encoder.encode(NotificationSchedulePreset.weekdayPeak.schedules)

        #expect(
            String(decoding: data, as: UTF8.self)
                == #"[{"all_day":false,"days":["mon","tue","wed","thu","fri"],"#
                + #""windows":[{"end_time":"09:30:00","start_time":"06:30:00"},"#
                + #"{"end_time":"19:00:00","start_time":"16:00:00"}]}]"#
        )
    }

    // MARK: - Preset matching

    @Test(arguments: NotificationSchedulePreset.knownPresets)
    func knownPresetRoundTripsThroughSchedules(preset: NotificationSchedulePreset) {
        #expect(NotificationSchedulePreset(schedules: preset.schedules) == preset)
    }

    @Test
    func presetMatchingIgnoresDayAndWindowOrder() {
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

        #expect(NotificationSchedulePreset(schedules: schedules) == .weekdayPeak)
    }

    @Test
    func presetMatchingIgnoresWindowsWhenAllDay() {
        let schedules = [
            NotificationSchedule(
                days: [.sunday, .saturday],
                allDay: true,
                windows: [.init(startTime: .init(hour: 9, minute: 0), endTime: .init(hour: 17, minute: 0))]
            )
        ]

        #expect(NotificationSchedulePreset(schedules: schedules) == .weekends)
    }

    @Test
    func unrecognisedSchedulesArePreservedAsCustom() {
        let schedules = [
            NotificationSchedule(
                days: NotificationWeekday.weekdays,
                allDay: false,
                windows: [.init(startTime: .init(hour: 7, minute: 0), endTime: .init(hour: 10, minute: 0))]
            )
        ]

        let preset = NotificationSchedulePreset(schedules: schedules)

        #expect(preset == .custom(schedules))
        #expect(preset.schedules == schedules)
    }
}

// MARK: - Private helpers

private extension NotificationScheduleTests {

    func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try JSONDecoder.tubeServiceModelDecoder.decode(type, from: Data(json.utf8))
    }
}
