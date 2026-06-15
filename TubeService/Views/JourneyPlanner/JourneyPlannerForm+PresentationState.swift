import DataStores
import Foundation
import Models
import PresentationViews

extension JourneyPlannerForm {
    func toJourneyRequestParams(withModeIDs modeIDs: Set<ModeID>) throws -> JourneyRequestParams {
        guard let fromParam = from?.toRequestParamsJourneyLocation(),
            let toParam = to?.toRequestParamsJourneyLocation()
        else {
            throw JourneyPlannerError.invalidLocationRequest
        }

        var viaParam: JourneyRequestParams.JourneyLocation?
        if let via = via?.toRequestParamsJourneyLocation() {
            viaParam = .init(via)
        }

        let timeOption: JourneyRequestParams.TimeOptionParam?
        switch timeSelection.option {
        case .leaveNow:
            timeOption = nil
        case .leaveAt:
            timeOption = .departing(at: timeSelection.date)
        case .arriveBy:
            timeOption = .arriving(at: timeSelection.date)
        }

        return .init(
            from: fromParam,
            to: toParam,
            via: viaParam,
            modeIDs: modeIDs,
            timeOption: timeOption
        )
    }

    func toNewSavedJourney(
        id: UUID = UUID(),
        timestamp: Date = .now
    ) -> SavedJourney? {
        guard from != to,
            let fromLocation = from?.toSavedJourneyLocationType(),
            let toLocation = to?.toSavedJourneyLocationType()
        else {
            return nil
        }

        var viaLocation: SavedJourney.LocationType?
        let skipVia = via == from || via == to
        if let via, !skipVia {
            viaLocation = via.toSavedJourneyLocationType()
        }

        return .init(
            id: id,
            fromLocation: fromLocation,
            toLocation: toLocation,
            viaLocation: viaLocation,
            lastUsed: timestamp
        )
    }

    mutating func updateCurrentLocationInfo(
        name: LocationName?,
        coordinate: LocationCoordinate?,
        updatesAllowed: Bool
    ) {
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
