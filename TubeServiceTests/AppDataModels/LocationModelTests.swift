@testable import Tube_Service

import Models
import DataClients
import XCTest

@MainActor
final class LocationModelTests: XCTestCase {
    
    func testNearestStation_Pentonville() throws {
        // Given
        let locationModel = LocationModel(locationManager: StubLocationClient())
        let pentonville = Location(lat: 51.531504, lon: -0.113384)
        
        // When
        let nearestStations = locationModel.nearestStations(to: pentonville, in: Station.allValues())
        
        // Then
        XCTAssertEqual(ModelStubs.angelStation, nearestStations[0].station)
        XCTAssertEqual(534.20, nearestStations[0].distance, accuracy: 0.1)
        XCTAssertEqual(ModelStubs.kingsCrossStation, nearestStations[1].station)
        XCTAssertEqual(687.13, nearestStations[1].distance, accuracy: 0.1)
        XCTAssertEqual(ModelStubs.russellSquareStation, nearestStations[2].station)
        XCTAssertEqual(1205.0274, nearestStations[2].distance, accuracy: 0.1)
    }
    
    func testNearestStation_NorthFinchley() throws {
        // Given
        let locationModel = LocationModel(locationManager: StubLocationClient())
        let northFinchleyHighRoad = Location(lat: 51.618227, lon: -0.176675)
        
        // When
        let nearestStations = locationModel.nearestStations(to: northFinchleyHighRoad, in: Station.allValues())
        
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
