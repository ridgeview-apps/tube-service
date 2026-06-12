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
    static var elizabethLineBothPlatforms: [ArrivalDeparture] {
        decodedValue(for: loadJSON(named: "elizabethLineArrivals"))
    }

    static var elizabethLineArrivalsPlatformA: [ArrivalDeparture] {
        elizabethLineBothPlatforms.filter { $0.platformName == "Platform A" }
    }

    static var elizabethLineArrivalsPlatformB: [ArrivalDeparture] {
        elizabethLineBothPlatforms.filter { $0.platformName == "Platform B" }
    }

    static var elizabethLineArrivalsWithDuplicates: [ArrivalDeparture] {
        decodedValue(for: loadJSON(named: "elizabethLineArrivalsWithDuplicates"))
    }

    // Mildmay line
    static var mildmayLineBothPlatforms: [ArrivalDeparture] {
        decodedValue(for: loadJSON(named: "mildmayLineArrivals"))
    }

    static var mildmayLineArrivalsPlatform1: [ArrivalDeparture] {
        mildmayLineBothPlatforms.filter { $0.platformName == "Platform 1" }
    }

    static var mildmayLineArrivalsPlatform2: [ArrivalDeparture] {
        mildmayLineBothPlatforms.filter { $0.platformName == "Platform 2" }
    }


    // Northern line (single tube-line platforms)
    static var northernLineBothPlatforms: [ArrivalPrediction] {
        decodedValue(for: loadJSON(named: "northernLineArrivals"))
    }

    static var northernLineNorthboundArrivals: [ArrivalPrediction] {
        northernLineBothPlatforms.filter { $0.platformName == "Northbound - Platform 7" }
    }

    static var northernLineSouthboundArrivals: [ArrivalPrediction] {
        northernLineBothPlatforms.filter { $0.platformName == "Southbound - Platform 8" }
    }

    // Hammersmith, District & Circle (multi tube-line platforms)
    static var hammerDistrictAndCircleBothPlatforms: [ArrivalPrediction] {
        decodedValue(for: loadJSON(named: "hammerDistrictAndCircleArrivals"))
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
    static var lineStatusesToday: [Line] { decodedValue(for: loadJSON(named: "lineStatusesToday")) }

    static var lineStatusesFuture: [Line] { decodedValue(for: loadJSON(named: "lineStatusesFuture")) }

    static var lineStatusGoodService: Line { decodedValue(for: loadJSON(named: "lineStatusGoodService")) }

    static var lineStatusDisrupted: Line { decodedValue(for: loadJSON(named: "lineStatusDisrupted")) }

    static var lineStatusDisruptedDuplicates: Line {
        decodedValue(for: loadJSON(named: "lineStatusDisruptedDuplicates"))
    }
}


// MARK: - Stations

public extension ModelStubs {
    static var stations: [Station] { Station.allLondonTrains }
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

    static var disruptedStations: [DisruptedPoint] {
        decodedValue(for: loadJSON(named: "disruptedStations"))
    }
}


// MARK: - Journey planner

public extension ModelStubs {

    static var journeyByBike: Journey {
        decodedValue(for: loadJSON(named: "journeyByBike"))
    }

    static var journeyByBoat: Journey {
        decodedValue(for: loadJSON(named: "journeyByBoat"))
    }

    static var journeyByBusLong: Journey {
        decodedValue(for: loadJSON(named: "journeyByBusLong"))
    }

    static var journeyByBusShort: Journey {
        decodedValue(for: loadJSON(named: "journeyByBusShort"))
    }

    static var journeyByCableCar: Journey {
        decodedValue(for: loadJSON(named: "journeyByCableCar"))
    }

    static var journeyByNationalRail: Journey {
        decodedValue(for: loadJSON(named: "journeyByNationalRail"))
    }

    static var journeyByOverground: Journey {
        decodedValue(for: loadJSON(named: "journeyByOverground"))
    }

    static var journeyByTube: Journey {
        decodedValue(for: loadJSON(named: "journeyByTube"))
    }

    static var journeyByWalking: Journey {
        decodedValue(for: loadJSON(named: "journeyByWalking"))
    }

    static var journeyWithLongDisruptionMessage: Journey {
        decodedValue(for: loadJSON(named: "journeyWithLongDisruptionMessage"))
    }

    static var journeyWithLongTitleName: Journey {
        decodedValue(for: loadJSON(named: "journeyWithLongTitleName"))
    }

    static var journeyResultsKingsXToWaterlooNow: JourneyResults {
        decodedValue(for: loadJSON(named: "journeyResultsKingsXToWaterlooNow"))
    }

    static var journeyResultsKingsXToWaterlooEarlier: JourneyResults {
        decodedValue(for: loadJSON(named: "journeyResultsKingsXToWaterlooEarlier"))
    }

    static var journeyResultsKingsXToWaterlooLater: JourneyResults {
        decodedValue(for: loadJSON(named: "journeyResultsKingsXToWaterlooLater"))
    }
}


// MARK: - System status

public extension ModelStubs {

    static var systemStatusOK: SystemStatus { decodedValue(for: loadJSON(named: "systemStatusOK")) }
    static var systemStatusOutage: SystemStatus { decodedValue(for: loadJSON(named: "systemStatusOutage")) }
    static var systemStatusResolved: SystemStatus { decodedValue(for: loadJSON(named: "systemStatusResolved")) }
}
