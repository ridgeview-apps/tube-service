import Models
import ModelStubs
import Testing

@testable import DataStores

@MainActor
struct LocationDataStoreTests {

    @Test
    func nearestStationsToPentonville() throws {
        // Given
        let pentonville = LocationCoordinate(lat: 51.531504, lon: -0.113384)
        
        // When
        let nearestStations = Station.all.nearestStations(to: pentonville)
        
        // Then
        #expect(nearestStations[0].station == ModelStubs.angelStation)
        #expect(nearestStations[0].distance.isApproximatelyEqual(to: 534.20, plusOrMinus: 0.1))
        #expect(nearestStations[1].station == ModelStubs.kingsCrossStation)
        #expect(nearestStations[1].distance.isApproximatelyEqual(to: 687.13, plusOrMinus: 0.1))
        #expect(nearestStations[2].station == ModelStubs.russellSquareStation)
        #expect(nearestStations[2].distance.isApproximatelyEqual(to: 1205.0274, plusOrMinus: 0.1))
    }
    
    @Test
    func nearestStationsToNorthFinchley() throws {
        // Given
        let northFinchleyHighRoad = LocationCoordinate(lat: 51.618227, lon: -0.176675)
        
        // When
        let nearestStations = Station.all.nearestStations(to: northFinchleyHighRoad)
        
        // Then
        #expect(nearestStations[0].station == ModelStubs.woodsideParkStation)
        #expect(nearestStations[0].distance.isApproximatelyEqual(to: 606.16, plusOrMinus: 0.1))
        #expect(nearestStations[1].station == ModelStubs.westFinchleyStation)
        #expect(nearestStations[1].distance.isApproximatelyEqual(to: 1270.45, plusOrMinus: 0.1))
        #expect(nearestStations[2].station == ModelStubs.totteridgeAndWhetstoneStation)
        #expect(nearestStations[2].distance.isApproximatelyEqual(to: 1387.44, plusOrMinus: 0.1))
        #expect(nearestStations[3].station == ModelStubs.finchleyCentralStation)
        #expect(nearestStations[3].distance.isApproximatelyEqual(to: 2216.50, plusOrMinus: 0.1))
    }
}
