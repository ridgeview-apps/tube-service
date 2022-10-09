import XCTest

@testable import Models

final class StationDataTests: XCTestCase {

    func testStationCount() throws {
        XCTAssertEqual(376, Station.allValues().count)
    }
}
