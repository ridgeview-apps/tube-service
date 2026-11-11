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
}
