@testable import DataStores

import Models
import XCTest

final class StationsModelTests: XCTestCase {

    @MainActor
    func testLoadStationsByID() {
        let stationsModel = StationsDataStore(transportAPI: StubTransportAPIClient())
        
        XCTAssertEqual(ModelStubs.kingsCrossStation, stationsModel.station(forID: "HUBKGX"))
        XCTAssertEqual(ModelStubs.paddingtonStation, stationsModel.station(forID: "HUBPAD"))
        XCTAssertEqual(ModelStubs.highBarnetStation, stationsModel.station(forID: "940GZZLUHBT"))
    }
    
    @MainActor
    func testLoadStationsByLineGroup() {
        let stations = StationsDataStore(transportAPI: StubTransportAPIClient())
        
        // King's X
        XCTAssertEqual(ModelStubs.kingsCrossStation, stations.station(forLineGroupID: "940GZZLUKSX-circle,hammersmith-city,metropolitan"))
        XCTAssertEqual(ModelStubs.kingsCrossStation, stations.station(forLineGroupID: "940GZZLUKSX-northern"))
        XCTAssertEqual(ModelStubs.kingsCrossStation, stations.station(forLineGroupID: "940GZZLUKSX-piccadilly"))
        XCTAssertEqual(ModelStubs.kingsCrossStation, stations.station(forLineGroupID: "940GZZLUKSX-victoria"))
        
        // Paddington
        XCTAssertEqual(ModelStubs.paddingtonStation, stations.station(forLineGroupID: "940GZZLUPAC-bakerloo"))
        XCTAssertEqual(ModelStubs.paddingtonStation, stations.station(forLineGroupID: "940GZZLUPAC-circle,district"))
        XCTAssertEqual(ModelStubs.paddingtonStation, stations.station(forLineGroupID: "940GZZLUPAH-circle,hammersmith-city"))
        XCTAssertEqual(ModelStubs.paddingtonStation, stations.station(forLineGroupID: "910GPADTON-elizabeth"))
        
        // High barnet
        XCTAssertEqual("High Barnet", stations.station(forLineGroupID: "940GZZLUHBT-northern")?.name)
    }
    
    @MainActor
    func testFilteredStationsByPartialName() {
        let stations = StationsDataStore(transportAPI: StubTransportAPIClient())
        
        func assertStationMatchesKingsCross(forPartialText partialName: String,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
            XCTAssertTrue(stations.filteredStations(matchingName: partialName).contains(ModelStubs.kingsCrossStation),
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
