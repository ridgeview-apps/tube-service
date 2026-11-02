import Foundation
import Shared

extension UserPreferences {
    enum CodingKeys: String, CodingKey {
        case favouriteLineGroupIDs = "favourites"
        case recentlySelectedStations
        case favouriteLineIDs
        case favouriteStationOrder
        case journeyModePreset
        case recentlySavedJourneys
        case readSystemStatusMessage
    }

    // Manual decoding allows new preferences to gain defaults when reading older stored values.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        favouriteLineGroupIDs = (try? container.decode(Set<Station.LineGroup.ID>.self, forKey: .favouriteLineGroupIDs)) ?? []
        recentlySelectedStations = (try? container.decode([Station.ID].self, forKey: .recentlySelectedStations)) ?? []

        let rawLineIDs = (try? container.decode([String].self, forKey: .favouriteLineIDs)) ?? []
        favouriteLineIDs = rawLineIDs.compactMap { TrainLineID(rawValue: $0) }.removingDuplicates()
        favouriteStationOrder = ((try? container.decode([Station.ID].self, forKey: .favouriteStationOrder)) ?? []).removingDuplicates()

        journeyModePreset = (try? container.decode(JourneyModePreset.self, forKey: .journeyModePreset)) ?? .trainAndBus

        recentlySavedJourneys = (try? container.decode([SavedJourney].self, forKey: .recentlySavedJourneys)) ?? []
        readSystemStatusMessage = try? container.decodeIfPresent(SystemStatus.ID.self, forKey: .readSystemStatusMessage)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(favouriteLineGroupIDs, forKey: .favouriteLineGroupIDs)
        try container.encode(recentlySelectedStations, forKey: .recentlySelectedStations)
        try container.encode(favouriteLineIDs, forKey: .favouriteLineIDs)
        try container.encode(favouriteStationOrder, forKey: .favouriteStationOrder)
        try container.encode(journeyModePreset, forKey: .journeyModePreset)
        try container.encode(recentlySavedJourneys, forKey: .recentlySavedJourneys)
        try container.encode(readSystemStatusMessage, forKey: .readSystemStatusMessage)
    }
}

extension UserPreferences: RawRepresentable {
    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        guard
            let data = rawValue.data(using: .utf8),
            let decoded = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return nil
        }
        self = decoded
    }

    public var rawValue: RawValue {
        guard
            let data = try? JSONEncoder().encode(self),
            let encodedValue = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return encodedValue
    }
}
