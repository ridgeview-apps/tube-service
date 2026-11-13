import Foundation
import Shared

public struct UserPreferences: Equatable, Codable, Sendable {

    public static let `default`: UserPreferences = .init(
        favouriteStops: [],
        favouriteLineIDs: [],
        recentlySelectedStations: [],
        journeyModePreset: .trainAndBus,
        recentlySavedJourneys: [],
        readSystemStatusMessage: nil
    )

    public internal(set) var favouriteStops: [FavouriteStop]
    public internal(set) var favouriteLineIDs: [Line.ID]
    public var recentlySelectedStations: [Station.ID]
    public internal(set) var selectedLineGroupIDs: [Station.ID: Station.LineGroup.ID]
    public var journeyModePreset: JourneyModePreset
    public var recentlySavedJourneys: [SavedJourney]
    public var readSystemStatusMessage: SystemStatus.ID?
    /// Each station's notices already opened, by TfL's text, which is all that identifies a notice.
    public internal(set) var seenStationNotices: [Station.ID: Set<String>]

    public init(
        favouriteStops: [FavouriteStop],
        favouriteLineIDs: [Line.ID] = [],
        recentlySelectedStations: [Station.ID] = [],
        selectedLineGroupIDs: [Station.ID: Station.LineGroup.ID] = [:],
        journeyModePreset: JourneyModePreset,
        recentlySavedJourneys: [SavedJourney],
        readSystemStatusMessage: SystemStatus.ID?,
        seenStationNotices: [Station.ID: Set<String>] = [:]
    ) {
        self.favouriteStops = favouriteStops.removingDuplicates()
        self.favouriteLineIDs = favouriteLineIDs.removingDuplicates()
        self.recentlySelectedStations = recentlySelectedStations
        self.selectedLineGroupIDs = selectedLineGroupIDs
        self.journeyModePreset = journeyModePreset
        self.recentlySavedJourneys = recentlySavedJourneys
        self.readSystemStatusMessage = readSystemStatusMessage
        self.seenStationNotices = seenStationNotices
    }

    // MARK: - Favourite Stops

    public func containsFavouriteStop(_ stop: FavouriteStop) -> Bool {
        favouriteStops.contains(stop)
    }

    /// New favourites are added to the end of the user's ordering.
    public mutating func addFavouriteStop(_ stop: FavouriteStop) {
        guard !favouriteStops.contains(stop) else { return }
        favouriteStops.append(stop)
    }

    public mutating func removeFavouriteStops(_ stops: some Sequence<FavouriteStop>) {
        let removedStops = Set(stops)
        favouriteStops.removeAll { removedStops.contains($0) }
    }

    /// Applies a new ordering without changing which stops are favourites:
    /// stops that aren't already favourites are ignored, and any favourites missing from `orderedStops` keep their place at the end.
    public mutating func reorderFavouriteStops(_ orderedStops: [FavouriteStop]) {
        let reordered = orderedStops.removingDuplicates().filter { favouriteStops.contains($0) }
        let missing = favouriteStops.filter { !reordered.contains($0) }
        favouriteStops = reordered + missing
    }

    // MARK: - Favourite Lines

    public func containsFavouriteLine(_ lineID: TrainLineID) -> Bool {
        favouriteLineIDs.contains(lineID)
    }

    /// New favourites are added to the end of the user's ordering.
    public mutating func addFavouriteLine(_ favouriteLineID: TrainLineID) {
        guard !favouriteLineIDs.contains(favouriteLineID) else { return }
        favouriteLineIDs.append(favouriteLineID)
    }

    public mutating func removeFavouriteLine(_ favouriteLineID: TrainLineID) {
        favouriteLineIDs.removeAll { $0 == favouriteLineID }
    }

