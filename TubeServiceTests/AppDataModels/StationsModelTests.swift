@testable import Tube_Service

import Models
import DataClients
import XCTest

@MainActor
final class StationsModelTests: XCTestCase {
    
    func testLoadStationsByID() {
        let stationsModel = StationsModel(stationsClient: StubStationsClient(), fetchImmediately: true)
        
        XCTAssertEqual(ModelStubs.kingsCrossStation, stationsModel.station(forID: "HUBKGX"))
        XCTAssertEqual(ModelStubs.paddingtonStation, stationsModel.station(forID: "HUBPAD"))
        XCTAssertEqual(ModelStubs.highBarnetStation, stationsModel.station(forID: "940GZZLUHBT"))
    }
    
    func testLoadStationsByLineGroup() {
        let stationsModel = StationsModel(stationsClient: StubStationsClient(), fetchImmediately: true)
        
        // King's X
        XCTAssertEqual(ModelStubs.kingsCrossStation, stationsModel.station(forLineGroupID: "940GZZLUKSX-circle,hammersmith-city,metropolitan"))
        XCTAssertEqual(ModelStubs.kingsCrossStation, stationsModel.station(forLineGroupID: "940GZZLUKSX-northern"))
        XCTAssertEqual(ModelStubs.kingsCrossStation, stationsModel.station(forLineGroupID: "940GZZLUKSX-piccadilly"))
        XCTAssertEqual(ModelStubs.kingsCrossStation, stationsModel.station(forLineGroupID: "940GZZLUKSX-victoria"))
        
        // Paddington
        XCTAssertEqual(ModelStubs.paddingtonStation, stationsModel.station(forLineGroupID: "940GZZLUPAC-bakerloo"))
        XCTAssertEqual(ModelStubs.paddingtonStation, stationsModel.station(forLineGroupID: "940GZZLUPAC-circle,district"))
        XCTAssertEqual(ModelStubs.paddingtonStation, stationsModel.station(forLineGroupID: "940GZZLUPAH-circle,hammersmith-city"))
        XCTAssertEqual(ModelStubs.paddingtonStation, stationsModel.station(forLineGroupID: "910GPADTON-elizabeth"))
        
        // High barnet
        XCTAssertEqual("High Barnet", stationsModel.station(forLineGroupID: "940GZZLUHBT-northern")?.name)
    }
    
    func testFilteredStationsByPartialName() {
        let stationsModel = StationsModel(stationsClient: StubStationsClient(), fetchImmediately: true)
        
        func assertStationMatchesKingsCross(forPartialText partialName: String,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
            XCTAssertTrue(stationsModel.filteredStations(matchingName: partialName).contains(ModelStubs.kingsCrossStation),
                          "Partial text '\(partialName)' does not match Kings Cross",
                          file: file,
                          line: line)
        }
        
        assertStationMatchesKingsCross(forPartialText: "King's Cross & St Pancras International")
        assertStationMatchesKingsCross(forPartialText: "Kings Cross St Pancras International")
        assertStationMatchesKingsCross(forPartialText: "Kin")
        assertStationMatchesKingsCross(forPartialText: "ternational")
        assertStationMatchesKingsCross(forPartialText: "kings cross")
        assertStationMatchesKingsCross(forPartialText: "kings cross st pancras")
    }
    
}



