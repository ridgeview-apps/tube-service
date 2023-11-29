import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let apiClient = TransportAPIClient.real()
let debugEnabled = true

Task {
    do {
        debugMessage("*** Fetching line IDS ***")
        let lineIDs = try await fetchLineIDs()
        
        debugMessage("*** Fetching all stoppoints for \(lineIDs.count) lines ***")
        let allStopPoints = try await fetchStopPoints(for: lineIDs)
        let hubStopPoints = fetchInterchangeStopPoints()
        let stations = allStopPoints.toSortedStations(hubStopPoints: hubStopPoints)
        
        print(JSONEncoder.prettyPrintedValue(for: stations))
        debugSuccess("Finished")
    } catch {
        debugFailure(error)
    }
}

func fetchInterchangeStopPoints() -> [StopPoint] {
    // Pre-loaded from: https://api.tfl.gov.uk/StopPoint/Type/TransportInterchange
    Bundle.loadStopPoints(from: "stoppoints-interchanges")    
}

func fetchLineIDs() async throws -> [LineID] {
    let lines = try await apiClient.lines(forModeIDs: TransportModeID.allCases)
    debugSuccess("Successfully fetched \(lines.count) lines: \(lines.map { $0.rawValue })")
    return lines
}

func fetchStopPoints(for lineIDs: [LineID]) async throws -> [StopPoint] {
    var allStopPoints = [StopPoint]()
    try await lineIDs.asyncForEach { lineID in
        let lineStopPoints = try await apiClient.stopPoints(forLine: lineID)
        allStopPoints.append(contentsOf: lineStopPoints)
        debugSuccess("Successfully fetched \(lineStopPoints.count) stoppoints for \(lineID.rawValue)")
    }
    return allStopPoints
}

func debugSuccess(_ message: String) {
    if debugEnabled { print("\n✅ \(message)\n") }
}

func debugFailure(_ error: Error) {
    if debugEnabled { print("\n💣💥 \(error)\n") }
}

func debugMessage(_ message: String) {
    if debugEnabled { print("\n\(message)\n") }
}
