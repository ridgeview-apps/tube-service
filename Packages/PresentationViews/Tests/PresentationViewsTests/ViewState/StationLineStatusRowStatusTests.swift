import Models
import Testing

@testable import PresentationViews

struct StationLineStatusRowStatusTests {

    @Test
    func anyDisruptedLine_isADisruption() {
        let lines = [
            Line.with(.circle, .goodService, "Good Service"),
            Line.with(.metropolitan, .minorDelays, "Minor Delays")
        ]

        let status = StationLineStatusRow.Status(lines: lines, isLoading: false)

        #expect(status == .disruption("Minor delays on the Metropolitan line"))
        #expect(status.isDisruption)
    }

    @Test
    func allLinesGoodService_isGoodService() {
        let lines = [Line.with(.northern, .goodService, "Good Service")]

        let status = StationLineStatusRow.Status(lines: lines, isLoading: false)

        #expect(status == .goodService("Good service on the Northern line"))
        #expect(!status.isDisruption)
    }

    @Test
    func noLines_isLoadingWhileLoading() {
        #expect(StationLineStatusRow.Status(lines: [], isLoading: true) == .loading)
    }

    @Test
    func noLines_isUnavailableOnceLoaded() {
        #expect(StationLineStatusRow.Status(lines: [], isLoading: false) == .unavailable)
    }

    @Test
    func loadedLines_winOverLoading() {
        // A refresh reloads the statuses while the previous ones are still showing
        let lines = [Line.with(.northern, .goodService, "Good Service")]

        #expect(StationLineStatusRow.Status(lines: lines, isLoading: true) == .goodService("Good service on the Northern line"))
    }
}

private extension Line {
    static func with(_ id: TrainLineID, _ severity: LineStatusSeverity, _ description: String) -> Line {
        Line(
            id: id,
            lineStatuses: [
                .init(statusSeverity: severity, statusSeverityDescription: description, reason: nil, disruption: nil)
            ]
        )
    }
}
