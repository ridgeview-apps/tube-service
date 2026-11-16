import Models
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
        let nearestStations = Self.stations.nearestStations(to: pentonville)

        // Then
        #expect(nearestStations.prefix(3).map(\.station.id) == ["940GZZLUAGL", "HUBKGX", "940GZZLURSQ"])
        #expect(nearestStations[0].distance.isApproximatelyEqual(to: 489.53, plusOrMinus: 0.1))
        #expect(nearestStations[1].distance.isApproximatelyEqual(to: 687.13, plusOrMinus: 0.1))
        #expect(nearestStations[2].distance.isApproximatelyEqual(to: 1205.0274, plusOrMinus: 0.1))
    }

    @Test
    func nearestStationsToNorthFinchley() throws {
        // Given
        let northFinchleyHighRoad = LocationCoordinate(lat: 51.618227, lon: -0.176675)

        // When
        let nearestStations = Self.stations.nearestStations(to: northFinchleyHighRoad)

        // Then
        #expect(nearestStations.prefix(4).map(\.station.id) == ["940GZZLUWOP", "940GZZLUWFN", "940GZZLUTAW", "940GZZLUFYC"])
        #expect(nearestStations[0].distance.isApproximatelyEqual(to: 606.16, plusOrMinus: 0.1))
        #expect(nearestStations[1].distance.isApproximatelyEqual(to: 1270.45, plusOrMinus: 0.1))
        #expect(nearestStations[2].distance.isApproximatelyEqual(to: 1387.44, plusOrMinus: 0.1))
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

    // Given in no particular order, so the tests prove the sorting
    private static let stations = [
        makeStation("940GZZLUFYC", lat: 51.600921, lon: -0.192527),
        makeStation("940GZZLURSQ", lat: 51.523073, lon: -0.124285),
        makeStation("940GZZLUWOP", lat: 51.618014, lon: -0.18542),
        makeStation("HUBKGX", lat: 51.530663, lon: -0.123194),
        makeStation("940GZZLUTAW", lat: 51.630597, lon: -0.17921),
        makeStation("940GZZLUAGL", lat: 51.53184, lon: -0.10635),
        makeStation("940GZZLUWFN", lat: 51.609426, lon: -0.188362)
    ]

    private static func makeStation(_ id: String, lat: Double, lon: Double) -> Station {
        Station(id: id, icsCode: "1000000", name: id, location: LocationCoordinate(lat: lat, lon: lon), lineGroups: [])
    }

    private func makeModel(
        locationManager: StubLocationManager = StubLocationManager(),
        geocoder: ReverseGeocoderType = StubReverseGeocoder()
    ) -> (StubLocationManager, LocationDataStore) {
        let tflAPI = StubTflAPIClient()
        let stations = StationsDataStore.stub(tflAPI: tflAPI)
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

    func locationName(for location: CLLocation) async throws -> LocationName? {
        callCount += 1

        do {
            if delayNanoseconds > 0 {
                try await Task.sleep(nanoseconds: delayNanoseconds)
            }
            return nil
        } catch is CancellationError {
            cancellationCount += 1
            throw CancellationError()
        }
    }
}
