import Foundation
import Testing

@testable import Models
@testable import ModelStubs

struct TubeServiceModelDecoderTests {

    // MARK: - DailyDisruptionSummary structure

    @Test
    func decodedDisruptionSummaryStructure() throws {
        let json = """
            {
                "operational_date": "2026-06-18",
                "timezone": "Europe/London",
                "starts_at": "2026-06-18T04:00:00Z",
                "ends_at": "2026-06-19T04:00:00Z",
                "lines": {
                    "central": [
                        {
                            "line_id": "central",
                            "observed_at": "2026-06-18T09:32:00Z",
                            "transition": "disruption_started",
                            "statuses": [
                                {
                                    "status_severity": 6,
                                    "status_severity_description": "Severe Delays",
                                    "reason": "CENTRAL LINE: Severe delays due to a signal failure."
                                }
                            ]
                        }
                    ],
                    "victoria": []
                }
            }
            """

        let summary = try decode(DailyDisruptionSummary.self, from: json)

        #expect(summary.timezone == "Europe/London")
        #expect(summary.lines.count == 2)
        #expect(summary.lines["victoria"]?.isEmpty == true)

        let snapshots = try #require(summary.lines["central"])
        #expect(snapshots.count == 1)
    }

    // MARK: - Date parsing

    @Test
    func decodedDisruptionSummaryDates() throws {
        let json = """
            {
                "operational_date": "2026-06-18",
                "timezone": "Europe/London",
                "starts_at": "2026-06-18T04:00:00Z",
                "ends_at": "2026-06-19T04:00:00Z",
                "lines": {}
            }
            """

        let summary = try decode(DailyDisruptionSummary.self, from: json)

        #expect(summary.operationalDate == dateOnly("2026-06-18"))
        #expect(summary.startsAt == iso8601("2026-06-18T04:00:00Z"))
        #expect(summary.endsAt == iso8601("2026-06-19T04:00:00Z"))
    }

    @Test
    func decodedSnapshotObservedAt() throws {
        let summary = try decode(DailyDisruptionSummary.self, from: snapshotJSON(transition: "baseline"))
        let snapshot = try #require(summary.lines["central"]?.first)
        #expect(snapshot.observedAt == iso8601("2026-06-18T09:00:00Z"))
    }

    @Test
    func decodedNotificationDeviceDatesWithMicroseconds() throws {
        let json = """
            {
                "device_id": "abc123",
                "platform": "ios",
                "enabled": true,
                "app_version": "1.0.0",
                "created_at": "2026-06-20T09:49:14.794457Z",
                "updated_at": "2026-06-20T09:49:14.794457Z",
                "last_seen_at": "2026-06-20T09:49:14.794457Z"
            }
            """
        let device = try decode(NotificationDevice.self, from: json)
        #expect(device.createdAt == iso8601WithFractionalSeconds("2026-06-20T09:49:14.794457Z"))
    }

    @Test
    func decodedNotificationDeviceDatesWithMilliseconds() throws {
        let json = """
            {
                "device_id": "abc123",
                "platform": "ios",
                "enabled": true,
                "app_version": null,
                "created_at": "2026-06-20T09:49:14.794Z",
                "updated_at": "2026-06-20T09:49:14.794Z",
                "last_seen_at": "2026-06-20T09:49:14.794Z"
            }
            """
        let device = try decode(NotificationDevice.self, from: json)
        #expect(device.createdAt == iso8601WithFractionalSeconds("2026-06-20T09:49:14.794Z"))
        #expect(device.appVersion == nil)
    }

