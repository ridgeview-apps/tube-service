import Foundation

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
    static var stations: [Station] { Station.allValues() }
    
    static var kingsCrossStation: Station { stations.first { $0.id == "HUBKGX" }! }
    static var paddingtonStation: Station { stations.first { $0.id == "HUBPAD" }! }
    static var highBarnetStation: Station { stations.first { $0.id == "940GZZLUHBT" }! }
}
