import DataStores
import Models
import PresentationViews

extension Sequence where Element == SavedJourney {
    func toRecentJourneyItems(
        findStationByID: (Station.ID) -> Station?,
        findNationalRailByICSCode: (String) -> StopPoint?,
        sortByLastUsedDate: Bool
    ) -> [RecentJourneyItem] {
        let recentJourneyItems = compactMap {
            try? $0.toRecentJourneyItem(
                id: $0.id,
                findStationByID: findStationByID,
                findNationalRailByICSCode: findNationalRailByICSCode
            )
        }

        if sortByLastUsedDate {
            return
                recentJourneyItems
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
        let fromPickerValue = try fromLocation.toPickerValue(
            findStationByID: findStationByID,
            findNationalRailByICSCode: findNationalRailByICSCode
        )

        let toPickerValue = try toLocation.toPickerValue(
            findStationByID: findStationByID,
            findNationalRailByICSCode: findNationalRailByICSCode
        )

        var viaPickerValue: JourneyLocationPicker.Value?
        if let viaLocation {
            viaPickerValue = try viaLocation.toPickerValue(
                findStationByID: findStationByID,
                findNationalRailByICSCode: findNationalRailByICSCode
            )
        }

        return .init(
            id: id,
            fromLocation: fromPickerValue,
            toLocation: toPickerValue,
            viaLocation: viaPickerValue,
            lastUsed: lastUsed
        )
    }
}

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
            return .namedLocation(
                .init(
                    name: locationName,
                    coordinate: locationCoordinate,
                    isCurrentLocation: false
                )
            )
        }
    }
}

extension RecentJourneyItem {
    func isDuplicate(of other: RecentJourneyItem) -> Bool {
        fromLocation == other.fromLocation
            && toLocation == other.toLocation
            && viaLocation == other.viaLocation
    }
}

extension Sequence where Element == RecentJourneyItem {
    func sortedByLastUsedDateDescending() -> [RecentJourneyItem] {
        sorted { $0.lastUsed > $1.lastUsed }
    }
}
