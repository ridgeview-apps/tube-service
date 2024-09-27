import XCTest

@testable import Models
@testable import ModelStubs

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
    
    func testDecodedTubeJourneyItinerary() throws {
        let journey = try decodeRawJSONString(journeyByTubeJSON, asType: Journey.self)
        
        XCTAssertNotNil(journey)
        
        XCTAssertEqual(journey.legs?[0].modeID, .walking)
        
        XCTAssertEqual(journey.legs?[1].trainLineID, .piccadilly)
        XCTAssertEqual(journey.legs?[1].modeID, .tube)
        XCTAssertEqual(journey.legs?[1].stopPoints[0].name, "Russell Square Underground Station")
        XCTAssertEqual(journey.legs?[1].stopPoints[1].name, "Holborn Underground Station")
        XCTAssertEqual(journey.legs?[1].stopPoints[2].name, "Covent Garden Underground Station")
        XCTAssertEqual(journey.legs?[1].departurePoint?.commonName, "King's Cross St. Pancras Underground Station")
        XCTAssertEqual(journey.legs?[1].arrivalPoint?.commonName, "Leicester Square Underground Station")
    }
    
    func testDecodedSystemStatus() throws {
        let systemStatusOK = try decodeRawJSONString(systemStatusOKJSON, asType: SystemStatus.self)
        let systemStatusOutage = try decodeRawJSONString(systemStatusOutageJSON, asType: SystemStatus.self)
        let systemStatusResolved = try decodeRawJSONString(systemStatusResolvedJSON, asType: SystemStatus.self)
        
        XCTAssertNotNil(systemStatusOK)
        XCTAssertNotNil(systemStatusOutage)
        XCTAssertNotNil(systemStatusResolved)
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