    // Regression test: backend returns ISO8601 timestamps with fractional seconds + Z timezone,
    // which the old custom DateFormatter chain could not parse (no Z suffix support).
    @Test
    func decodedNotificationDeviceDatesMatchProductionFormat() throws {
        let json = """
            {
                "device_id": "abc123",
                "platform": "ios",
                "enabled": true,
                "app_version": "2.1.0",
                "app_variant": "beta",
                "created_at": "2026-07-04T21:18:49.478974Z",
                "updated_at": "2026-07-05T10:34:44.617409Z",
                "last_seen_at": "2026-07-05T10:34:44.617409Z"
            }
            """
        let device = try decode(NotificationDevice.self, from: json)
        #expect(device.createdAt == iso8601WithFractionalSeconds("2026-07-04T21:18:49.478974Z"))
        #expect(device.updatedAt == iso8601WithFractionalSeconds("2026-07-05T10:34:44.617409Z"))
    }

    // MARK: - LineStatusSnapshot (via DailyDisruptionSummary)

    @Test
    func decodedSnapshotFields() throws {
        let json = """
            {
                "operational_date": "2026-06-18",
                "timezone": "Europe/London",
                "starts_at": "2026-06-18T04:00:00Z",
                "ends_at": "2026-06-19T04:00:00Z",
                "lines": {
                    "jubilee": [
                        {
                            "line_id": "jubilee",
                            "observed_at": "2026-06-18T10:15:00Z",
                            "transition": "service_resumed",
                            "statuses": [
                                {
                                    "status_severity": 10,
                                    "status_severity_description": "Good Service"
                                }
                            ]
                        }
                    ]
                }
            }
            """

        let summary = try decode(DailyDisruptionSummary.self, from: json)
        let snapshot = try #require(summary.lines["jubilee"]?.first)

        #expect(snapshot.lineId == .jubilee)
        #expect(snapshot.transition == .serviceResumed)

        let status = try #require(snapshot.statuses.first)
        #expect(status.statusSeverity == .goodService)
        #expect(status.statusSeverityDescription == "Good Service")
        #expect(status.reason == nil)
    }

    @Test
    func decodedSnapshotStatusWithReason() throws {
        let json = """
            {
                "operational_date": "2026-06-18",
                "timezone": "Europe/London",
                "starts_at": "2026-06-18T04:00:00Z",
                "ends_at": "2026-06-19T04:00:00Z",
                "lines": {
                    "central": [
                        {
                            "line_id": "central",
                            "observed_at": "2026-06-18T09:32:00Z",
                            "transition": "disruption_started",
                            "statuses": [
                                {
                                    "status_severity": 6,
                                    "status_severity_description": "Severe Delays",
                                    "reason": "CENTRAL LINE: Severe delays due to a signal failure."
                                }
                            ]
                        }
                    ]
                }
            }
            """

        let summary = try decode(DailyDisruptionSummary.self, from: json)
        let status = try #require(summary.lines["central"]?.first?.statuses.first)

        #expect(status.statusSeverity == .severeDelays)
        #expect(status.statusSeverityDescription == "Severe Delays")
        #expect(status.reason == "CENTRAL LINE: Severe delays due to a signal failure.")
    }

    // MARK: - Transition decoding

    @Test(
        arguments: zip(
            ["baseline", "disruption_started", "disruption_changed", "service_resumed", "status_changed"],
            [LineStatusTransition.baseline, .disruptionStarted, .disruptionChanged, .serviceResumed, .statusChanged]
        )
    )
    func decodedSnapshotTransition(rawValue: String, expected: LineStatusTransition) throws {
        let summary = try decode(DailyDisruptionSummary.self, from: snapshotJSON(transition: rawValue))
        let snapshot = try #require(summary.lines["central"]?.first)
        #expect(snapshot.transition == expected)
    }

    // MARK: - LineStatusSnapshot (standalone)

    @Test
    func decodedLineStatusSnapshot() throws {
        let json = """
            {
                "line_id": "jubilee",
                "observed_at": "2026-06-18T11:30:00Z",
                "transition": "service_resumed",
                "statuses": [
                    {
                        "status_severity": 10,
                        "status_severity_description": "Good Service"
                    }
                ]
            }
            """

        let snapshot = try decode(LineStatusSnapshot.self, from: json)

        #expect(snapshot.lineId == .jubilee)
        #expect(snapshot.transition == .serviceResumed)
        #expect(snapshot.observedAt == iso8601("2026-06-18T11:30:00Z"))
        #expect(snapshot.statuses.first?.statusSeverity == .goodService)
    }

