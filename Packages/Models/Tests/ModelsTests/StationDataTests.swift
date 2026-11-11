import Testing

@testable import Models

struct StationDataTests {

    @Test
    func stationCount() throws {
        #expect(Station.allLondonTrains.count == 457)
        #expect(Station.allNationalRail.count == 2585)
    }

    // The legacy favourites migration finds a station from the ATCO code before the first "-" in a line group ID,
    // so regenerated seed data must keep both of these true or some users' favourites will be lost.
    @Test
    func atcoCodesContainNoHyphens() {
        let atcoCodesWithHyphens = Station.allLondonTrains.flatMap(\.lineGroups).map(\.atcoCode).filter {
            $0.contains("-")
        }

        #expect(atcoCodesWithHyphens.isEmpty)
    }

    @Test
    func eachAtcoCodeBelongsToOneStation() {
        let stationIDsByAtcoCode = Dictionary(
            grouping: Station.allLondonTrains.flatMap { station in
                station.lineGroups.map { (atcoCode: $0.atcoCode, stationID: station.id) }
            },
            by: \.atcoCode
        )
        .mapValues { Set($0.map(\.stationID)) }

        let sharedAtcoCodes = stationIDsByAtcoCode.filter { $0.value.count > 1 }

        #expect(sharedAtcoCodes.isEmpty)
    }
}
