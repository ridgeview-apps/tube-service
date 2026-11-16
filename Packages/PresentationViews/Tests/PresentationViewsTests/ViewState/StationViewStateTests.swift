import Testing
import Models

@testable import PresentationViews

struct StationViewStateTests {

    @Test
    func stationSortedLineIDsAreUniqueAndSortedByName() {
        let station = makeStation(
            "HUBPAD",
            lineGroups: [[.victoria], [.metropolitan, .circle, .hammersmithAndCity], [.circle, .district]]
        )

        #expect(station.sortedLineIDs == [.circle, .district, .hammersmithAndCity, .metropolitan, .victoria])
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
    func lineGroupNameListsItsLinesByName() {
        let lineGroup = Station.LineGroup(atcoCode: "940GZZLUKSX", lineIds: [.metropolitan, .circle, .hammersmithAndCity])

        #expect(lineGroup.name == "Circle, Hammersmith & City, Metropolitan")
    }

    @Test
    func stationsAreSortedByName() {
        let stations = [
            makeStation("HUBPAD", name: "Paddington"),
            makeStation("HUBKGX", name: "King's Cross & St Pancras International"),
            makeStation("940GZZLUHBT", name: "High Barnet")
        ]

        #expect(stations.sortedByName().map(\.id) == ["940GZZLUHBT", "HUBKGX", "HUBPAD"])
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
        let stations = [makeStation("940GZZLUAGL"), makeStation("HUBKGX"), makeStation("HUBPAD"), makeStation("940GZZLUHBT")]
        let stops: [FavouriteStop] = [.station(id: "940GZZLUHBT"), .station(id: "HUBPAD"), .station(id: "HUBKGX")]

        #expect(stations.favourites(matching: stops).map(\.id) == ["940GZZLUHBT", "HUBPAD", "HUBKGX"])
    }

    @Test
    func favouriteStationsSkipUnknownStations() {
        let stations = [makeStation("940GZZLUAGL"), makeStation("HUBKGX")]
        let stops: [FavouriteStop] = [.station(id: "NOT-A-STATION"), .station(id: "940GZZLUAGL")]

        #expect(stations.favourites(matching: stops).map(\.id) == ["940GZZLUAGL"])
    }

    @Test
    func favouriteStationsIncludeAllTheirLineGroups() {
        let kingsCross = makeStation("HUBKGX", lineGroups: [[.circle, .hammersmithAndCity, .metropolitan], [.northern], [.victoria]])

        let favouriteStations = [makeStation("940GZZLUAGL"), kingsCross].favourites(matching: [.station(id: "HUBKGX")])

        #expect(favouriteStations.first?.lineGroups == kingsCross.lineGroups)
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
}

// MARK: - Private helpers

private extension StationViewStateTests {

    func makeStation(_ id: String, name: String = "Station", lineGroups: [[TrainLineID]] = []) -> Station {
        Station(
            id: id,
            icsCode: "1000000",
            name: name,
            location: LocationCoordinate(lat: 51.5, lon: -0.1),
            lineGroups: lineGroups.map { Station.LineGroup(atcoCode: "\(id)-ATCO", lineIds: $0) }
        )
    }
}
