import Testing
import Models
import ModelStubs

@testable import PresentationViews

struct StationViewStateTests {

    @Test
    func stationSortedLineIDs() {
        let kingsCrossSortedLineIDs = ModelStubs.kingsCrossStation.sortedLineIDs
        let paddingtonSortedLineIDs = ModelStubs.paddingtonStation.sortedLineIDs
        let highBarnetSortedLineIDs = ModelStubs.highBarnetStation.sortedLineIDs

        #expect(
            kingsCrossSortedLineIDs == [
                .circle,
                .hammersmithAndCity,
                .metropolitan,
                .northern,
                .piccadilly,
                .victoria
            ]
        )

        #expect(
            paddingtonSortedLineIDs == [
                .bakerloo,
                .circle,
                .district,
                .elizabeth,
                .hammersmithAndCity
            ]
        )
        #expect(highBarnetSortedLineIDs == [.northern])
    }

    @Test
    func lineGroupShortNameAbbreviatesLongLineNames() {
        let lineGroup = Station.LineGroup(atcoCode: "940GZZLUKSX", lineIds: [.metropolitan, .circle, .hammersmithAndCity])

        #expect(lineGroup.shortName == "Circle, H&C, Met")
    }

    @Test
    func lineGroupShortNameSpellsOutAMetropolitanLineOnItsOwn() {
        let lineGroup = Station.LineGroup(atcoCode: "940GZZLUBST", lineIds: [.metropolitan])

        #expect(lineGroup.shortName == "Metropolitan")
    }

    @Test
    func lineGroupShortNameAbbreviatesAHammersmithAndCityLineOnItsOwn() {
        let lineGroup = Station.LineGroup(atcoCode: "940GZZLUGHK", lineIds: [.hammersmithAndCity])

        #expect(lineGroup.shortName == "H&C")
    }

    @Test
    func stationLineGroupNames() {
        let kingsCrossLineGroupNames = ModelStubs.kingsCrossStation.lineGroups.map(\.name)
        let paddingtonLineGroupNames = ModelStubs.paddingtonStation.lineGroups.map(\.name)
        let highBarnetLineGroupNames = ModelStubs.highBarnetStation.lineGroups.map(\.name)

        #expect(
            kingsCrossLineGroupNames == [
                "Circle, Hammersmith & City, Metropolitan",
                "Northern",
                "Piccadilly",
                "Victoria"
            ]
        )
        #expect(
            paddingtonLineGroupNames == [
                "Bakerloo",
                "Circle, District",
                "Circle, Hammersmith & City",
                "Elizabeth"
            ]
        )
        #expect(
            highBarnetLineGroupNames == ["Northern"]
        )
    }

    @Test
    func stationsAreSortedByName() {
        let unsortedValues = [
            ModelStubs.paddingtonStation,
            ModelStubs.kingsCrossStation,
            ModelStubs.highBarnetStation
        ]

        let expectedValues = [
            ModelStubs.highBarnetStation,
            ModelStubs.kingsCrossStation,
            ModelStubs.paddingtonStation
        ]

        #expect(unsortedValues.sortedByName() == expectedValues)
    }

    @Test(
        arguments: [
            [TrainLineID.bakerloo],
            [TrainLineID.central],
            [TrainLineID.circle],
            [TrainLineID.district],
            [TrainLineID.dlr],
            [TrainLineID.hammersmithAndCity],
            [TrainLineID.jubilee],
            [TrainLineID.metropolitan],
            [TrainLineID.northern],
            [TrainLineID.piccadilly],
            [TrainLineID.victoria],
            [TrainLineID.waterlooAndCity],
            [TrainLineID.tram]
        ]
    )
    func shouldUseArrivalPredictionDataType(forLineIDs givenLineIDs: [TrainLineID]) {
        // Given
        let lineGroup = Station.LineGroup(atcoCode: "FOO", lineIds: givenLineIDs)
        #expect(lineGroup.arrivalsDataType == .arrivalPredictions)
    }

    @Test(
        arguments: [
            [TrainLineID.elizabeth],
            [TrainLineID.liberty],
            [TrainLineID.lioness],
            [TrainLineID.mildmay],
            [TrainLineID.suffragette],
            [TrainLineID.weaver],
            [TrainLineID.windrush]
        ]
    )
    func shouldUseArrivalDepaturesDataType(forLineIDs givenLineIDs: [TrainLineID]) {
        // Given
        let lineGroup = Station.LineGroup(atcoCode: "FOO", lineIds: givenLineIDs)
        #expect(lineGroup.arrivalsDataType == .arrivalDepartures(givenLineIDs))
    }

    @Test
    func favouriteStationsFollowTheStopOrder() {
        let stops: [FavouriteStop] = [
            .station(id: ModelStubs.highBarnetStation.id),
            .station(id: ModelStubs.paddingtonStation.id),
            .station(id: ModelStubs.kingsCrossStation.id)
        ]

        let favouriteStations = ModelStubs.stations.favourites(matching: stops)

        #expect(
            favouriteStations.map(\.id) == [
                ModelStubs.highBarnetStation.id,
                ModelStubs.paddingtonStation.id,
                ModelStubs.kingsCrossStation.id
            ]
        )
    }

    @Test
    func favouriteStationsSkipUnknownStations() {
        let stops: [FavouriteStop] = [.station(id: "NOT-A-STATION"), .station(id: ModelStubs.angelStation.id)]

        let favouriteStations = ModelStubs.stations.favourites(matching: stops)

        #expect(favouriteStations.map(\.id) == [ModelStubs.angelStation.id])
    }

    @Test
    func favouriteStationsIncludeAllTheirLineGroups() {
        let favouriteStations = ModelStubs.stations.favourites(matching: [.station(id: ModelStubs.kingsCrossStation.id)])

        #expect(favouriteStations.first?.lineGroups == ModelStubs.kingsCrossStation.lineGroups)
    }

    @Test
    func lineGroupsDisruptedByALineIncludeEveryGroupContainingIt() {
        let subSurface = Station.LineGroup(atcoCode: "940GZZLUKSX", lineIds: [.circle, .metropolitan])
        let victoria = Station.LineGroup(atcoCode: "940GZZLUKSX", lineIds: [.victoria])
        let metropolitanOnly = Station.LineGroup(atcoCode: "940GZZLUBST", lineIds: [.metropolitan])

        let disruptedIDs = [subSurface, victoria, metropolitanOnly].ids(
            disruptedBy: [Line(id: .metropolitan, lineStatuses: [.with(statusSeverity: .minorDelays)])]
        )

        #expect(disruptedIDs == [subSurface.id, metropolitanOnly.id])
    }

    @Test
    func stationNamePrefixIsRemovedFromANotice() {
        let notice = "KINGS CROSS ST. PANCRAS STATION: The escalator to platform 5 is closed."

        #expect(notice.removingStationNamePrefix("King's Cross & St Pancras International") == "The escalator to platform 5 is closed.")
    }

    @Test
    func noticeWithoutAStationNamePrefixIsUnchanged() {
        let notice = "Step-free access: lifts are out of service."

        #expect(notice.removingStationNamePrefix("Pimlico") == notice)
    }

    @Test
    func noticeStartingWithTheStationsOwnNameHasItRemoved() {
        let notice = "Pimlico: reduced escalator service."

        #expect(notice.removingStationNamePrefix("Pimlico") == "reduced escalator service.")
    }

    @Test
    func disruptionSummaryIsTheStatusWhenEveryLineInTheGroupShowsIt() {
        let summary = LineDisruptionSummary(
            disruptedLines: [.disrupted(.circle, .minorDelays), .disrupted(.metropolitan, .minorDelays)],
            lineGroupLineIDs: [.metropolitan, .circle]
        )

        #expect(summary == .status("Minor delays"))
    }

    @Test
    func disruptionSummaryNamesTheLinesSharingAStatus() {
        let summary = LineDisruptionSummary(
            disruptedLines: [.disrupted(.metropolitan, .minorDelays)],
            lineGroupLineIDs: [.circle, .hammersmithAndCity, .metropolitan]
        )

        #expect(summary == .statusOnLines("Minor delays", [.metropolitan]))
    }

    @Test
    func disruptionSummaryNamesTheLinesWhenTheirStatusesDiffer() {
        let summary = LineDisruptionSummary(
            disruptedLines: [.disrupted(.metropolitan, .minorDelays), .disrupted(.circle, .plannedClosure)],
            lineGroupLineIDs: [.circle, .metropolitan]
        )

        #expect(summary == .disruptionOnLines([.circle, .metropolitan]))
    }

    @Test
    func noDisruptionSummaryWithoutDisruptedLines() {
        #expect(LineDisruptionSummary(disruptedLines: [], lineGroupLineIDs: [.northern]) == nil)
    }
}

private extension Line {
    static func disrupted(_ id: TrainLineID, _ severity: LineStatusSeverity) -> Line {
        let description =
            switch severity {
            case .plannedClosure: "Planned Closure"
            default: "Minor Delays"
            }
        return Line(id: id, lineStatuses: [.with(statusSeverity: severity, statusSeverityDescription: description)])
    }
}