    // MARK: - DailyLineTimeline

    @Test
    func decodedDailyLineTimelineStructure() throws {
        let timeline = try decode(DailyLineTimeline.self, from: timelineJSON(snapshotCount: 2))

        #expect(timeline.lineId == .victoria)
        #expect(timeline.timezone == "Europe/London")
        #expect(timeline.snapshots.count == 2)
    }

    @Test
    func decodedDailyLineTimelineWithEmptySnapshots() throws {
        let timeline = try decode(DailyLineTimeline.self, from: timelineJSON(snapshotCount: 0))
        #expect(timeline.snapshots.isEmpty)
    }

    @Test
    func decodedDailyLineTimelineDates() throws {
        let json = """
            {
                "line_id": "victoria",
                "operational_date": "2026-06-18",
                "timezone": "Europe/London",
                "starts_at": "2026-06-18T04:00:00Z",
                "ends_at": "2026-06-19T04:00:00Z",
                "snapshots": [
                    {
                        "line_id": "victoria",
                        "observed_at": "2026-06-18T09:15:00Z",
                        "transition": "disruption_started",
                        "statuses": []
                    }
                ]
            }
            """

        let timeline = try decode(DailyLineTimeline.self, from: json)

        #expect(timeline.operationalDate == dateOnly("2026-06-18"))
        #expect(timeline.startsAt == iso8601("2026-06-18T04:00:00Z"))
        #expect(timeline.endsAt == iso8601("2026-06-19T04:00:00Z"))
        #expect(timeline.snapshots.first?.observedAt == iso8601("2026-06-18T09:15:00Z"))
    }

    // MARK: - SystemStatus

    @Test
    func decodedSystemStatusOK() {
        #expect(ModelStubs.systemStatusOK.status == .ok)
    }

    @Test
    func decodedSystemStatusOutage() {
        #expect(ModelStubs.systemStatusOutage.status == .outage)
    }

    @Test
    func decodedSystemStatusResolved() {
        #expect(ModelStubs.systemStatusResolved.status == .resolved)
    }
}

// MARK: - Private helpers

private extension TubeServiceModelDecoderTests {

    func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try JSONDecoder.tubeServiceModelDecoder.decode(type, from: Data(json.utf8))
    }

    func dateOnly(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.date(from: string)!
    }

    func iso8601(_ string: String) -> Date {
        try! Date(string, strategy: .iso8601)
    }

    func iso8601WithFractionalSeconds(_ string: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string)!
    }

    func timelineJSON(snapshotCount: Int) -> String {
        let snapshots = Array(
            repeating: """
                {
                    "line_id": "victoria",
                    "observed_at": "2026-06-18T09:00:00Z",
                    "transition": "baseline",
                    "statuses": []
                }
                """,
            count: snapshotCount
        ).joined(separator: ",")
        return """
            {
                "line_id": "victoria",
                "operational_date": "2026-06-18",
                "timezone": "Europe/London",
                "starts_at": "2026-06-18T04:00:00Z",
                "ends_at": "2026-06-19T04:00:00Z",
                "snapshots": [\(snapshots)]
            }
            """
    }

    func snapshotJSON(transition: String) -> String {
        """
        {
            "operational_date": "2026-06-18",
            "timezone": "Europe/London",
            "starts_at": "2026-06-18T04:00:00Z",
            "ends_at": "2026-06-19T04:00:00Z",
            "lines": {
                "central": [
                    {
                        "line_id": "central",
                        "observed_at": "2026-06-18T09:00:00Z",
                        "transition": "\(transition)",
                        "statuses": []
                    }
                ]
            }
        }
        """
    }

}
