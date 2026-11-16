import Models
import Testing

@testable import PresentationViews

struct LineViewStateTests {

    @Test
    func lineDisruptionStatusDisruptedLine() {
        let disruptedLine = Line.withStatus(.weaver, .partClosure, "Part Closure")
        let goodServiceLine = Line.withStatus(.bakerloo, .goodService, "Good Service")

        #expect(disruptedLine.isDisrupted)
        #expect(!goodServiceLine.isDisrupted)
    }

    @Test
    func lineDisruptionStates_mixedGoodAndDisrupted() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.with(statusSeverity: .severeDelays)])
        ]
        #expect(lines.hasDisruptions)
        #expect(!lines.allAreDisrupted)
        #expect(lines.disruptionsOnly().count == 1)

        #expect(!lines.allAreGoodService)
        #expect(lines.goodServiceOnly().count == 2)
    }

    @Test
    func lineDisruptionStates_allDisrupted() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.with(statusSeverity: .severeDelays)]),
            Line(id: .northern, lineStatuses: [.with(statusSeverity: .minorDelays)]),
            Line(id: .hammersmithAndCity, lineStatuses: [.with(statusSeverity: .partClosed)])
        ]
        #expect(lines.hasDisruptions)
        #expect(lines.allAreDisrupted)
        #expect(lines.disruptionsOnly().count == 3)

        #expect(!lines.allAreGoodService)
        #expect(lines.goodServiceOnly().isEmpty)
    }

    @Test
    func lineDisruptionStates_allGoodService() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService])
        ]
        #expect(!lines.hasDisruptions)
        #expect(!lines.allAreDisrupted)
        #expect(lines.disruptionsOnly().isEmpty)

        #expect(lines.allAreGoodService)
        #expect(lines.goodServiceOnly().count == 3)
    }

    @Test
    func linesWithFilteredFavourites() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService])
        ]

        let filteredValues = lines.favouritesOnly(matching: [.bakerloo])

        #expect(filteredValues.count == 1)
        #expect(filteredValues.first?.id == .bakerloo)
    }

    @Test
    func favouritesFollowUserOrderRatherThanSeverity() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.with(statusSeverity: .severeDelays)]),
            Line(id: .victoria, lineStatuses: [.goodService])
        ]

        let favourites = lines.favouritesOnly(matching: [.victoria, .bakerloo, .northern, .jubilee])

        // Jubilee isn't in the data, so it's skipped
        #expect(favourites.map(\.id) == [.victoria, .bakerloo, .northern])
    }

    @Test
    func linesWithValuesRemoved() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService])
        ]

        let filteredValues = lines.removingLineIDs([.bakerloo])

        #expect(filteredValues.count == 2)
        #expect(filteredValues[0].id == .northern)
        #expect(filteredValues[1].id == .hammersmithAndCity)

    }

    @Test
    func disruptedLinesAreSortedFirst() {
        // Given
        let goodServiceBakerloo = Line(id: .bakerloo, lineStatuses: [.with(statusSeverity: .goodService)])
        let goodServiceCircleLine = Line(id: .circle, lineStatuses: [.with(statusSeverity: .goodService)])
        let disruptedNorthernLine = Line(id: .northern, lineStatuses: [.with(statusSeverity: .severeDelays)])
        let disruptedPiccadillyLine = Line(id: .piccadilly, lineStatuses: [.with(statusSeverity: .partSuspended)])

        let unsortedValues = [
            goodServiceBakerloo,
            goodServiceCircleLine,
            disruptedNorthernLine,
            disruptedPiccadillyLine
        ]

        // When
        let sortedValues = unsortedValues.sortedByStatusSeverity()

        // Then
        #expect(
            sortedValues == [
                disruptedNorthernLine,
                disruptedPiccadillyLine,
                goodServiceBakerloo,
                goodServiceCircleLine
            ]
        )
    }

    @Test
    func mergedLineStatuses_goodService() {
        let line = Line(
            id: .bakerloo,
            lineStatuses: [.with(statusSeverity: .goodService)]
        )

        #expect(line.mergedLineStatuses.count == 1)
        #expect(line.mergedLineStatuses.first?.isDisrupted == false)
    }

    @Test
    func mergedLineStatuses_disrupted_uniqueReasons() {
        let line = Line(
            id: .bakerloo,
            lineStatuses: [
                .with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                .with(statusSeverity: .partClosed, reason: "Closure reason")
            ]
        )

        #expect(line.mergedLineStatuses.count == 2)
        #expect(line.mergedLineStatuses[0].reason == "Suspension reason")
        #expect(line.mergedLineStatuses[1].reason == "Closure reason")
    }

    @Test
    func mergedLineStatuses_duplicateReasonsMergedToOneGroup() {
        let line = Line(
            id: .bakerloo,
            lineStatuses: [
                .with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                .with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                .with(statusSeverity: .partSuspended, reason: "Suspension reason")
            ]
        )

        #expect(line.mergedLineStatuses.count == 1)
        #expect(line.mergedLineStatuses.first?.reason == "Suspension reason")
    }

    @Test
    func mergedLineStatuses_differentSeveritySameReason_combinedSeverityText() {
        let status1 = LineStatus(
            statusSeverity: .partSuspended,
            statusSeverityDescription: "Part Suspended",
            reason: "Signal failure",
            disruption: nil
        )
        let status2 = LineStatus(
            statusSeverity: .minorDelays,
            statusSeverityDescription: "Minor Delays",
            reason: "Signal failure",
            disruption: nil
        )
        let line = Line(id: .bakerloo, lineStatuses: [status1, status2])

        #expect(line.mergedLineStatuses.count == 1)
        #expect(line.mergedLineStatuses.first?.reason == "Signal failure")
        #expect(line.mergedLineStatuses.first?.severityText == "Part suspended, Minor delays")
    }

    @Test
    func truncatedStatusText_oneStatus_noTruncation() {
        let line = Line(
            id: .bakerloo,
            lineStatuses: [
                LineStatus(statusSeverity: .partSuspended, statusSeverityDescription: "Part Suspended", reason: nil, disruption: nil)
            ]
        )
        #expect(line.truncatedStatusText == "Part suspended")
    }

    @Test
    func truncatedStatusText_twoStatuses_noTruncation() {
        let line = Line(
            id: .bakerloo,
            lineStatuses: [
                LineStatus(statusSeverity: .partSuspended, statusSeverityDescription: "Part Suspended", reason: nil, disruption: nil),
                LineStatus(statusSeverity: .minorDelays, statusSeverityDescription: "Minor Delays", reason: nil, disruption: nil)
            ]
        )
        #expect(line.truncatedStatusText == "Part suspended, Minor delays")
    }

    @Test
    func truncatedStatusText_threeStatuses_truncatesWithEllipsis() {
        let line = Line(
            id: .bakerloo,
            lineStatuses: [
                LineStatus(statusSeverity: .partSuspended, statusSeverityDescription: "Part Suspended", reason: nil, disruption: nil),
                LineStatus(statusSeverity: .severeDelays, statusSeverityDescription: "Severe Delays", reason: nil, disruption: nil),
                LineStatus(statusSeverity: .minorDelays, statusSeverityDescription: "Minor Delays", reason: nil, disruption: nil)
            ]
        )
        #expect(line.truncatedStatusText == "Part suspended, Severe delays…")
    }

    // MARK: - Grouped by status

    @Test
    func groupedByStatus_allSameStatus_isOneGroup() {
        let lines = [
            Line(id: .metropolitan, lineStatuses: [.goodService]),
            Line(id: .circle, lineStatuses: [.goodService])
        ]

        let groups = lines.groupedByStatus()

        #expect(groups.map(\.statusText) == ["Good service"])
        #expect(groups.first?.lines.map(\.id) == [.circle, .metropolitan])
    }

    @Test
    func groupedByStatus_mixedStatuses_putsDisruptedFirstAndGoodServiceLast() {
        let lines = [
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService]),
            Line(id: .metropolitan, lineStatuses: [.described(.minorDelays, "Minor Delays")]),
            Line(id: .circle, lineStatuses: [.described(.plannedClosure, "Planned Closure")]),
            Line(id: .district, lineStatuses: [.described(.minorDelays, "Minor Delays")])
        ]

        let groups = lines.groupedByStatus()

        #expect(groups.map(\.statusText) == ["Planned closure", "Minor delays", "Good service"])
        #expect(groups.map { $0.lines.map(\.id) } == [[.circle], [.district, .metropolitan], [.hammersmithAndCity]])
        #expect(groups.map(\.isDisrupted) == [true, true, false])
    }

    @Test
    func groupedByStatus_noLines_isEmpty() {
        #expect([Line]().groupedByStatus().isEmpty)
    }

    // MARK: - Line name prefix

    @Test(arguments: [
        (TrainLineID.central, "CENTRAL LINE: Severe delays due to a signal failure.", "Severe delays due to a signal failure."),
        (.bakerloo, "Bakerloo Line: No service between Stonebridge Park and Harrow.", "No service between Stonebridge Park and Harrow."),
        (.waterlooAndCity, "Waterloo & City line: Service operates Monday to Friday.", "Service operates Monday to Friday."),
        (.dlr, "DOCKLANDS LIGHT RAILWAY: Sunday 22 October, no service.", "Sunday 22 October, no service."),
        (.tram, "LONDON TRAMS: Saturday 21 to Sunday 29 October.", "Saturday 21 to Sunday 29 October."),
        (.mildmay, "London Overground: Minor delays between Sydenham and West Croydon.", "Minor delays between Sydenham and West Croydon."),
        (.windrush, "WINDRUSH: no service between Sydenham and Crystal Palace.", "No service between Sydenham and Crystal Palace.")
    ])
    func lineNamePrefixIsRemovedFromAReason(lineID: TrainLineID, reason: String, expected: String) {
        #expect(reason.removingLineNamePrefix(for: lineID) == expected)
    }

    @Test
    func reasonWithoutTheLinesNameIsUnchanged() {
        let noPrefix = "No service between Paddington and Abbey Wood."
        let otherLine = "Victoria Line: Minor delays due to train cancellations."
        let otherLabel = "Sunday 22 October: no service before 10:00."

        #expect(noPrefix.removingLineNamePrefix(for: .elizabeth) == noPrefix)
        #expect(otherLine.removingLineNamePrefix(for: .circle) == otherLine)
        #expect(otherLabel.removingLineNamePrefix(for: .circle) == otherLabel)
    }

    @Test
    func mergedLineStatuses_reasonsLoseTheLinesNamePrefix() {
        let line = Line(
            id: .jubilee,
            lineStatuses: [.with(statusSeverity: .minorDelays, reason: "Jubilee Line: Minor delays due to train cancellations. ")]
        )

        #expect(line.mergedLineStatuses.first?.reason == "Minor delays due to train cancellations.")
    }

    // MARK: - Disruption summary

    @Test
    func disruptionSummary_goodService_isNil() {
        #expect([Line.withStatus(.circle, .goodService, "Good Service")].disruptionSummary == nil)
    }

    @Test
    func disruptionSummary_oneLine_namesTheLine() {
        let lines = [
            Line.withStatus(.circle, .minorDelays, "Minor Delays"),
            Line.withStatus(.metropolitan, .goodService, "Good Service")
        ]
        #expect(lines.disruptionSummary == "Minor delays on the Circle line")
    }

    @Test
    func disruptionSummary_dlrAndTramsAreNotLines() {
        #expect([Line.withStatus(.dlr, .severeDelays, "Severe Delays")].disruptionSummary == "Severe delays on the DLR")
        #expect([Line.withStatus(.tram, .minorDelays, "Minor Delays")].disruptionSummary == "Minor delays on London Trams")
    }

    @Test
    func disruptionSummary_severalLinesWithOneStatus_shareOneLinesPhrase() {
        let lines = [
            Line.withStatus(.metropolitan, .minorDelays, "Minor Delays"),
            Line.withStatus(.circle, .minorDelays, "Minor Delays"),
            Line.withStatus(.hammersmithAndCity, .minorDelays, "Minor Delays")
        ]
        // The list's punctuation follows the region, e.g. US English adds a comma before "and"
        let lineNames = ["Circle", "H&C", "Met"].formatted(.list(type: .and).locale(.copy))
        #expect(lines.disruptionSummary == "Minor delays on the \(lineNames) lines")
    }

    @Test
    func disruptionSummary_severalStatuses_saysDisruption() {
        let lines = [
            Line.withStatus(.circle, .plannedClosure, "Planned Closure"),
            Line.withStatus(.metropolitan, .minorDelays, "Minor Delays")
        ]
        #expect(lines.disruptionSummary == "Disruption on the Circle and Met lines")
    }

    @Test
    func disruptionSummary_outOfService_isASentenceAboutTheLine() {
        #expect([Line.withStatus(.circle, .suspended, "Suspended")].disruptionSummary == "The Circle line is suspended")
        #expect([Line.withStatus(.dlr, .notRunning, "Not Running")].disruptionSummary == "The DLR is not running")
        #expect([Line.withStatus(.tram, .serviceClosed, "Service Closed")].disruptionSummary == "London Trams is closed")
    }

    @Test
    func disruptionSummary_severalLinesOutOfService_usesAPluralVerb() {
        let lines = [
            Line.withStatus(.circle, .partSuspended, "Part Suspended"),
            Line.withStatus(.metropolitan, .partSuspended, "Part Suspended")
        ]
        #expect(lines.disruptionSummary == "The Circle and Met lines are part suspended")
    }

    @Test
    func disruptionSummary_outOfServiceWithDelays_leadsWithTheMostSevere() {
        let line = Line(
            id: .circle,
            lineStatuses: [
                .with(statusSeverity: .severeDelays, statusSeverityDescription: "Severe Delays", reason: "A"),
                .with(statusSeverity: .partSuspended, statusSeverityDescription: "Part Suspended", reason: "B")
            ]
        )
        #expect([line].disruptionSummary == "The Circle line is part suspended")
    }

    @Test
    func disruptionSummary_oneLineWithTwoStatuses_joinsThemInASentence() {
        let line = Line(
            id: .circle,
            lineStatuses: [
                .with(statusSeverity: .partClosure, statusSeverityDescription: "Part Closure", reason: "A"),
                .with(statusSeverity: .minorDelays, statusSeverityDescription: "Minor Delays", reason: "B")
            ]
        )
        #expect([line].disruptionSummary == "Part closure and minor delays on the Circle line")
    }
}

private extension LineStatus {
    static func described(_ severity: LineStatusSeverity, _ description: String) -> LineStatus {
        .init(statusSeverity: severity, statusSeverityDescription: description, reason: nil, disruption: nil)
    }
}

private extension Line {
    static func withStatus(_ id: TrainLineID, _ severity: LineStatusSeverity, _ description: String) -> Line {
        Line(id: id, lineStatuses: [.with(statusSeverity: severity, statusSeverityDescription: description)])
    }
}
