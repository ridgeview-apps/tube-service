import Foundation
import DataStores
import Models
import PresentationViews

// swiftlint:disable identifier_name

enum JourneyPlannerError: Error {
    case stationNotFound
    case invalidLocationRequest
    case coordinateUnknown
}


// SavedJourney <-> RecentJourneyItem

extension Sequence where Element == SavedJourney {
    
    func toRecentJourneyItems(
        findStationByID: (Station.ID) -> Station?,
        findNationalRailByICSCode: (String) -> StopPoint?,
        sortByLastUsedDate: Bool
    ) -> [RecentJourneyItem] {
        let recentJourneyItems = compactMap {
            try? $0.toRecentJourneyItem(id: $0.id,
                                        findStationByID: findStationByID,
                                        findNationalRailByICSCode: findNationalRailByICSCode)
        }

        if sortByLastUsedDate {
            return recentJourneyItems
                     .removingDuplicates()
                     .sortedByLastUsedDateDescending()
        } else {
            return recentJourneyItems
        }
    }
}


extension SavedJourney {
    
    func toRecentJourneyItem(
        id: SavedJourney.ID,
        findStationByID: (Station.ID) -> Station?,
        findNationalRailByICSCode: (String) -> StopPoint?
    ) throws -> RecentJourneyItem? {
        let fromPickerValue = try fromLocation.toPickerValue(findStationByID: findStationByID,
                                                             findNationalRailByICSCode: findNationalRailByICSCode)
        
        let toPickerValue = try toLocation.toPickerValue(findStationByID: findStationByID,
                                                         findNationalRailByICSCode: findNationalRailByICSCode)
        
        var viaPickerValue: JourneyLocationPicker.Value?
        if let viaLocation {
            viaPickerValue = try viaLocation.toPickerValue(findStationByID: findStationByID,
                                                           findNationalRailByICSCode: findNationalRailByICSCode)
        }
        
        return .init(id: id,
                     fromLocation: fromPickerValue,
                     toLocation: toPickerValue,
                     viaLocation: viaPickerValue,
                     lastUsed: lastUsed)
    }
}

extension RecentJourneyItem {
    
    func isDuplicate(of other: RecentJourneyItem) -> Bool {
        return fromLocation == other.fromLocation
                && toLocation == other.toLocation
                && viaLocation == other.viaLocation
    }
    
}

extension Sequence where Element == RecentJourneyItem {
    
    func sortedByLastUsedDateDescending() -> [RecentJourneyItem] {
        sorted { $0.lastUsed > $1.lastUsed }
    }
}


// JourneyLocationPicker.Value <-> SavedJourney.LocationType

extension SavedJourney.LocationType {
    
    func toPickerValue(
        findStationByID: (Station.ID) -> Station?,
        findNationalRailByICSCode: (String) -> StopPoint?
    ) throws -> JourneyLocationPicker.Value {
        switch self {
        case .station(let id):
            guard let station = findStationByID(id) else {
                throw JourneyPlannerError.stationNotFound
            }
            return .station(station)
        case .nationalRail(let icsCode):
            guard let stopPoint = findNationalRailByICSCode(icsCode) else {
                throw JourneyPlannerError.stationNotFound
            }
            return .nationalRail(stopPoint)
        case .specific(let locationName, let locationCoordinate):
            return .namedLocation(.init(name: locationName,
                                        coordinate: locationCoordinate,
                                        isCurrentLocation: false))
        }
    }
}


// JourneyPlannerForm extensions

extension JourneyPlannerForm {
        
    func toJourneyRequestParams(withModeIDs modeIDs: Set<ModeID>) throws -> JourneyRequestParams {
        guard let fromParam = from?.toRequestParamsJourneyLocation(),
              let toParam = to?.toRequestParamsJourneyLocation() else {
            throw JourneyPlannerError.invalidLocationRequest
        }
         
        var viaParam: JourneyRequestParams.JourneyLocation?
        if let via = via?.toRequestParamsJourneyLocation() {
            viaParam = .init(via)
        }
        
        let timeOption: JourneyRequestParams.TimeOption?
        switch timeSelection.option {
        case .leaveNow:
            timeOption = nil
        case .leaveAt:
            timeOption = .departing(timeSelection.date)
        case .arriveBy:
            timeOption = .arriving(timeSelection.date)
        }
        
        return .init(
            from: fromParam,
            to: toParam,
            via: viaParam,
            modeIDs: modeIDs,
            timeOption: timeOption
        )
    }
    
    func toNewSavedJourney(id: UUID = UUID(),
                           timestamp: Date = .now) -> SavedJourney? {
        guard from != to,
              let fromLocation = from?.toSavedJourneyLocationType(),
              let toLocation = to?.toSavedJourneyLocationType() else {
            return nil
        }
        
        var viaLocation: SavedJourney.LocationType?
        let skipVia = via == from || via == to
        if let via, !skipVia {
            viaLocation = via.toSavedJourneyLocationType()
        }
        
        return .init(id: id,
                     fromLocation: fromLocation,
                     toLocation: toLocation,
                     viaLocation: viaLocation,
                     lastUsed: timestamp)
    }
    
