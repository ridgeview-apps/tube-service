import XCTest

@testable import Models

final class ModelDecoderTests: XCTestCase {

    func testDecodedLineStatuses() throws {
        let lineStatusesToday = try decodeRawJSONString(lineStatusesTodayJSON, asType: [Line].self)
        let lineStatusesFuture = try decodeRawJSONString(lineStatusesFutureJSON, asType: [Line].self)
        let lineStatusGood = try decodeRawJSONString(lineStatusGoodServiceJSON, asType: Line.self)
        let lineStatusDisrupted = try decodeRawJSONString(lineStatusDisruptedJSON, asType: Line.self)
        
        XCTAssertNotNil(lineStatusesToday)
        XCTAssertNotNil(lineStatusesFuture)
        XCTAssertNotNil(lineStatusGood)
        XCTAssertNotNil(lineStatusDisrupted)
    }
    
    func testDecodedArrivalPredictions() throws {
        let singleLineArrivals = try decodeRawJSONString(northernLineArrivalsJSON, asType: [ArrivalPrediction].self)
        let multiLineArrivals = try decodeRawJSONString(hammerDistrictAndCircleArrivalsJSON, asType: [ArrivalPrediction].self)
        
        XCTAssertNotNil(singleLineArrivals)
        XCTAssertNotNil(multiLineArrivals)
    }
    
    func testDecodedArrivalDepartures() throws {
        let elizabethLineArrivals = try decodeRawJSONString(elizabethLineArrivalsJSON, asType: [ArrivalDeparture].self)
        
        XCTAssertNotNil(elizabethLineArrivals)
    }
    
    func testDecodedDisruptionPoints() throws {
        let disruptedPoints = try decodeRawJSONString(disruptedStationsJSON, asType: [DisruptedPoint].self)
        
        XCTAssertNotNil(disruptedPoints)
    }
}

enum ModelDecoderTestError: Error {
    case invalidJSON
}

private extension ModelDecoderTests {
    
    private func decodeRawJSONString<D: Decodable>(_ rawJSON: String, asType type: D.Type) throws -> D {
        guard let jsonData = rawJSON.data(using: .utf8) else {
            throw ModelDecoderTestError.invalidJSON
        }
        
        return try JSONDecoder.defaultModelDecoder.decode(type, from: jsonData)
    }
}
