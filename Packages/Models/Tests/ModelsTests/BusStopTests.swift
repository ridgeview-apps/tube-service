import Foundation
import Testing

@testable import Models

struct BusStopTests {

    private let origin = LocationCoordinate(lat: 51.5, lon: -0.1)

    @Test
    func stopsSharingAStopAreaAreOnePlace() {
        let stops = [
            nearbyStop("A", name: "Holloway Road", area: "490G1", metresNorth: 0),
            nearbyStop("B", name: "Holloway Road / Nag's Head", area: "490G1", metresNorth: 30)
        ]

        let places = stops.groupedByPlace()

        #expect(places.map { $0.stops.map(\.stop.id) } == [["A", "B"]])
    }

    @Test
    func stopsWithTheSameNameAndNoStopAreaAreOnePlace() {
        let stops = [
            nearbyStop("A", name: "King's Cross Station", area: nil, metresNorth: 0),
            nearbyStop("B", name: "King's Cross Station", area: nil, metresNorth: 40)
        ]

        let places = stops.groupedByPlace()

        #expect(places.map { $0.stops.map(\.stop.id) } == [["A", "B"]])
    }

    @Test
    func stopsInTheSameStopAreaFarApartAreSeparatePlaces() {
        let stops = [
            nearbyStop("A", name: "Longland Drive", area: "490G1", metresNorth: 0),
            nearbyStop("B", name: "Longland Drive", area: "490G1", metresNorth: 300)
        ]

        let places = stops.groupedByPlace()

        #expect(places.map { $0.stops.map(\.stop.id) } == [["A"], ["B"]])
    }

    @Test
    func unrelatedStopsCloseTogetherAreSeparatePlaces() {
        let stops = [
            nearbyStop("A", name: "Swinton Street", area: "490G1", metresNorth: 0),
            nearbyStop("B", name: "Acton Street", area: "490G2", metresNorth: 20)
        ]

        let places = stops.groupedByPlace()

        #expect(places.count == 2)
    }

    @Test
    func placesAreNamedAfterAndOrderedByTheirNearestStop() {
        let stops = [
            nearbyStop("far", name: "Far Road", area: nil, metresNorth: 500),
            nearbyStop("near", name: "Near Road / Corner", area: "490G1", metresNorth: 120),
            nearbyStop("nearest", name: "Near Road", area: "490G1", metresNorth: 100)
        ]

        let places = stops.groupedByPlace()

        #expect(places.map(\.name) == ["Near Road", "Far Road"])
        #expect(places.map(\.id) == ["nearest", "far"])
        #expect(places.first?.distance == 100)
    }

    @Test
    func databaseReturnsTheNearestStopsUpToTheLimit() {
        let database = BusStopDatabase(stops: [
            stop("far", metresNorth: 300),
            stop("nearest", metresNorth: 10),
            stop("near", metresNorth: 100)
        ])

        let nearby = database.nearbyStops(to: origin, limit: 2)

        #expect(nearby.map(\.stop.id) == ["nearest", "near"])
    }

    @Test
    func oppositeStopIsTheOtherStopAtAPlaceOfTwo() {
        let northbound = stop("north", name: "Holloway Road", metresNorth: 0)
        let southbound = stop("south", name: "Holloway Road", metresNorth: 30)
        let database = BusStopDatabase(stops: [northbound, southbound, stop("other", name: "Other", metresNorth: 10)])

        #expect(database.oppositeStop(of: northbound)?.id == "south")
        #expect(database.oppositeStop(of: southbound)?.id == "north")
    }

    @Test
    func aStopAloneHasNoOppositeStop() {
        let lone = stop("lone", name: "Swan Lane", metresNorth: 0)
        let database = BusStopDatabase(stops: [lone, stop("other", name: "Other", metresNorth: 20)])

        #expect(database.oppositeStop(of: lone) == nil)
    }

    @Test
    func aPlaceOfMoreThanTwoStopsHasNoOppositeStop() {
        let first = stop("A", name: "King's Cross Station", metresNorth: 0)
        let database = BusStopDatabase(stops: [
            first,
            stop("B", name: "King's Cross Station", metresNorth: 20),
            stop("C", name: "King's Cross Station", metresNorth: 40)
        ])

        #expect(database.oppositeStop(of: first) == nil)
    }

    // MARK: - Helpers

    private func nearbyStop(_ id: String, name: String, area: String?, metresNorth: Double) -> NearbyBusStop {
        NearbyBusStop(stop(id, name: name, area: area, metresNorth: metresNorth), distance: metresNorth)
    }

    private func stop(_ id: String, name: String = "Stop", area: String? = nil, metresNorth: Double) -> BusStop {
        BusStop(
            id: id,
            name: name,
            letter: nil,
            towards: nil,
            stopAreaID: area,
            location: LocationCoordinate(lat: origin.lat + metresNorth / 111_195, lon: origin.lon),
            routes: []
        )
    }
}