    mutating func updateCurrentLocationInfo(name: LocationName?,
                                            coordinate: LocationCoordinate?,
                                            updatesAllowed: Bool) {
        if let from, from.isCurrentLocation {
            self.from = updatesAllowed ? .currentLocation(name: name, coordinate: coordinate) : nil
        }
        if let to, to.isCurrentLocation {
            self.to = updatesAllowed ? .currentLocation(name: name, coordinate: coordinate) : nil
        }
        if let via, via.isCurrentLocation { 
            self.via = updatesAllowed ? .currentLocation(name: name, coordinate: coordinate) : nil
        }
    }
    
    mutating func populate(with recentJourneyItem: RecentJourneyItem) {
        from = recentJourneyItem.fromLocation
        to = recentJourneyItem.toLocation
        via = recentJourneyItem.viaLocation
    }
    
    mutating func populate(locationFieldID: FieldID.LocationID, withValue newValue: JourneyLocationPicker.Value?) {
        switch locationFieldID {
        case .from:
            from = newValue
        case .to:
            to = newValue
        case .via:
            via = newValue
        }
    }
    
    func locationPickerValue(for locationFieldID: FieldID.LocationID) -> JourneyLocationPicker.Value? {
        switch locationFieldID {
        case .from:
            return from
        case .to:
            return to
        case .via:
            return via
        }
    }
    
    mutating func adjustCurrentTimeIfNeeded() {
        if timeSelection.date < .now {
            timeSelection.date = .now
        }
    }
}


// JourneyLocationPicker.Value extensions

extension JourneyLocationPicker.Value {
    
    func isDuplicate(of other: JourneyLocationPicker.Value) -> Bool {
        switch (self, other) {
        case let (.namedLocation(lhsValue), .namedLocation(rhsValue)):
            return lhsValue.name == rhsValue.name
        case let (.station(lhsValue), .station(rhsValue)):
            return lhsValue == rhsValue
        case let (.nationalRail(lhsValue), .nationalRail(rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
    
    var isCurrentLocation: Bool {
        switch self {
        case .station, .nationalRail:
            return false
        case .namedLocation(let namedLocationValue):
            return namedLocationValue.isCurrentLocation
        }
    }
    
    func toRequestParamsJourneyLocation() -> JourneyRequestParams.JourneyLocation? {
        switch self {
        case .station(let station):
            return .icsCode(station.icsCode)
        case .nationalRail(let stopPoint):
            guard let icsCode = stopPoint.icsCode else {
                assertionFailure("Invalid national rail stoppoint detected: \(stopPoint)")
                return nil
            }
            return .icsCode(icsCode)
        case let .namedLocation(location):
            guard let locationCoordinate = location.coordinate else {
                return nil
            }
            return .coordinate(locationCoordinate)
        }
    }
    
    func toSavedJourneyLocationType() -> SavedJourney.LocationType? {
        switch self {
        case .station(let station):
            return .station(id: station.id)
        case .nationalRail(let stopPoint):
            guard let icsCode = stopPoint.icsCode else {
                return nil
            }
            return .nationalRail(icsCode: icsCode)
        case let .namedLocation(value):
            guard let locationName = value.name,
                  let locationCoordinate = value.coordinate else {
                return nil
            }
            return .specific(locationName, locationCoordinate)
        }
    }
}

extension Sequence where Element == JourneyLocationPicker.Value {
    func alreadyContains(_ otherValue: JourneyLocationPicker.Value) -> Bool {
        return contains(where: {
            $0.isDuplicate(of: otherValue)
        })
    }
}


// Journey extensions

extension Sequence where Element == Journey {
    
    func sanitizedAndSortedByArrivalTime(forModeIDs modeIDs: Set<ModeID>) -> [Journey] {
        filter {
            $0.isValid(forModeIDs: modeIDs)
        }
        .sorted {
            $0.arrivalDateTime ?? .distantPast < $1.arrivalDateTime ?? .distantPast
        }
    }
}

extension Journey {
    
    func isValid(forModeIDs modeIDs: Set<ModeID>) -> Bool {
        // Skip journeys with dodgy durations
        let isDurationValid = (duration ?? 0) > 0
        guard isDurationValid else {
            return false
        }
        
        // Walking and cycle journeys are returned (even when not requested)
        // So we must explicitly skip them if the user has turned these off
        
        let isAllWalking = (legs ?? []).allSatisfy { $0.modeID == .walking }
        if isAllWalking && !modeIDs.contains(.walking) {
            return false
        }
        
        let isAllCycling = (legs ?? []).allSatisfy { $0.modeID == .cycle || $0.modeID == .cycleHire }
        if isAllCycling && !modeIDs.contains(.cycle) {
            return false
        }
        
        return true
    }
}

// swiftlint:enable identifier_name
