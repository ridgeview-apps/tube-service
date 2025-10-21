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
            kingsCrossSortedLineIDs == [.circle,
                                        .hammersmithAndCity,
                                        .metropolitan,
                                        .northern,
                                        .piccadilly,
                                        .victoria]
        )
        
        #expect(
            paddingtonSortedLineIDs == [.bakerloo,
                                        .circle,
                                        .district,
                                        .elizabeth,
                                        .hammersmithAndCity]
        )
        #expect(highBarnetSortedLineIDs == [.northern])
    }
    
    @Test
    func stationLineGroupNames() {
        let kingsCrossLineGroupNames = ModelStubs.kingsCrossStation.lineGroups.map(\.name)
        let paddingtonLineGroupNames = ModelStubs.paddingtonStation.lineGroups.map(\.name)
        let highBarnetLineGroupNames = ModelStubs.highBarnetStation.lineGroups.map(\.name)
        
        #expect(
            kingsCrossLineGroupNames == ["Circle, Hammersmith & City, Metropolitan",
                                         "Northern",
                                         "Piccadilly",
                                         "Victoria"]
        )
        #expect(
            paddingtonLineGroupNames ==  ["Bakerloo",
                                          "Circle, District",
                                          "Circle, Hammersmith & City",
                                          "Elizabeth"]
        )
        #expect(
            highBarnetLineGroupNames == ["Northern"]
        )
    }
    
    @Test
    func stationsAreSortedByName() {
        let unsortedValues = [ModelStubs.paddingtonStation,
                              ModelStubs.kingsCrossStation,
                              ModelStubs.highBarnetStation]
        
        let expectedValues = [ModelStubs.highBarnetStation,
                              ModelStubs.kingsCrossStation,
                              ModelStubs.paddingtonStation]
        
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
    func stationsFilteredByFavouriteLineGroups() {
        let stations = ModelStubs.stations
        
        let favouriteLineGroupIDs = Set(["940GZZLUKSX-circle,hammersmith-city,metropolitan", // Kings X - Circle, H&C, Met lines
                                         "940GZZLUKSX-northern",   // Kings X - Northern line
                                         "940GZZLUKSX-piccadilly", // Kingx X - Piccadilly line
                                         "940GZZLUPAC-bakerloo",
                                         "940GZZLUHBT-northern"])
                            
        let favouriteStations = stations.favourites(matching: favouriteLineGroupIDs)
        let favouriteStationIDs = favouriteStations.map(\.id)
        
        #expect(favouriteStations.count == 3)
        #expect(favouriteStationIDs.contains(ModelStubs.kingsCrossStation.id))
        #expect(favouriteStationIDs.contains(ModelStubs.paddingtonStation.id))
        #expect(favouriteStationIDs.contains(ModelStubs.highBarnetStation.id))
    }
}