    /// Applies a new ordering without changing which lines are favourites:
    /// IDs that aren't already favourites are ignored, and any favourites missing from `orderedLineIDs` keep their place at the end.
    public mutating func reorderFavouriteLines(_ orderedLineIDs: [TrainLineID]) {
        let reordered = orderedLineIDs.removingDuplicates().filter { favouriteLineIDs.contains($0) }
        let missing = favouriteLineIDs.filter { !reordered.contains($0) }
        favouriteLineIDs = reordered + missing
    }

    // MARK: - Selected Line Groups

    /// The line group last chosen at a station, or its default (the first by name) if none was chosen or the chosen one
    /// no longer exists, e.g. after the seed data regroups its lines.
    public func selectedLineGroup(at station: Station) -> Station.LineGroup? {
        let selectedID = selectedLineGroupIDs[station.id]
        return station.lineGroups.first { $0.id == selectedID } ?? station.defaultLineGroup
    }

    public mutating func saveSelectedLineGroup(_ lineGroup: Station.LineGroup, at station: Station) {
        selectedLineGroupIDs[station.id] = lineGroup.id
    }

    // MARK: - Seen Station Notices

    public func hasUnseenNotices(_ noticeTexts: some Sequence<String>, at stationID: Station.ID) -> Bool {
        !Set(noticeTexts).isSubset(of: seenStationNotices[stationID] ?? [])
    }

    public mutating func markNoticesSeen(_ noticeTexts: some Sequence<String>, at stationID: Station.ID) {
        seenStationNotices[stationID, default: []].formUnion(noticeTexts)
    }

    /// Forgets notices TfL no longer publishes, so the list doesn't grow forever and a notice that returns later
    /// counts as new.
    public mutating func pruneSeenNotices(keeping publishedNoticeTexts: [Station.ID: Set<String>]) {
        var pruned = [Station.ID: Set<String>]()
        for (stationID, seenTexts) in seenStationNotices {
            let stillPublished = seenTexts.intersection(publishedNoticeTexts[stationID] ?? [])
            if !stillPublished.isEmpty {
                pruned[stationID] = stillPublished
            }
        }
        // Avoids saving preferences, and redrawing every screen that reads them, when nothing changed
        if pruned != seenStationNotices {
            seenStationNotices = pruned
        }
    }

    // MARK: - Recent Selections

    public mutating func saveRecentlySelectedStation(_ stationID: Station.ID) {
        var updatedValues = recentlySelectedStations
        updatedValues.removeAll { $0 == stationID }
        updatedValues.insert(stationID, at: 0)
        recentlySelectedStations = Array(updatedValues.prefix(10))
    }

    public mutating func saveRecentJourney(_ journey: SavedJourney) {
        var updatedValues = recentlySavedJourneys

        if let existingIndex = recentlySavedJourneys.firstIndex(where: {
            $0.isSameJourney(as: journey)
        }) {
            updatedValues[existingIndex] = journey
        } else {
            updatedValues.insert(journey, at: 0)
        }

        recentlySavedJourneys = updatedValues
    }

    public mutating func cleanUpSavedJourneys() {
        var sanitizedJourneys = [SavedJourney]()

        recentlySavedJourneys
            .sortedByLastUsedDateDescending()
            .forEach { recentJourney in
                if !sanitizedJourneys.contains(where: {
                    $0.isSameOrReverseJourney(of: recentJourney)
                }) {
                    sanitizedJourneys.append(recentJourney)
                }
            }

        recentlySavedJourneys = Array(sanitizedJourneys.prefix(10))
    }

    public mutating func removeRecentJourney(_ journeyID: SavedJourney.ID) {
        recentlySavedJourneys.removeAll { $0.id == journeyID }
    }

    // MARK: - System Status

    public func hasReadSystemStatusMessage(id: SystemStatus.ID) -> Bool {
        readSystemStatusMessage == id
    }

    public mutating func markAsRead(systemStatusMessageID: SystemStatus.ID) {
        readSystemStatusMessage = systemStatusMessageID
    }
}

private extension Sequence where Element == SavedJourney {
    func sortedByLastUsedDateDescending() -> [SavedJourney] {
        sorted { $0.lastUsed > $1.lastUsed }
    }
}
