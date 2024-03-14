import DataStores
import Models
import PresentationViews

// SavedJourney <-> RecentJourneyItem

extension Sequence where Element == SavedJourney {
    
    func toRecentJourneyItems(
        findStationByID: (Station.ID) -> Station?,
        findNationalRailByICSCode: (String) -> StopPoint?
    ) -> [RecentJourneyItem] {
        compactMap {
            try? $0.toRecentJourney(findStationByID: findStationByID,
                                    findNationalRailByICSCode: findNationalRailByICSCode)
        }
        .removingDuplicates()
    }
}


extension SavedJourney {
    
    func toRecentJourney(
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
        
        return .init(fromLocation: fromPickerValue,
                     toLocation: toPickerValue,
                     viaLocation: viaPickerValue)
    }
}

extension RecentJourneyItem {
    func toSavedJourney() -> SavedJourney? {
        guard let journeyFrom = fromLocation.toSavedJourneyLocationType(),
              let journeyTo = toLocation.toSavedJourneyLocationType() else {
            return nil
        }
        
        var journeyVia: SavedJourney.LocationType?
        if let viaLocation {
            journeyVia = viaLocation.toSavedJourneyLocationType()
        }
        
        return .init(fromLocation: journeyFrom,
                     toLocation: journeyTo,
                     viaLocation: journeyVia)
    }
    
    func toJourneyPlannerForm(timeSelection: JourneyTimePickerSelection) -> JourneyPlannerForm {
        .init(from: fromLocation,
              to: toLocation,
              via: viaLocation,
              timeSelection: timeSelection)
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
            return .namedLocation(.init(name: locationName, coordinate: locationCoordinate))
        }
    }
}


// JourneyPlannerForm extensions

enum JourneyPlannerError: Error {
    case stationNotFound
    case invalidLocationRequest
    case unresolvedLocationCoordinate
}

extension JourneyPlannerForm {
    
    func toSavedJourney() -> SavedJourney? {
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
        
        return .init(fromLocation: fromLocation,
                     toLocation: toLocation,
                     viaLocation: viaLocation)
    }
    
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
    
    func resolvingLocations(
        currentLocationName: LocationName?,
        currentLocationCoordinate: LocationCoordinate?,
        findLocationCoordinate: (LocationName) async throws -> LocationCoordinate
    ) async throws -> JourneyPlannerForm {
        // Resolve location coordinates for selections (e.g. current or named location)
        async let resolveFrom = from?.resolvingLocationCoordinate(currentLocationName: currentLocationName,
                                                                  currentLocationCoordinate: currentLocationCoordinate,
                                                                  findLocationCoordinate: findLocationCoordinate)
        
        async let resolveTo = to?.resolvingLocationCoordinate(currentLocationName: currentLocationName,
                                                              currentLocationCoordinate: currentLocationCoordinate,
                                                              findLocationCoordinate: findLocationCoordinate)
        
        async let resolveVia = via?.resolvingLocationCoordinate(currentLocationName: currentLocationName,
                                                                currentLocationCoordinate: currentLocationCoordinate,
                                                                findLocationCoordinate: findLocationCoordinate)
        
        let (resolvedFromValue, resolvedToValue, resolvedViaValue) = try await (resolveFrom, resolveTo, resolveVia)
        
        var updatedForm = self
        if let resolvedFromValue {
            updatedForm.from = resolvedFromValue
        }
        if let resolvedToValue {
            updatedForm.to = resolvedToValue
        }
        if let resolvedViaValue {
            updatedForm.via = resolvedViaValue
        }
        
        return updatedForm
    }
    
    mutating func updateCurrentLocationInfo(isAuthorized: Bool,
                                            updatedValue: JourneyLocationPicker.CurrentLocationValue) {
        if isAuthorized {
            if from.isCurrentLocation { self.from = .currentLocation(updatedValue) }
            if to.isCurrentLocation { self.to = .currentLocation(updatedValue) }
            if via.isCurrentLocation { self.via = .currentLocation(updatedValue) }
        } else {
            if from.isCurrentLocation { self.from = nil }
            if to.isCurrentLocation { self.to = nil }
            if via.isCurrentLocation { self.via = nil }
        }
    }
}


// JourneyLocationPicker.Value extensions

extension JourneyLocationPicker.Value? {
    
    var isCurrentLocation: Bool {
        guard case .currentLocation = self else { return false }
        return true
    }
}

extension JourneyLocationPicker.Value {
    
    func isSameAs(currentLocationName: LocationName?) -> Bool {
        switch self {
        case .currentLocation(let value):
            return value.name == currentLocationName
        case .namedLocation(let namedLocationValue):
            return namedLocationValue.name == currentLocationName
        case .station, .nationalRail:
            return false
        }
    }
    
    func toRequestParamsJourneyLocation() -> JourneyRequestParams.JourneyLocation? {
        switch self {
        case let .currentLocation(location):
            guard let locationCoordinate = location.coordinate else {
                return nil
            }
            return .coordinate(locationCoordinate)
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
        case let .currentLocation(value):
            guard let locationName = value.name,
                  let locationCoordinate = value.coordinate else {
                return nil
            }
            return .specific(locationName, locationCoordinate)
        case .station(let station):
            return .station(id: station.id)
        case .nationalRail(let stopPoint):
            guard let icsCode = stopPoint.icsCode else {
                return nil
            }
            return .nationalRail(icsCode: icsCode)
        case let .namedLocation(value):
            guard let locationCoordinate = value.coordinate else {
                return nil
            }
            return .specific(value.name, locationCoordinate)
        }
    }
    
    func resolvingLocationCoordinate(
        currentLocationName: LocationName?,
        currentLocationCoordinate: LocationCoordinate?,
        findLocationCoordinate: (LocationName) async throws -> LocationCoordinate
    ) async throws -> JourneyLocationPicker.Value {
        switch self {
        case .station, .nationalRail:
            return self
        case .currentLocation(let value):
            if value.isResolved {
                return self
            } else {
                return .currentLocation(.init(name: currentLocationName,
                                              coordinate: currentLocationCoordinate))
            }
        case .namedLocation(let value):
            if value.isResolved {
                return self
            } else {
                let resolvedCoordinate = try await findLocationCoordinate(value.name)
                return .namedLocation(.init(name: value.name,
                                            coordinate: resolvedCoordinate))
            }
        }
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
