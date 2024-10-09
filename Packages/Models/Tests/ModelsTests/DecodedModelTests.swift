import Foundation
import Testing

@testable import Models
@testable import ModelStubs

struct ModelDecoderTests {

    @Test
    func decodedLineStatuses() throws {
        let lineStatusesToday = try decodeRawJSONString(lineStatusesTodayJSON, asType: [Line].self)
        let lineStatusesFuture = try decodeRawJSONString(lineStatusesFutureJSON, asType: [Line].self)
        let lineStatusGood = try decodeRawJSONString(lineStatusGoodServiceJSON, asType: Line.self)
        let lineStatusDisrupted = try decodeRawJSONString(lineStatusDisruptedJSON, asType: Line.self)
        
        #expect(lineStatusesToday != nil)
        #expect(lineStatusesFuture != nil)
        #expect(lineStatusGood != nil)
        #expect(lineStatusDisrupted != nil)
    }
    
    @Test
    func decodedArrivalPredictions() throws {
        let singleLineArrivals = try decodeRawJSONString(northernLineArrivalsJSON, asType: [ArrivalPrediction].self)
        let multiLineArrivals = try decodeRawJSONString(hammerDistrictAndCircleArrivalsJSON, asType: [ArrivalPrediction].self)
        
        #expect(singleLineArrivals != nil)
        #expect(multiLineArrivals != nil)
    }
    
    @Test
    func decodedArrivalDepartures() throws {
        let elizabethLineArrivals = try decodeRawJSONString(elizabethLineArrivalsJSON, asType: [ArrivalDeparture].self)
        
        #expect(elizabethLineArrivals != nil)
    }
    
    @Test
    func decodedDisruptionPoints() throws {
        let disruptedPoints = try decodeRawJSONString(disruptedStationsJSON, asType: [DisruptedPoint].self)
        
        #expect(disruptedPoints != nil)
    }
    
    @Test
    func decodedTubeJourneyItinerary() throws {
        let journey = try decodeRawJSONString(journeyByTubeJSON, asType: Journey.self)
        
        #expect(journey != nil)
        
        #expect(journey.legs?[0].modeID == .walking)
        
        #expect(journey.legs?[1].trainLineID == .piccadilly)
        #expect(journey.legs?[1].modeID == .tube)
        #expect(journey.legs?[1].stopPoints[0].name == "Russell Square Underground Station")
        #expect(journey.legs?[1].stopPoints[1].name == "Holborn Underground Station")
        #expect(journey.legs?[1].stopPoints[2].name == "Covent Garden Underground Station")
        #expect(journey.legs?[1].departurePoint?.commonName == "King's Cross St. Pancras Underground Station")
        #expect(journey.legs?[1].arrivalPoint?.commonName == "Leicester Square Underground Station")
    }
    
    @Test
    func decodedSystemStatus() throws {
        let systemStatusOK = try decodeRawJSONString(systemStatusOKJSON, asType: SystemStatus.self)
        let systemStatusOutage = try decodeRawJSONString(systemStatusOutageJSON, asType: SystemStatus.self)
        let systemStatusResolved = try decodeRawJSONString(systemStatusResolvedJSON, asType: SystemStatus.self)
        
        #expect(systemStatusOK != nil)
        #expect(systemStatusOutage != nil)
        #expect(systemStatusResolved != nil)
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
