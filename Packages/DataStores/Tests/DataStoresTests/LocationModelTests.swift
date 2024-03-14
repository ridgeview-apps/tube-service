@testable import DataStores

import Models
import XCTest

final class LocationDataStoreTests: XCTestCase {

    @MainActor
    func testNearestStation_Pentonville() throws {
        // Given
        let pentonville = LocationCoordinate(lat: 51.531504, lon: -0.113384)
        
        // When
        let nearestStations = Station.allValues().nearestStations(to: pentonville)
        
        // Then
        XCTAssertEqual(ModelStubs.angelStation, nearestStations[0].station)
        XCTAssertEqual(534.20, nearestStations[0].distance, accuracy: 0.1)
        XCTAssertEqual(ModelStubs.kingsCrossStation, nearestStations[1].station)
        XCTAssertEqual(687.13, nearestStations[1].distance, accuracy: 0.1)
        XCTAssertEqual(ModelStubs.russellSquareStation, nearestStations[2].station)
        XCTAssertEqual(1205.0274, nearestStations[2].distance, accuracy: 0.1)
    }
    
    @MainActor
    func testNearestStation_NorthFinchley() throws {
        // Given
        let northFinchleyHighRoad = LocationCoordinate(lat: 51.618227, lon: -0.176675)
        
        // When
        let nearestStations = Station.allValues().nearestStations(to: northFinchleyHighRoad)
        
        // Then
        XCTAssertEqual(ModelStubs.woodsideParkStation, nearestStations[0].station)
        XCTAssertEqual(606.16, nearestStations[0].distance, accuracy: 0.1)
        XCTAssertEqual(ModelStubs.westFinchleyStation, nearestStations[1].station)
        XCTAssertEqual(1270.45, nearestStations[1].distance, accuracy: 0.1)
        XCTAssertEqual(ModelStubs.totteridgeAndWhetstoneStation, nearestStations[2].station)
        XCTAssertEqual(1387.44, nearestStations[2].distance, accuracy: 0.1)
        XCTAssertEqual(ModelStubs.finchleyCentralStation, nearestStations[3].station)
        XCTAssertEqual(2216.50, nearestStations[3].distance, accuracy: 0.1)
    }
}
