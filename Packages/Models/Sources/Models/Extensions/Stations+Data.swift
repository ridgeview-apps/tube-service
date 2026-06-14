import Foundation

public extension Station {

    static let allLondonTrains: [Station] = {
        guard let url = Bundle.module.url(forResource: "londonStations", withExtension: "json"),
            let jsonData = try? Data(contentsOf: url),
            let decodedValue = try? JSONDecoder.tflModelDecoder.decode([Station].self, from: jsonData)
        else {
            return []
        }

        return decodedValue
    }()

    static let allNationalRail: [StopPoint] = {
        guard let url = Bundle.module.url(forResource: "nationalRailStations", withExtension: "json"),
            let jsonData = try? Data(contentsOf: url),
            let decodedValue = try? JSONDecoder.tflModelDecoder.decode([StopPoint].self, from: jsonData)
        else {
            return []
        }

        return decodedValue
    }()
}
