import Testing

@testable import Models

struct StationDataTests {

    @Test
    func stationCount() throws {
        #expect(Station.all.count == 376)
        #expect(Station.allNationalRail.count == 2585)
    }
}
