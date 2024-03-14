import XCTest

@testable import Models

final class StationDataTests: XCTestCase {

    func testStationCount() throws {
        XCTAssertEqual(376, Station.allValues().count)
        XCTAssertEqual(2585, Station.nationRailStopPoints().count)
    }
}
