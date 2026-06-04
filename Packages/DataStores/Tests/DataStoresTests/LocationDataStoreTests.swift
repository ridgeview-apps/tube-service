import Models
import ModelStubs
import Testing
import CoreLocation

@testable import DataStores

@MainActor
struct LocationDataStoreTests {

    @Test
    func nearestStationsToPentonville() throws {
        // Given
        let pentonville = LocationCoordinate(lat: 51.531504, lon: -0.113384)

        // When
        let nearestStations = Station.allLondonTrains.nearestStations(to: pentonville)

        // Then
        #expect(nearestStations[0].station == ModelStubs.angelStation)
        #expect(nearestStations[0].distance.isApproximatelyEqual(to: 518.97, plusOrMinus: 0.1))
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
        let nearestStations = Station.allLondonTrains.nearestStations(to: northFinchleyHighRoad)

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

    @Test
    func promptForPermissionsRequestsAuthorizationAndSetsDetectingState() {
        // Given
        let (locationManager, model) = makeModel()

        // When
        model.promptForPermissions()

        // Then
        #expect(locationManager.requestWhenInUseAuthorizationCallCount == 1)
        if case .detecting = model.detectionState {
            #expect(Bool(true))
        } else {
            Issue.record("Expected detecting state")
        }
    }

    @Test
    func refreshCurrentLocationDoesNothingWhenUnauthorized() {
        // Given
        let locationManager = StubLocationManager()
        locationManager.authorizationStatus = .denied
        let (_, model) = makeModel(locationManager: locationManager)

        // When
        model.refreshCurrentLocation()

        // Then
        #expect(locationManager.requestLocationCallCount == 0)
    }

    private func makeModel(
        locationManager: StubLocationManager = StubLocationManager(),
        geocoder: ReverseGeocoderType = StubReverseGeocoder()
    ) -> (StubLocationManager, LocationDataStore) {
        let transportAPI = StubTransportAPIClient()
        let stations = StationsDataStore.stub(transportAPI: transportAPI)
        let model = LocationDataStore(locationManager: locationManager, stations: stations, geocoder: geocoder)
        return (locationManager, model)
    }
}

private enum TestError: Error {
    case expected
}

private final class StubReverseGeocoder: ReverseGeocoderType, @unchecked Sendable {
    private(set) var callCount = 0
    private(set) var cancellationCount = 0
    private let delayNanoseconds: UInt64

    init(delayNanoseconds: UInt64 = 0) {
        self.delayNanoseconds = delayNanoseconds
    }

    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark] {
        callCount += 1

        do {
            if delayNanoseconds > 0 {
                try await Task.sleep(nanoseconds: delayNanoseconds)
            }
            return []
        } catch is CancellationError {
            cancellationCount += 1
            throw CancellationError()
        }
    }
}
