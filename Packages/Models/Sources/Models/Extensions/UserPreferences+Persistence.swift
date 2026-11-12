import Foundation
import Shared

extension UserPreferences {
    enum CodingKeys: String, CodingKey {
        case favouriteStops
        case recentlySelectedStations
        case selectedLineGroupIDs
        case favouriteLineIDs
        case journeyModePreset
        case recentlySavedJourneys
        case readSystemStatusMessage
    }

    // Manual decoding allows new preferences to gain defaults when reading older stored values.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let stops = try? container.decode(LossyDecodableArray<FavouriteStop>.self, forKey: .favouriteStops) {
            favouriteStops = stops.elements.removingDuplicates()
        } else {
            favouriteStops = try Self.migratedLegacyFavouriteStops(from: decoder)
        }
        recentlySelectedStations = (try? container.decode([Station.ID].self, forKey: .recentlySelectedStations)) ?? []
        selectedLineGroupIDs =
            (try? container.decode([Station.ID: Station.LineGroup.ID].self, forKey: .selectedLineGroupIDs)) ?? [:]

        let rawLineIDs = (try? container.decode([String].self, forKey: .favouriteLineIDs)) ?? []
        favouriteLineIDs = rawLineIDs.compactMap { TrainLineID(rawValue: $0) }.removingDuplicates()

        journeyModePreset = (try? container.decode(JourneyModePreset.self, forKey: .journeyModePreset)) ?? .trainAndBus

        recentlySavedJourneys = (try? container.decode([SavedJourney].self, forKey: .recentlySavedJourneys)) ?? []
        readSystemStatusMessage = try? container.decodeIfPresent(SystemStatus.ID.self, forKey: .readSystemStatusMessage)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(favouriteStops, forKey: .favouriteStops)
        try container.encode(recentlySelectedStations, forKey: .recentlySelectedStations)
        try container.encode(selectedLineGroupIDs, forKey: .selectedLineGroupIDs)
        try container.encode(favouriteLineIDs, forKey: .favouriteLineIDs)
        try container.encode(journeyModePreset, forKey: .journeyModePreset)
        try container.encode(recentlySavedJourneys, forKey: .recentlySavedJourneys)
        try container.encode(readSystemStatusMessage, forKey: .readSystemStatusMessage)
    }
}

// MARK: - Legacy favourites migration

extension UserPreferences {
    private enum LegacyCodingKeys: String, CodingKey {
        case favouriteLineGroupIDs = "favourites"
        case favouriteStationOrder
    }

    // Runs while decoding rather than at app start, because `@AppStorage` screens can decode and write
    // preferences back before start-up work runs, which would lose the legacy keys.
    private static func migratedLegacyFavouriteStops(from decoder: any Decoder) throws -> [FavouriteStop] {
        let container = try decoder.container(keyedBy: LegacyCodingKeys.self)
        let lineGroupIDs = (try? container.decode([Station.LineGroup.ID].self, forKey: .favouriteLineGroupIDs)) ?? []
        let stationOrder = (try? container.decode([Station.ID].self, forKey: .favouriteStationOrder)) ?? []
        return migratedFavouriteStops(lineGroupIDs: lineGroupIDs, stationOrder: stationOrder)
    }

    /// Maps legacy line group favourites to their stations, in the order the app used to show them:
    /// the user's dragged order first, then the rest alphabetically. IDs matching no station are dropped.
    private static func migratedFavouriteStops(
        lineGroupIDs: [Station.LineGroup.ID],
        stationOrder: [Station.ID]
    ) -> [FavouriteStop] {
        guard !lineGroupIDs.isEmpty else { return [] }
        let stations = Station.allLondonTrains
        let stationIDsByAtcoCode = stations.stationIDsByAtcoCode
        // Line group IDs are "atcoCode-lineIDs", so matching on the ATCO code survives lines being regrouped
        let favouriteStationIDs = Set(
            lineGroupIDs.compactMap { lineGroupID in
                lineGroupID.split(separator: "-", maxSplits: 1).first.flatMap { stationIDsByAtcoCode[String($0)] }
            }
        )

        let orderedStationIDs = stationOrder.removingDuplicates().filter { favouriteStationIDs.contains($0) }
        let unorderedStationIDs =
            stations
            .filter { favouriteStationIDs.contains($0.id) && !orderedStationIDs.contains($0.id) }
            .sorted { $0.name < $1.name }
            .map(\.id)

        return (orderedStationIDs + unorderedStationIDs).map { .station(id: $0) }
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
