import Foundation

public enum TransportModeID: String, CaseIterable {
    case dlr
    case tram
    case tube
    case elizabethLine = "elizabeth-line"
    case overground
}

public enum LineID: String, Codable, CaseIterable {
    case bakerloo
    case central
    case circle
    case district
    case dlr
    case elizabeth
    case hammersmithAndCity = "hammersmith-city"
    case jubilee
    case liberty
    case lioness
    case metropolitan
    case mildmay
    case northern
    case piccadilly
    case suffragette
    case victoria
    case waterlooAndCity = "waterloo-city"
    case weaver
    case windrush
    case tram
}

public extension CaseIterable where Self: RawRepresentable {
    
    static var allRawValues: [RawValue] {
        Self.allCases.map { $0.rawValue }
    }
}


public struct StopPoint: Hashable, Codable {
    
    public let commonName: String
    public let naptanId: String
    public let modes: [String]
    public let hubNaptanCode: String?
    public let stationNaptan: String?
    public let icsCode: String
    public let lat: Double
    public let lon: Double
    
    public var lineGroup: [LineGroup]
    
    public struct LineGroup: Hashable, Codable {
        public let stationAtcoCode: String
        public let lineIdentifier: [String]
        
        func cleanedValue() -> LineGroup? {
            let validLineIDs = lineIdentifier.filter {
                LineID.allRawValues.contains($0)
            }
            guard !validLineIDs.isEmpty else { return nil }
            return .init(stationAtcoCode: stationAtcoCode,
                         lineIdentifier: validLineIDs)
        }
    }
}

public struct StationProperties {
    let lat: Double
    let lon: Double
    var lineGroups: Set<StopPoint.LineGroup>
    
    static func empty(lat: Double, lon: Double) -> StationProperties { StationProperties(lat: lat,
                                                                                         lon: lon,
                                                                                         lineGroups: []) }
}

public extension Sequence where Element == StopPoint {
    
    func groupedByNaptanCodes(hubStopPoints: [StopPoint]) -> [StationIDAndName: StationProperties] {
        var groupedStopPoints = [StationIDAndName: StationProperties]()
        forEach { stopPoint in
            let stopPointStationIDAndName: StationIDAndName
            
            if let hubNaptanCode = stopPoint.hubNaptanCode, !hubNaptanCode.isBlank {
                if let hubStopPoint = hubStopPoints.first(where: { $0.hubNaptanCode == hubNaptanCode }) {
                    stopPointStationIDAndName = .init(id: hubStopPoint.naptanId,
                                                      icsCode: hubStopPoint.icsCode,
                                                      name: hubStopPoint.commonName)
                } else {
                    fatalError("Cannot find find hub name for \(hubNaptanCode)")
                }
            } else {
                let naptanID: String
                let icsCode: String
                if let stationNaptan = stopPoint.stationNaptan, stationNaptan != stopPoint.naptanId {
                    naptanID = stationNaptan // Workaround for dodgy trams
                } else {
                    naptanID = stopPoint.naptanId
                }
                stopPointStationIDAndName = .init(id: naptanID, 
                                                  icsCode: stopPoint.icsCode,
                                                  name: stopPoint.commonName)
            }
            
            stopPoint.lineGroup.forEach {
                if let cleanedValue = $0.cleanedValue() {
                    var properties = groupedStopPoints[stopPointStationIDAndName] ?? .empty(lat: stopPoint.lat,
                                                                                            lon: stopPoint.lon)
                    properties.lineGroups.insert(cleanedValue)
                    groupedStopPoints[stopPointStationIDAndName] = properties
                }
            }

        }
        return groupedStopPoints
    }
    
    func sortedStations(for groupedData: [StationIDAndName: StationProperties]) -> [Station] {
        var uniqueStations = Set<Station>()
        
        groupedData.forEach { stationKey, properties in
            let arrivalsLineGroups = properties.lineGroups.map {
                Station.LineGroup(atcoCode: $0.stationAtcoCode,
                                  lineIds: $0.lineIdentifier)
            }
            let uniqueSortedArrivalsLineGroups = Array(
                Set(arrivalsLineGroups)
            ).sorted {
                $0.sortKey < $1.sortKey
            }
            
            let stationName = stationKey.name
                .replacingOccurrences(of: "Underground Station", with: "")
                .replacingOccurrences(of: "DLR Station", with: "")
                .replacingOccurrences(of: "Tram Stop", with: "")
                .replacingOccurrences(of: "Rail Station", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            let stationID = stationKey.id
            let icsCode = stationKey.icsCode
            
            let station =  Station(name: stationName,
                                   id: stationID,
                                   icsCode: icsCode,
                                   location: .init(lat: properties.lat,
                                                   lon: properties.lon),
                                   lineGroups: uniqueSortedArrivalsLineGroups).patchedValue()
            
            uniqueStations.insert(station)
        }
        
        // This was originally needed to fix a Heathrow T4 bug (now appears to be fixed)
        // uniqueStations.insert(.heathrowTerminal4)
        
        
        return Array(uniqueStations).sortedByName()
    }
    
    func toSortedStations(hubStopPoints: [StopPoint]) -> [Station] {
        let groupedData = self.groupedByNaptanCodes(hubStopPoints: hubStopPoints)
        return sortedStations(for: groupedData)
    }
}

public struct StationIDAndName: Hashable {
    let id: String
    let icsCode: String
    let name: String
}

public struct Location: Codable, Hashable {
    let lat: Double
    let lon: Double
}

public struct Station: Codable, Hashable, Equatable {
    public struct LineGroup: Hashable, Codable {
        public let atcoCode: String
        public let lineIds: [String]
        
        var sortKey: String {
            lineIds.sorted().joined(separator: "-")
        }
    }
    
    public let name: String
    public let id: String
    public let icsCode: String
    public let location: Location
    public var lineGroups: [LineGroup]
    
    public static func == (lhs: Station, rhs: Station) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.lineGroups == rhs.lineGroups
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(lineGroups)
    }
    
    // This was originally needed to fix a Heathrow T4 bug (now appears to be fixed)
//    static let heathrowTerminal4 = Station(
//        name: "Heathrow Airport Terminal 4",
//        id: "HUBHX4",
//        lineGroups: [
//            .init(
//                atcoCode: "940GZZLUHR4",
//                lineIds: ["piccadilly"]
//            )
//        ]
//    )
}

extension Station {
    func patchedValue() -> Station {
        switch(id) {
        case "HUBPAD":
            var patchedStation = self
            patchedStation.lineGroups.removeAll {
                $0.lineIds == ["hammersmith-city"]
                ||
                ($0.lineIds == ["elizabeth"] && $0.atcoCode == "910GPADTLL")
            }
            return patchedStation
        case "HUBLST":
            var patchedStation = self
            patchedStation.lineGroups.removeAll {
                ($0.lineIds == ["elizabeth"] && $0.atcoCode == "910GLIVSTLL")
            }
            return patchedStation
        default:
            return self
        }
    }
}

public extension Sequence where Element == Station {
    
    func sortedByName() -> [Station] {
        sorted { $0.name < $1.name }
    }
}
