import Models
import XCTest

@testable import PresentationViews

final class StationViewStateTests: XCTestCase {
    
    func testStationSortedLineIDs() {
        XCTAssertEqual(
            [.circle, .hammersmithAndCity, .metropolitan, .northern, .piccadilly, .victoria],
            ModelStubs.kingsCrossStation.sortedLineIDs
        )
        XCTAssertEqual(
            [.bakerloo, .circle, .district, .elizabeth, .hammersmithAndCity],
            ModelStubs.paddingtonStation.sortedLineIDs
        )
        XCTAssertEqual([.northern], ModelStubs.highBarnetStation.sortedLineIDs)
    }
    
    func testStationLineGroupNames() {
        XCTAssertEqual(
            ["Circle, Hammersmith & City, Metropolitan",
             "Northern",
             "Piccadilly",
             "Victoria"],
            ModelStubs.kingsCrossStation.lineGroups.map(\.name)
        )
        XCTAssertEqual(
            ["Bakerloo",
             "Circle, District",
             "Circle, Hammersmith & City",
             "Elizabeth"],
            ModelStubs.paddingtonStation.lineGroups.map(\.name)
        )
        XCTAssertEqual(
            ["Northern"],
            ModelStubs.highBarnetStation.lineGroups.map(\.name)
        )
    }
    
    func testStationSorting() {
        let unsortedStations = [ModelStubs.paddingtonStation,
                                ModelStubs.kingsCrossStation,
                                ModelStubs.highBarnetStation]
        
        let sortedStations = unsortedStations.sortedByName()
        
        XCTAssertEqual([ModelStubs.highBarnetStation,
                        ModelStubs.kingsCrossStation,
                        ModelStubs.paddingtonStation], sortedStations)
    }
    
    func testStationLineGroupDataTypes() {
        let standardLineGroupType = Station.LineGroup(atcoCode: "FOO", lineIds: [.northern])
        let elizabethLineGroupType = Station.LineGroup(atcoCode: "BAR", lineIds: [.elizabeth])

        XCTAssertEqual(.arrivalPredictions, standardLineGroupType.arrivalsDataType)
        XCTAssertEqual(.arrivalDepartures([.elizabeth]), elizabethLineGroupType.arrivalsDataType)
    }
    
    func testStationsFilteredByFavouriteLineGroups() {
        let stations = ModelStubs.stations
        
        let favouriteLineGroupIDs = Set(["940GZZLUKSX-circle,hammersmith-city,metropolitan", // Kings X - Circle, H&C, Met lines
                                         "940GZZLUKSX-northern",   // Kings X - Northern line
                                         "940GZZLUKSX-piccadilly", // Kingx X - Piccadilly line
                                         "940GZZLUPAC-bakerloo",
                                         "940GZZLUHBT-northern"])
                            
        let favouriteStations = stations.favourites(matching: favouriteLineGroupIDs)
        
        XCTAssertEqual(3, favouriteStations.count)
        XCTAssertTrue(favouriteStations.map(\.id).contains(ModelStubs.kingsCrossStation.id))
        XCTAssertTrue(favouriteStations.map(\.id).contains(ModelStubs.paddingtonStation.id))
        XCTAssertTrue(favouriteStations.map(\.id).contains(ModelStubs.highBarnetStation.id))
    }
}
