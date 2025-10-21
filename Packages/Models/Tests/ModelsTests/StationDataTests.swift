import Testing

@testable import Models

struct StationDataTests {

    @Test
    func stationCount() throws {
        #expect(Station.all.count == 457)
        #expect(Station.allNationalRail.count == 2585)
    }
}
