import XCTest

@testable import Models

final class ModelDecoderTests: XCTestCase {

    func testDecodedLineStatuses() throws {
        let lineStatusesToday = decodeRawJSONString(lineStatusesTodayJSON, asType: [Line].self)
        let lineStatusesFuture = decodeRawJSONString(lineStatusesFutureJSON, asType: [Line].self)
        let lineStatusGood = decodeRawJSONString(lineStatusGoodServiceJSON, asType: Line.self)
        let lineStatusDisrupted = decodeRawJSONString(lineStatusDisruptedJSON, asType: Line.self)
        
        XCTAssertNotNil(lineStatusesToday)
        XCTAssertNotNil(lineStatusesFuture)
        XCTAssertNotNil(lineStatusGood)
        XCTAssertNotNil(lineStatusDisrupted)
    }
    
    func testDecodedArrivalPredictions() throws {
        let singleLineArrivals = decodeRawJSONString(northernLineArrivalsJSON, asType: [ArrivalPrediction].self)
        let multiLineArrivals = decodeRawJSONString(hammerDistrictAndCircleArrivalsJSON, asType: [ArrivalPrediction].self)
        
        XCTAssertNotNil(singleLineArrivals)
        XCTAssertNotNil(multiLineArrivals)
    }
    
    func testDecodedArrivalDepartures() throws {
        let elizabethLineArrivals = decodeRawJSONString(elizabethLineArrivalsJSON, asType: [ArrivalDeparture].self)
        
        XCTAssertNotNil(elizabethLineArrivals)
    }
}

private extension ModelDecoderTests {
    
    private func decodeRawJSONString<D: Decodable>(_ rawJSON: String, asType type: D.Type) -> D? {
        guard let jsonData = rawJSON.data(using: .utf8),
              let decodedValue = try? JSONDecoder.defaultModelDecoder.decode(type, from: jsonData) else {
            return nil
        }
        
        return decodedValue
    }
}
