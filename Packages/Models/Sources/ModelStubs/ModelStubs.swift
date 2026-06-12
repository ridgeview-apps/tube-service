import Foundation
import Models

public enum ModelStubs {}  // Namespace

private extension ModelStubs {

    static func decodedValue<D: Decodable>(for rawJSON: String) -> D {
        guard let jsonData = rawJSON.data(using: .utf8),
            let decodedValue = try? JSONDecoder.defaultModelDecoder.decode(D.self, from: jsonData)
        else {
            fatalError("Unable to decode JSON data to object of type \(D.self) - please check your JSON is valid for this object type.")
        }

        return decodedValue
    }
}


// MARK: - Arrival stubs

public extension ModelStubs {
    // Elizabeth line
    static let elizabethLineBothPlatforms: [ArrivalDeparture] =
        decodedValue(for: loadJSON(named: "elizabethLineArrivals"))
    static let elizabethLineArrivalsPlatformA =
        elizabethLineBothPlatforms.filter { $0.platformName == "Platform A" }
    static let elizabethLineArrivalsPlatformB =
        elizabethLineBothPlatforms.filter { $0.platformName == "Platform B" }
    static let elizabethLineArrivalsWithDuplicates: [ArrivalDeparture] =
        decodedValue(for: loadJSON(named: "elizabethLineArrivalsWithDuplicates"))

    // Mildmay line
    static let mildmayLineBothPlatforms: [ArrivalDeparture] =
        decodedValue(for: loadJSON(named: "mildmayLineArrivals"))
    static let mildmayLineArrivalsPlatform1 =
        mildmayLineBothPlatforms.filter { $0.platformName == "Platform 1" }
    static let mildmayLineArrivalsPlatform2 =
        mildmayLineBothPlatforms.filter { $0.platformName == "Platform 2" }

    // Northern line (single tube-line platforms)
    static let northernLineBothPlatforms: [ArrivalPrediction] =
        decodedValue(for: loadJSON(named: "northernLineArrivals"))
    static let northernLineNorthboundArrivals =
        northernLineBothPlatforms.filter { $0.platformName == "Northbound - Platform 7" }
    static let northernLineSouthboundArrivals =
        northernLineBothPlatforms.filter { $0.platformName == "Southbound - Platform 8" }

    // Hammersmith, District & Circle (multi tube-line platforms)
    static let hammerDistrictAndCircleBothPlatforms: [ArrivalPrediction] =
        decodedValue(for: loadJSON(named: "hammerDistrictAndCircleArrivals"))
    static let hammerDistrictAndCircleEastboundArrivals =
        hammerDistrictAndCircleBothPlatforms.filter { $0.platformName == "Eastbound - Platform 2" }
    static let hammerDistrictAndCircleWestboundArrivals =
        hammerDistrictAndCircleBothPlatforms.filter { $0.platformName == "Westbound - Platform 1" }
}

// MARK: - Line status stubs

public extension ModelStubs {
    static let lineStatusesToday: [Line] = decodedValue(for: loadJSON(named: "lineStatusesToday"))
    static let lineStatusesFuture: [Line] = decodedValue(for: loadJSON(named: "lineStatusesFuture"))
    static let lineStatusGoodService: Line = decodedValue(for: loadJSON(named: "lineStatusGoodService"))
    static let lineStatusDisrupted: Line = decodedValue(for: loadJSON(named: "lineStatusDisrupted"))
    static let lineStatusDisruptedDuplicates: Line =
        decodedValue(for: loadJSON(named: "lineStatusDisruptedDuplicates"))
}


// MARK: - Stations

public extension ModelStubs {
    static let stations = Station.allLondonTrains
    static let nationRailStopPoints = Station.allNationalRail

    static let angelStation = stations.first { $0.id == "940GZZLUAGL" }!
    static let eastFinchleyStation = stations.first { $0.id == "940GZZLUEFY" }!
    static let finchleyCentralStation = stations.first { $0.id == "940GZZLUFYC" }!
    static let highBarnetStation = stations.first { $0.id == "940GZZLUHBT" }!
    static let kingsCrossStation = stations.first { $0.id == "HUBKGX" }!
    static let paddingtonStation = stations.first { $0.id == "HUBPAD" }!
    static let russellSquareStation = stations.first { $0.id == "940GZZLURSQ" }!
    static let totteridgeAndWhetstoneStation = stations.first { $0.id == "940GZZLUTAW" }!
    static let westFinchleyStation = stations.first { $0.id == "940GZZLUWFN" }!
    static let woodsideParkStation = stations.first { $0.id == "940GZZLUWOP" }!

    static let twickenhamRailStation = nationRailStopPoints.first { $0.icsCode == "1001300" }!
    static let oakleighParkRailStation = nationRailStopPoints.first { $0.icsCode == "1001218" }!
}


// MARK: - Disrupted points

public extension ModelStubs {
    static let disruptedStations: [DisruptedPoint] =
        decodedValue(for: loadJSON(named: "disruptedStations"))
}


// MARK: - Journey planner

public extension ModelStubs {
    static let journeyByBike: Journey = decodedValue(for: loadJSON(named: "journeyByBike"))
    static let journeyByBoat: Journey = decodedValue(for: loadJSON(named: "journeyByBoat"))
    static let journeyByBusLong: Journey = decodedValue(for: loadJSON(named: "journeyByBusLong"))
    static let journeyByBusShort: Journey = decodedValue(for: loadJSON(named: "journeyByBusShort"))
    static let journeyByCableCar: Journey = decodedValue(for: loadJSON(named: "journeyByCableCar"))
    static let journeyByNationalRail: Journey = decodedValue(for: loadJSON(named: "journeyByNationalRail"))
    static let journeyByOverground: Journey = decodedValue(for: loadJSON(named: "journeyByOverground"))
    static let journeyByTube: Journey = decodedValue(for: loadJSON(named: "journeyByTube"))
    static let journeyByWalking: Journey = decodedValue(for: loadJSON(named: "journeyByWalking"))
    static let journeyWithLongDisruptionMessage: Journey =
        decodedValue(for: loadJSON(named: "journeyWithLongDisruptionMessage"))
    static let journeyWithLongTitleName: Journey =
        decodedValue(for: loadJSON(named: "journeyWithLongTitleName"))
    static let journeyResultsKingsXToWaterlooNow: JourneyResults =
        decodedValue(for: loadJSON(named: "journeyResultsKingsXToWaterlooNow"))
    static let journeyResultsKingsXToWaterlooEarlier: JourneyResults =
        decodedValue(for: loadJSON(named: "journeyResultsKingsXToWaterlooEarlier"))
    static let journeyResultsKingsXToWaterlooLater: JourneyResults =
        decodedValue(for: loadJSON(named: "journeyResultsKingsXToWaterlooLater"))
}


// MARK: - System status

public extension ModelStubs {
    static let systemStatusOK: SystemStatus = decodedValue(for: loadJSON(named: "systemStatusOK"))
    static let systemStatusOutage: SystemStatus = decodedValue(for: loadJSON(named: "systemStatusOutage"))
    static let systemStatusResolved: SystemStatus = decodedValue(for: loadJSON(named: "systemStatusResolved"))
}
