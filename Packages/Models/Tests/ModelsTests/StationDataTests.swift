import XCTest

@testable import Models

final class StationDataTests: XCTestCase {

    func testStationCount() throws {
        XCTAssertEqual(376, Station.all.count)
        XCTAssertEqual(2585, Station.allNationalRail.count)
    }
}
