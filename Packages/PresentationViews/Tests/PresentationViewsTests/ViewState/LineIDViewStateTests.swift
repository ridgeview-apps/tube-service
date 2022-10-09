import Models
import XCTest

@testable import PresentationViews

final class LineIDViewStateTests: XCTestCase {

    func testLineUDShortNames() {
        XCTAssertEqual("Bakerloo", LineID.bakerloo.name)
        XCTAssertEqual("Central", LineID.central.name)
        XCTAssertEqual("Circle", LineID.circle.name)
        XCTAssertEqual("District", LineID.district.name)
        XCTAssertEqual("Elizabeth", LineID.elizabeth.name)
        XCTAssertEqual("Hammersmith & City", LineID.hammersmithAndCity.name)
        XCTAssertEqual("Jubilee", LineID.jubilee.name)
        XCTAssertEqual("Metropolitan", LineID.metropolitan.name)
        XCTAssertEqual("Northern", LineID.northern.name)
        XCTAssertEqual("Piccadilly", LineID.piccadilly.name)
        XCTAssertEqual("Victoria", LineID.victoria.name)
        XCTAssertEqual("Waterloo & City", LineID.waterlooAndCity.name)
        XCTAssertEqual("DLR", LineID.dlr.name)
        XCTAssertEqual("Overground", LineID.overground.name)
        XCTAssertEqual("Tram", LineID.tram.name)
    }
    
    func testLineIDLongNames() {
        XCTAssertEqual("Bakerloo line", LineID.bakerloo.longName)
        XCTAssertEqual("Central line", LineID.central.longName)
        XCTAssertEqual("Circle line", LineID.circle.longName)
        XCTAssertEqual("District line", LineID.district.longName)
        XCTAssertEqual("Elizabeth line", LineID.elizabeth.longName)
        XCTAssertEqual("Hammersmith & City line", LineID.hammersmithAndCity.longName)
        XCTAssertEqual("Jubilee line", LineID.jubilee.longName)
        XCTAssertEqual("Metropolitan line", LineID.metropolitan.longName)
        XCTAssertEqual("Northern line", LineID.northern.longName)
        XCTAssertEqual("Piccadilly line", LineID.piccadilly.longName)
        XCTAssertEqual("Victoria line", LineID.victoria.longName)
        XCTAssertEqual("Waterloo & City line", LineID.waterlooAndCity.longName)
        XCTAssertEqual("DLR", LineID.dlr.longName)
        XCTAssertEqual("Overground", LineID.overground.longName)
        XCTAssertEqual("Tram", LineID.tram.longName)
    }
}
