import DataStores
import Foundation
import Models
import PresentationViews

extension JourneyPlannerForm {
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

    mutating func populate(with recentJourneyItem: RecentJourneyItem) {
        from = recentJourneyItem.fromLocation
        to = recentJourneyItem.toLocation
        via = recentJourneyItem.viaLocation
    }
}
