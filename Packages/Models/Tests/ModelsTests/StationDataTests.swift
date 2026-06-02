import Testing

@testable import Models

struct StationDataTests {

    @Test
    func stationCount() throws {
        #expect(Station.allLondonTrains.count == 457)
        #expect(Station.allNationalRail.count == 2585)
    }
}
