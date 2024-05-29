import Models
import XCTest

@testable import PresentationViews

final class LineIDViewStateTests: XCTestCase {

    func testLineIDShortNames() {
        XCTAssertEqual("Bakerloo", TrainLineID.bakerloo.name)
        XCTAssertEqual("Central", TrainLineID.central.name)
        XCTAssertEqual("Circle", TrainLineID.circle.name)
        XCTAssertEqual("District", TrainLineID.district.name)
        XCTAssertEqual("Elizabeth", TrainLineID.elizabeth.name)
        XCTAssertEqual("Hammersmith & City", TrainLineID.hammersmithAndCity.name)
        XCTAssertEqual("Jubilee", TrainLineID.jubilee.name)
        XCTAssertEqual("Metropolitan", TrainLineID.metropolitan.name)
        XCTAssertEqual("Northern", TrainLineID.northern.name)
        XCTAssertEqual("Piccadilly", TrainLineID.piccadilly.name)
        XCTAssertEqual("Victoria", TrainLineID.victoria.name)
        XCTAssertEqual("Waterloo & City", TrainLineID.waterlooAndCity.name)
        XCTAssertEqual("DLR", TrainLineID.dlr.name)
        XCTAssertEqual("Overground", TrainLineID.overground.name)
        XCTAssertEqual("Tram", TrainLineID.tram.name)
    }
    
    func testLineIDLongNames() {
        XCTAssertEqual("Bakerloo line", TrainLineID.bakerloo.longName)
        XCTAssertEqual("Central line", TrainLineID.central.longName)
        XCTAssertEqual("Circle line", TrainLineID.circle.longName)
        XCTAssertEqual("District line", TrainLineID.district.longName)
        XCTAssertEqual("Elizabeth line", TrainLineID.elizabeth.longName)
        XCTAssertEqual("Hammersmith & City line", TrainLineID.hammersmithAndCity.longName)
        XCTAssertEqual("Jubilee line", TrainLineID.jubilee.longName)
        XCTAssertEqual("Metropolitan line", TrainLineID.metropolitan.longName)
        XCTAssertEqual("Northern line", TrainLineID.northern.longName)
        XCTAssertEqual("Piccadilly line", TrainLineID.piccadilly.longName)
        XCTAssertEqual("Victoria line", TrainLineID.victoria.longName)
        XCTAssertEqual("Waterloo & City line", TrainLineID.waterlooAndCity.longName)
        XCTAssertEqual("DLR", TrainLineID.dlr.longName)
        XCTAssertEqual("Overground", TrainLineID.overground.longName)
        XCTAssertEqual("Tram", TrainLineID.tram.longName)
    }
}
