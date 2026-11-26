import Models
import Testing

@testable import PresentationViews

struct BusArrivalViewStateTests {

    private let stop = BusStop(
        id: "490000129R",
        name: "King's Cross Station",
        letter: "R",
        towards: "Euston",
        stopAreaID: nil,
        location: LocationCoordinate(lat: 51.53047, lon: -0.12169),
        routes: ["30", "73", "N73"]
    )

    @Test
    func boardListsEveryRouteSoonestFirst() {
        let arrivals = [
            makeArrival("later", route: "30", timeToStation: 600),
            makeArrival("soonest", route: "73", timeToStation: 40),
            makeArrival("sooner", route: "N73", timeToStation: 300)
        ]

        let boardStates = arrivals.toBoardStates(at: stop, route: nil)

        #expect(boardStates.map { $0.cellItems.map(\.id) } == [["soonest-1", "sooner-2", "later-3"]])
        #expect(boardStates.first?.cellItems.map(\.numberLabel.text) == ["73", "N73", "30"])
        #expect(boardStates.first?.style == .bus)
    }

    @Test
    func boardShowsOnlyTheSelectedRoute() {
        let arrivals = [
            makeArrival("a", route: "30", timeToStation: 60),
            makeArrival("b", route: "73", timeToStation: 120),
            makeArrival("c", route: "30", timeToStation: 180)
        ]

        let boardStates = arrivals.toBoardStates(at: stop, route: "30")

        #expect(boardStates.map { $0.cellItems.map(\.id) } == [["a-1", "c-2"]])
    }

    @Test
    func noArrivalsGiveNoBoard() {
        let arrivals = [makeArrival("a", route: "30", timeToStation: 60)]

        #expect(arrivals.toBoardStates(at: stop, route: "73").isEmpty)
        #expect([BusArrival]().toBoardStates(at: stop, route: nil).isEmpty)
    }

    @Test
    func boardIsTitledByTheStopLetterOrElseItsName() {
        let arrivals = [makeArrival("a", route: "30", timeToStation: 60)]
        let stopWithoutLetter = BusStop(
            id: "490013766E",
            name: "Totteridge & Whetstone Station",
            letter: nil,
            towards: "Barnet",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.6302, lon: -0.1791),
            routes: ["34"]
        )

        #expect(arrivals.toBoardStates(at: stop, route: nil).first?.platformName == "Stop R")
        #expect(arrivals.toBoardStates(at: stopWithoutLetter, route: nil).first?.platformName == "Totteridge & Whetstone Station")
    }

    @Test
    func routesAreTheStopsThenAnyOthersInTheArrivals() {
        let arrivals = [
            makeArrival("a", route: "73", timeToStation: 60),
            makeArrival("b", route: "N205", timeToStation: 120),
            makeArrival("c", route: "205", timeToStation: 180),
            makeArrival("d", route: "205", timeToStation: 240)
        ]

        #expect(arrivals.routes(at: stop) == ["30", "73", "N73", "205", "N205"])
    }

    private func makeArrival(_ id: String, route: String, timeToStation: Int) -> BusArrival {
        BusArrival(
            id: id,
            lineName: route,
            destinationName: "Oxford Circus",
            towards: "Euston",
            timeToStation: timeToStation,
            naptanID: "490000129R",
            platformName: "R"
        )
    }
}
