import Foundation

public extension Station {

    static let allLondonTrains: [Station] = loadBundledJSON(named: "londonStations")

    static let allNationalRail: [StopPoint] = loadBundledJSON(named: "nationalRailStations")
}

extension Station {

    struct MissingBundledFile: Error {
        let name: String
    }

    static func decodeBundledJSON<Value: Decodable>(named name: String) throws -> Value {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json") else {
            throw MissingBundledFile(name: name)
        }
        return try JSONDecoder.tflModelDecoder.decode(Value.self, from: Data(contentsOf: url))
    }

    // A broken seed file is a build mistake, so fail loudly in debug, but ship an empty list rather than crash.
    private static func loadBundledJSON<Element: Decodable>(named name: String) -> [Element] {
        do {
            return try decodeBundledJSON(named: name)
        } catch {
            assertionFailure("Couldn't load \(name).json: \(error)")
            return []
        }
    }
}

extension Sequence where Element == Station {
    var stationIDsByAtcoCode: [String: Station.ID] {
        Dictionary(
            flatMap { station in station.lineGroups.map { ($0.atcoCode, station.id) } },
            uniquingKeysWith: { first, _ in first }
        )
    }
}
