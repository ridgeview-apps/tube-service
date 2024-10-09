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
    
    @Test
    func stationLineGroupDataTypes() {
        let standardLineGroupType = Station.LineGroup(atcoCode: "FOO", lineIds: [.northern])
        let elizabethLineGroupType = Station.LineGroup(atcoCode: "BAR", lineIds: [.elizabeth])

        #expect(standardLineGroupType.arrivalsDataType == .arrivalPredictions)
        #expect(elizabethLineGroupType.arrivalsDataType == .arrivalDepartures([.elizabeth]))
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
