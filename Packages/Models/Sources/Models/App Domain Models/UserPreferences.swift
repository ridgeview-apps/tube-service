import Foundation

public struct UserPreferences: Equatable, Codable, Sendable {

    public static let `default`: UserPreferences = .init(
        favouriteLineGroupIDs: [],
        favouriteLineIDs: [],
        recentlySelectedStations: [],
        journeyModePreset: .trainAndBus,
        recentlySavedJourneys: [],
        readSystemStatusMessage: nil,
        hasCompletedNotificationsOnboarding: false
    )

    public var favouriteLineGroupIDs: Set<Station.LineGroup.ID>
    public var favouriteLineIDs: Set<Line.ID>
    public var recentlySelectedStations: [Station.ID]
    public var journeyModePreset: JourneyModePreset
    public var recentlySavedJourneys: [SavedJourney]
    public var readSystemStatusMessage: SystemStatus.ID?
    public var hasCompletedNotificationsOnboarding: Bool

    public init(
        favouriteLineGroupIDs: Set<Station.LineGroup.ID>,
        favouriteLineIDs: Set<Line.ID> = [],
        recentlySelectedStations: [Station.ID] = [],
        journeyModePreset: JourneyModePreset,
        recentlySavedJourneys: [SavedJourney],
        readSystemStatusMessage: SystemStatus.ID?,
        hasCompletedNotificationsOnboarding: Bool = false
    ) {
        self.favouriteLineGroupIDs = favouriteLineGroupIDs
        self.favouriteLineIDs = favouriteLineIDs
        self.recentlySelectedStations = recentlySelectedStations
        self.journeyModePreset = journeyModePreset
        self.recentlySavedJourneys = recentlySavedJourneys
        self.readSystemStatusMessage = readSystemStatusMessage
        self.hasCompletedNotificationsOnboarding = hasCompletedNotificationsOnboarding
    }

    // MARK: - Favourite Lines

    public func containsFavouriteLineGroup(_ lineGroupID: Station.LineGroup.ID) -> Bool {
        favouriteLineGroupIDs.contains(lineGroupID)
    }

    public mutating func addFavouriteLineGroup(_ favouriteLineGroupID: Station.LineGroup.ID) {
        favouriteLineGroupIDs.insert(favouriteLineGroupID)
    }

    public mutating func removeFavouriteLineGroup(_ favouriteLineGroupID: Station.LineGroup.ID) {
        favouriteLineGroupIDs.remove(favouriteLineGroupID)
    }

    public func containsFavouriteLine(_ lineID: TrainLineID) -> Bool {
        favouriteLineIDs.contains(lineID)
    }

    public mutating func addFavouriteLine(_ favouriteLineID: TrainLineID) {
        favouriteLineIDs.insert(favouriteLineID)
    }

    public mutating func removeFavouriteLine(_ favouriteLineID: TrainLineID) {
        favouriteLineIDs.remove(favouriteLineID)
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
