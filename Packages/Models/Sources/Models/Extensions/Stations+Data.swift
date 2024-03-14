import Foundation

public extension Station {

    static func allValues() -> [Station] {
        let jsonDecoder = JSONDecoder.defaultModelDecoder
        
        guard let jsonData = allStationsRawJSON.data(using: .utf8),
              let decodedValue = try? jsonDecoder.decode([Station].self, from: jsonData) else {
            return []
        }
        
        return decodedValue
    }
    
    static func nationRailStopPoints() -> [StopPoint] {
        let jsonDecoder = JSONDecoder.defaultModelDecoder
        
        guard let jsonData = nationalRailStations.data(using: .utf8),
              let decodedValue = try? jsonDecoder.decode([StopPoint].self, from: jsonData) else {
            return []
        }
        
        return decodedValue
    }
}
