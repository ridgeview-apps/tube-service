import Foundation
import Models

public enum ModelStubs {} // Namespace

private extension ModelStubs {
    
    static func decodedValue<D: Decodable>(for rawJSON: String) -> D {
        guard let jsonData = rawJSON.data(using: .utf8),
              let decodedValue = try? JSONDecoder.defaultModelDecoder.decode(D.self, from: jsonData) else {
            fatalError("Unable to decode JSON data to object of type \(D.self) - please check your JSON is valid for this object type.")
        }
        
        return decodedValue
    }
}


// MARK: - Arrival stubs

public extension ModelStubs {
    // Elizabeth line
    static var elizabethLineBothPlatforms: [ArrivalDeparture] {
        decodedValue(for: elizabethLineArrivalsJSON)
    }
    
    static var elizabethLineArrivalsPlatformA: [ArrivalDeparture] {
        elizabethLineBothPlatforms.filter { $0.platformName == "Platform A" }
    }
    
    static var elizabethLineArrivalsPlatformB: [ArrivalDeparture] {
        elizabethLineBothPlatforms.filter { $0.platformName == "Platform B" }
    }
    
    static var elizabethLineArrivalsWithDuplicates: [ArrivalDeparture] {
        decodedValue(for: elizabethLineArrivalsWithDuplicatesJSON)
    }
    
    
    // Northern line (single tube-line platforms)
    static var northernLineBothPlatforms: [ArrivalPrediction] {
        decodedValue(for: northernLineArrivalsJSON)
    }
    
    static var northernLineNorthboundArrivals: [ArrivalPrediction] {
        northernLineBothPlatforms.filter { $0.platformName == "Northbound - Platform 7" }
    }
    
    static var northernLineSouthboundArrivals: [ArrivalPrediction] {
        northernLineBothPlatforms.filter { $0.platformName == "Southbound - Platform 8" }
    }
    
    // Hammersmith, District & Circle (multi tube-line platforms)
    static var hammerDistrictAndCircleBothPlatforms: [ArrivalPrediction] {
        decodedValue(for: hammerDistrictAndCircleArrivalsJSON)
    }
    
    static var hammerDistrictAndCircleEastboundArrivals: [ArrivalPrediction] {
        hammerDistrictAndCircleBothPlatforms.filter { $0.platformName == "Eastbound - Platform 2" }
    }
    
    static var hammerDistrictAndCircleWestboundArrivals: [ArrivalPrediction] {
        hammerDistrictAndCircleBothPlatforms.filter { $0.platformName == "Westbound - Platform 1" }
    }
}


// MARK: - Line status stubs

public extension ModelStubs {
    static var lineStatusesToday: [Line] { decodedValue(for: lineStatusesTodayJSON) }
    
    static var lineStatusesFuture: [Line] { decodedValue(for: lineStatusesFutureJSON) }
    
    static var lineStatusGoodService: Line { decodedValue(for: lineStatusGoodServiceJSON) }
    
    static var lineStatusDisrupted: Line { decodedValue(for: lineStatusDisruptedJSON) }
    
    static var lineStatusDisruptedDuplicates: Line { decodedValue(for: lineStatusDisruptedDuplicatesJSON)}
}


// MARK: - Stations

public extension ModelStubs {
    static var stations: [Station] { Station.all }
    static var nationRailStopPoints: [StopPoint] { Station.allNationalRail }
    
    static var angelStation: Station { stations.first { $0.id == "940GZZLUAGL" }! }
    static var eastFinchleyStation: Station { stations.first { $0.id == "940GZZLUEFY" }! }
    static var finchleyCentralStation: Station { stations.first { $0.id == "940GZZLUFYC" }! }
    static var highBarnetStation: Station { stations.first { $0.id == "940GZZLUHBT" }! }
    static var kingsCrossStation: Station { stations.first { $0.id == "HUBKGX" }! }
    static var paddingtonStation: Station { stations.first { $0.id == "HUBPAD" }! }
    static var russellSquareStation: Station { stations.first { $0.id == "940GZZLURSQ" }! }
    static var totteridgeAndWhetstoneStation: Station { stations.first { $0.id == "940GZZLUTAW" }! }
    static var westFinchleyStation: Station { stations.first { $0.id == "940GZZLUWFN" }! }
    static var woodsideParkStation: Station { stations.first { $0.id == "940GZZLUWOP" }! }
    
    static var twickenhamRailStation: StopPoint { nationRailStopPoints.first { $0.icsCode == "1001300" }! }
    static var oakleighParkRailStation: StopPoint { nationRailStopPoints.first { $0.icsCode == "1001218" }! }
}


// MARK: - Disrupted points

public extension ModelStubs {
    
    static var disruptedStations: [DisruptedPoint] { decodedValue(for: disruptedStationsJSON) }
}


// MARK: - Journey planner

public extension ModelStubs {
    
    static var journeyByBike: Journey { decodedValue(for: journeyByBikeJSON ) }
    static var journeyByBoat: Journey { decodedValue(for: journeyByBoatJSON ) }
    static var journeyByBusLong: Journey { decodedValue(for: journeyByBusLongJSON ) }
    static var journeyByBusShort: Journey { decodedValue(for: journeyByBusShortJSON) }
    static var journeyByCableCar: Journey { decodedValue(for: journeyByCableCarJSON) }
    static var journeyByNationalRail: Journey { decodedValue(for: journeyByNationalRailJSON) }
    static var journeyByOverground: Journey { decodedValue(for: journeyByOvergroundJSON) }
    static var journeyByTube: Journey { decodedValue(for: journeyByTubeJSON) }
    static var journeyByWalking: Journey { decodedValue(for: journeyByWalkingJSON) }
    static var journeyWithLongDisruptionMessage: Journey { decodedValue(for: journeyWithLongDisruptionMessageJSON) }
    
    static var journeyWithLongTitleName: Journey { decodedValue(for: journeyWithLongTitleNameJSON) }
    
    static var journeyItineraryKingsXToWaterloo: JourneyItinerary { decodedValue(for: journeyItineraryKingsXToWaterlooJSON) }
}


// MARK: - System status

public extension ModelStubs {
    
    static var systemStatusOK: SystemStatus { decodedValue(for: systemStatusOKJSON) }
    static var systemStatusOutage: SystemStatus { decodedValue(for: systemStatusOutageJSON)}
    static var systemStatusResolved: SystemStatus { decodedValue(for: systemStatusResolvedJSON)}
}
