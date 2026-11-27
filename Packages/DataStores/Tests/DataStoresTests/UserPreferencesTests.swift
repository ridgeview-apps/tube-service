import Foundation
import Models
import Testing

@testable import DataStores

struct UserPreferencesTests {

    @Test
    func rawValueRoundTripPreservesPreferences() throws {
        var expected = UserPreferences.default
        expected.addFavouriteStop(.station(id: "HUBKGX"))
        expected.addFavouriteStop(.busStop(id: "490000129D"))
        expected.addFavouriteStop(.station(id: "940GZZLUAGL"))
        expected.addFavouriteLine(.bakerloo)
        expected.saveRecentlySelectedStation("940GZZLUAGL")
        expected.saveRecentlySelectedBusStop("490000129E")
        expected.saveSelectedLineGroup(stationWithTwoLineGroups.lineGroups[1], at: stationWithTwoLineGroups)
        expected.journeyModePreset = .custom([.tube, .walking])
        expected.markAsRead(systemStatusMessageID: "message")
        expected.saveRecentJourney(
            SavedJourney(
                id: UUID(),
                fromLocation: .station(id: "HUBKGX"),
                toLocation: .station(id: "940GZZLUAGL"),
                viaLocation: nil,
                lastUsed: Date(timeIntervalSince1970: 1_700_000_000)
            )
        )

        let decoded = try #require(UserPreferences(rawValue: expected.rawValue))

        #expect(decoded.favouriteStops == expected.favouriteStops)
        #expect(decoded.favouriteLineIDs == expected.favouriteLineIDs)
        #expect(decoded.recentlySelectedStations == expected.recentlySelectedStations)
        #expect(decoded.recentlySelectedBusStops == expected.recentlySelectedBusStops)
        #expect(decoded.selectedLineGroupIDs == expected.selectedLineGroupIDs)
        #expect(decoded.journeyModePreset == expected.journeyModePreset)
        #expect(decoded.recentlySavedJourneys == expected.recentlySavedJourneys)
        #expect(decoded.readSystemStatusMessage == expected.readSystemStatusMessage)
    }

    @Test
    func decodingOlderStoredValueUsesDefaultsForMissingPreferences() throws {
        let data = try #require(#"{"recentlySelectedStations":[]}"#.data(using: .utf8))

        let decoded = try JSONDecoder().decode(UserPreferences.self, from: data)

        #expect(decoded.favouriteStops.isEmpty)
        #expect(decoded.favouriteLineIDs.isEmpty)
        #expect(decoded.recentlySelectedStations.isEmpty)
        #expect(decoded.recentlySelectedBusStops.isEmpty)
        #expect(decoded.selectedLineGroupIDs.isEmpty)
        #expect(decoded.journeyModePreset == .trainAndBus)
        #expect(decoded.recentlySavedJourneys.isEmpty)
        #expect(decoded.readSystemStatusMessage == nil)
    }

    @Test
    func addingAndRemovingFavouriteLineIDs() throws {
        var userPreferences = UserPreferences.default

        // 1. Initially empty
        #expect(userPreferences.favouriteLineIDs.isEmpty)
        #expect(!userPreferences.containsFavouriteLine(.bakerloo))

        // 2. Add a line ID
        userPreferences.addFavouriteLine(.bakerloo)
        #expect(userPreferences.containsFavouriteLine(.bakerloo))

        // 3. Remove the line ID
        userPreferences.removeFavouriteLine(.bakerloo)
        #expect(!userPreferences.containsFavouriteLine(.bakerloo))
    }

    @Test
    func addingFavouriteLinesAppendsInOrderWithoutDuplicates() throws {
        var userPreferences = UserPreferences.default

        userPreferences.addFavouriteLine(.victoria)
        userPreferences.addFavouriteLine(.bakerloo)
        userPreferences.addFavouriteLine(.victoria)

        #expect(userPreferences.favouriteLineIDs == [.victoria, .bakerloo])
    }

    @Test
    func reorderingFavouriteLinesKeepsTheSameFavourites() throws {
        var userPreferences = UserPreferences.default
        userPreferences.addFavouriteLine(.victoria)
        userPreferences.addFavouriteLine(.bakerloo)
        userPreferences.addFavouriteLine(.northern)

        // Jubilee isn't a favourite (ignored) and Northern is missing (kept at the end)
        userPreferences.reorderFavouriteLines([.bakerloo, .jubilee, .victoria])

        #expect(userPreferences.favouriteLineIDs == [.bakerloo, .victoria, .northern])
    }

    @Test
    func decodingFavouriteLinesPreservesOrderAndRemovesDuplicates() throws {
        let json = #"{"favouriteLineIDs":["victoria","bakerloo","victoria","not-a-line"]}"#
        let data = try #require(json.data(using: .utf8))

        let decoded = try JSONDecoder().decode(UserPreferences.self, from: data)

        #expect(decoded.favouriteLineIDs == [.victoria, .bakerloo])
    }

    @Test
    func addingAndRemovingFavouriteStops() throws {
        var userPreferences = UserPreferences.default
        let kingsCross = FavouriteStop.station(id: "HUBKGX")

        // 1. Initially empty
        #expect(userPreferences.favouriteStops.isEmpty)
        #expect(!userPreferences.containsFavouriteStop(kingsCross))

        // 2. Add a stop
        userPreferences.addFavouriteStop(kingsCross)
        #expect(userPreferences.containsFavouriteStop(kingsCross))

        // 3. Remove the stop
        userPreferences.removeFavouriteStops([kingsCross])
        #expect(!userPreferences.containsFavouriteStop(kingsCross))
    }

    @Test
    func addingFavouriteStopsAppendsInOrderWithoutDuplicates() throws {
        var userPreferences = UserPreferences.default

        userPreferences.addFavouriteStop(.station(id: "HUBKGX"))
        userPreferences.addFavouriteStop(.station(id: "HUBPAD"))
        userPreferences.addFavouriteStop(.station(id: "HUBKGX"))

        #expect(userPreferences.favouriteStops == [.station(id: "HUBKGX"), .station(id: "HUBPAD")])
    }

    @Test
    func removingSeveralFavouriteStopsKeepsTheRest() throws {
        var userPreferences = UserPreferences.default
        userPreferences.addFavouriteStop(.station(id: "HUBKGX"))
        userPreferences.addFavouriteStop(.station(id: "HUBPAD"))
        userPreferences.addFavouriteStop(.station(id: "HUBABW"))

        userPreferences.removeFavouriteStops([.station(id: "HUBKGX"), .station(id: "HUBPAD")])

        #expect(userPreferences.favouriteStops == [.station(id: "HUBABW")])
    }

    @Test
    func reorderingFavouriteStopsKeepsTheSameFavourites() throws {
        var userPreferences = UserPreferences.default
        userPreferences.addFavouriteStop(.station(id: "HUBKGX"))
        userPreferences.addFavouriteStop(.station(id: "HUBPAD"))
        userPreferences.addFavouriteStop(.station(id: "HUBABW"))

        // Waterloo isn't a favourite (ignored) and Abbey Wood is missing (kept at the end)
        userPreferences.reorderFavouriteStops([.station(id: "HUBPAD"), .station(id: "HUBWAT"), .station(id: "HUBKGX")])

        #expect(
            userPreferences.favouriteStops == [.station(id: "HUBPAD"), .station(id: "HUBKGX"), .station(id: "HUBABW")]
        )
    }

    @Test
    func decodingFavouriteStopsSkipsUnknownStopTypesAndDuplicates() throws {
        let json = #"{"favouriteStops":[{"station":{"id":"HUBKGX"}},{"pier":{"id":"930GBSP"}},{"station":{"id":"HUBKGX"}}]}"#
        let data = try #require(json.data(using: .utf8))

        let decoded = try JSONDecoder().decode(UserPreferences.self, from: data)

        #expect(decoded.favouriteStops == [.station(id: "HUBKGX")])
    }

    @Test
    func decodingFavouriteStopsKeepsStationsAndBusStopsInOneOrder() throws {
        let decoded = try decodePreferences(
            #"{"favouriteStops":[{"busStop":{"id":"490000129D"}},{"station":{"id":"HUBKGX"}},{"busStop":{"id":"490000129E"}}]}"#
        )

        #expect(decoded.favouriteStops == [.busStop(id: "490000129D"), .station(id: "HUBKGX"), .busStop(id: "490000129E")])
        #expect(decoded.favouriteStops.busStopIDs == ["490000129D", "490000129E"])
    }

    // MARK: - Legacy favourites migration

    @Test
    func migratingLegacyFavouritesMapsALineGroupToItsStation() throws {
        let decoded = try decodePreferences(#"{"favourites":["940GZZLUKSX-victoria"]}"#)

        #expect(decoded.favouriteStops == [.station(id: "HUBKGX")])
    }

    @Test
    func migratingLegacyFavouritesMergesLineGroupsAtOneStation() throws {
        let decoded = try decodePreferences(
            #"{"favourites":["940GZZLUKSX-victoria","940GZZLUKSX-northern","910GPADTON-elizabeth","940GZZLUPAC-bakerloo"]}"#
        )

        #expect(decoded.favouriteStops == [.station(id: "HUBKGX"), .station(id: "HUBPAD")])
    }

    @Test
    func migratingLegacyFavouritesDropsUnknownIDs() throws {
        let decoded = try decodePreferences(#"{"favourites":["NOTANATCOCODE-victoria","line-group","910GABWDXR-elizabeth"]}"#)

        #expect(decoded.favouriteStops == [.station(id: "HUBABW")])
    }

    @Test
    func migratingLegacyFavouritesKeepsTheUsersOrderThenAlphabetical() throws {
        // Paddington and Abbey Wood were never dragged, and Waterloo is in the order but no longer a favourite
        let decoded = try decodePreferences(
            """
            {
                "favourites": ["940GZZLUPAC-bakerloo", "940GZZLUHBT-northern", "910GABWDXR-elizabeth", "940GZZLUKSX-victoria"],
                "favouriteStationOrder": ["HUBKGX", "HUBWAT", "940GZZLUHBT"]
            }
            """
        )

        #expect(
            decoded.favouriteStops == [
                .station(id: "HUBKGX"),
                .station(id: "940GZZLUHBT"),
                .station(id: "HUBABW"),
                .station(id: "HUBPAD")
            ]
        )
    }

    @Test
    func newFavouriteStopsTakePriorityOverLegacyFavourites() throws {
        let decoded = try decodePreferences(
            #"{"favouriteStops":[{"station":{"id":"HUBPAD"}}],"favourites":["940GZZLUKSX-victoria"],"favouriteStationOrder":["HUBKGX"]}"#
        )

        #expect(decoded.favouriteStops == [.station(id: "HUBPAD")])
    }

    @Test
    func encodingMigratedPreferencesDropsTheLegacyKeys() throws {
        let decoded = try decodePreferences(#"{"favourites":["940GZZLUKSX-victoria"],"favouriteStationOrder":["HUBKGX"]}"#)

        let encoded = try JSONSerialization.jsonObject(with: JSONEncoder().encode(decoded)) as? [String: Any]

        #expect(encoded?["favourites"] == nil)
        #expect(encoded?["favouriteStationOrder"] == nil)
        #expect(encoded?["favouriteStops"] != nil)
    }

    private func decodePreferences(_ json: String) throws -> UserPreferences {
        let data = try #require(json.data(using: .utf8))
        return try JSONDecoder().decode(UserPreferences.self, from: data)
    }

    @Test
    func saveRecentlyUsedStationID() throws {
        var userPreferences = UserPreferences.default

        let eastFinchleyStationID = "940GZZLUEFY"
        let angelStationID = "940GZZLUAGL"

        // 1. Initially empty
        #expect(userPreferences.recentlySelectedStations.isEmpty)

        // 2. Select Angel THEN East Finchley (twice)
        userPreferences.saveRecentlySelectedStation(angelStationID)
        userPreferences.saveRecentlySelectedStation(eastFinchleyStationID)
        userPreferences.saveRecentlySelectedStation(eastFinchleyStationID)  // Duplicate save (ignored)

        // 3. Verify most recent selection is East Finchley
        #expect(userPreferences.recentlySelectedStations == [eastFinchleyStationID, angelStationID])
    }

    @Test
    func clearRecentlySelectedStations() throws {
        var userPreferences = UserPreferences.default
        userPreferences.saveRecentlySelectedStation("940GZZLUAGL")
        userPreferences.saveRecentlySelectedStation("940GZZLUEFY")

        userPreferences.clearRecentlySelectedStations()

        #expect(userPreferences.recentlySelectedStations.isEmpty)
    }

    @Test
    func removingARecentStationKeepsTheOthersInOrder() throws {
        var userPreferences = UserPreferences.default
        userPreferences.saveRecentlySelectedStation("940GZZLUAGL")
        userPreferences.saveRecentlySelectedStation("940GZZLUEFY")
        userPreferences.saveRecentlySelectedStation("HUBKGX")

        userPreferences.removeRecentlySelectedStation("940GZZLUEFY")

        #expect(userPreferences.recentlySelectedStations == ["HUBKGX", "940GZZLUAGL"])
    }

    @Test
    func savingARecentBusStopPutsItFirstWithoutDuplicates() throws {
        var userPreferences = UserPreferences.default

        userPreferences.saveRecentlySelectedBusStop("490000129D")
        userPreferences.saveRecentlySelectedBusStop("490000129E")
        userPreferences.saveRecentlySelectedBusStop("490000129D")

        #expect(userPreferences.recentlySelectedBusStops == ["490000129D", "490000129E"])
    }

    @Test
    func recentBusStopsKeepTheLatestTen() throws {
        var userPreferences = UserPreferences.default

        for number in 1...11 {
            userPreferences.saveRecentlySelectedBusStop("stop-\(number)")
        }

        #expect(userPreferences.recentlySelectedBusStops == (2...11).reversed().map { "stop-\($0)" })
    }

    @Test
    func removingARecentBusStopKeepsTheOthersInOrder() throws {
        var userPreferences = UserPreferences.default
        userPreferences.saveRecentlySelectedBusStop("490000129D")
        userPreferences.saveRecentlySelectedBusStop("490000129E")
        userPreferences.saveRecentlySelectedBusStop("490000129R")

        userPreferences.removeRecentlySelectedBusStop("490000129E")

        #expect(userPreferences.recentlySelectedBusStops == ["490000129R", "490000129D"])
    }

    @Test
    func recentBusStopsAreSeparateFromRecentStations() throws {
        var userPreferences = UserPreferences.default
        userPreferences.saveRecentlySelectedStation("940GZZLUAGL")
        userPreferences.saveRecentlySelectedBusStop("490000129D")

        userPreferences.clearRecentlySelectedBusStops()

        #expect(userPreferences.recentlySelectedBusStops.isEmpty)
        #expect(userPreferences.recentlySelectedStations == ["940GZZLUAGL"])
    }

    // MARK: - Selected line groups

    // Victoria is listed before Northern so the default (first by name) differs from the first in the seed data
    private let stationWithTwoLineGroups = Station(
        id: "HUBKGX",
        icsCode: "1000129",
        name: "King's Cross St. Pancras",
        location: LocationCoordinate(lat: 51.530, lon: -0.123),
        lineGroups: [
            .init(atcoCode: "940GZZLUKSX", lineIds: [.victoria]),
            .init(atcoCode: "940GZZLUKSX", lineIds: [.northern])
        ]
    )

    @Test
    func selectedLineGroupDefaultsToTheFirstByName() throws {
        let userPreferences = UserPreferences.default

        #expect(userPreferences.selectedLineGroup(at: stationWithTwoLineGroups)?.lineIds == [.northern])
    }

    @Test
    func selectedLineGroupIsRememberedPerStation() throws {
        var userPreferences = UserPreferences.default

        userPreferences.saveSelectedLineGroup(stationWithTwoLineGroups.lineGroups[0], at: stationWithTwoLineGroups)

        #expect(userPreferences.selectedLineGroup(at: stationWithTwoLineGroups)?.lineIds == [.victoria])
    }

    @Test
    func selectedLineGroupThatNoLongerExistsFallsBackToTheDefault() throws {
        let json = #"{"selectedLineGroupIDs":{"HUBKGX":"940GZZLUKSX-piccadilly,victoria"}}"#
        let decoded = try decodePreferences(json)

        #expect(decoded.selectedLineGroup(at: stationWithTwoLineGroups)?.lineIds == [.northern])
    }

    @Test
    func saveJourneyModePreset() throws {
        var userPreferences = UserPreferences.default

        userPreferences.journeyModePreset = .custom([.tube, .walking])

        #expect(userPreferences.journeyModePreset == .custom([.tube, .walking]))
    }

    @Test
    func addingAndRemovingARecentJourney() throws {
        // Given
        var userPreferences = UserPreferences.default

        let kingsCrossStationID = "HUBKGX"
        let angelStationID = "940GZZLUAGL"

        let journey = SavedJourney(
            id: UUID(),
            fromLocation: .station(id: kingsCrossStationID),
            toLocation: .station(id: angelStationID),
            viaLocation: nil,
            lastUsed: .now
        )

        // When
        let initialValue = userPreferences.recentlySavedJourneys
        userPreferences.saveRecentJourney(journey)
        let firstSavedValue = userPreferences.recentlySavedJourneys
        userPreferences.removeRecentJourney(journey.id)
        let finalSavedValue = userPreferences.recentlySavedJourneys

        // Then
        #expect(initialValue.isEmpty)
        #expect(firstSavedValue == [journey])
        #expect(finalSavedValue.isEmpty)
    }

    @Test
    func clearRecentJourneys() throws {
        var userPreferences = UserPreferences.default
        userPreferences.saveRecentJourney(
            SavedJourney(
                id: UUID(),
                fromLocation: .station(id: "HUBKGX"),
                toLocation: .station(id: "940GZZLUAGL"),
                viaLocation: nil,
                lastUsed: .now
            )
        )
        userPreferences.saveRecentJourney(
            SavedJourney(
                id: UUID(),
                fromLocation: .station(id: "940GZZLUEFY"),
                toLocation: .station(id: "HUBKGX"),
                viaLocation: nil,
                lastUsed: .now
            )
        )

        userPreferences.clearRecentJourneys()

        #expect(userPreferences.recentlySavedJourneys.isEmpty)
    }

    @Test
    func saveDuplicateJourneys_savesMostRecentValueOnly() throws {
        // Given
        var userPreferences = UserPreferences.default
        let wasInitiallyEmpty = userPreferences.recentlySavedJourneys.isEmpty

        let kingsCrossStationID = "HUBKGX"
        let angelStationID = "940GZZLUAGL"

        let timestamp1 = Date.utc(year: 2024, month: 4, day: 15)!
        let duplicateJourney1 = SavedJourney(
            id: UUID(),
            fromLocation: .station(id: kingsCrossStationID),
            toLocation: .station(id: angelStationID),
            viaLocation: nil,
            lastUsed: timestamp1
        )

        let timestamp2 = Date.utc(year: 2024, month: 4, day: 16)!
        let duplicateJourney2 = SavedJourney(
            id: UUID(),
            fromLocation: .station(id: kingsCrossStationID),
            toLocation: .station(id: angelStationID),
            viaLocation: nil,
            lastUsed: timestamp2
        )

        let timestamp3 = Date.utc(year: 2024, month: 4, day: 17)!
        let duplicateJourney3 = SavedJourney(
            id: UUID(),
            fromLocation: .station(id: kingsCrossStationID),
            toLocation: .station(id: angelStationID),
            viaLocation: nil,
            lastUsed: timestamp3
        )

        // When
        userPreferences.saveRecentJourney(duplicateJourney1)
        userPreferences.saveRecentJourney(duplicateJourney2)
        userPreferences.saveRecentJourney(duplicateJourney3)

        // Then
        #expect(wasInitiallyEmpty)
        #expect(userPreferences.recentlySavedJourneys.count == 1)
        #expect(userPreferences.recentlySavedJourneys.first == duplicateJourney3)  // N.B. Journey with most recent timestamp saved
    }

    @Test
    func saveJourneyFromNearbyPlaceWithDifferentName_replacesExistingJourney() throws {
        // Given
        var userPreferences = UserPreferences.default
        let angelStationID = "940GZZLUAGL"

        let oldJourney = SavedJourney(
            id: UUID(),
            fromLocation: .specific(
                LocationName(title: "Pentonville Road", subtitle: "Islington"),
                LocationCoordinate(lat: 51.531504, lon: -0.113384)
            ),
            toLocation: .station(id: angelStationID),
            viaLocation: nil,
            lastUsed: Date.utc(year: 2024, month: 4, day: 15)!
        )
        let newJourneyAbout50MetresAway = SavedJourney(
            id: UUID(),
            fromLocation: .specific(
                LocationName(title: "144 Pentonville Road", subtitle: "Islington, London"),
                LocationCoordinate(lat: 51.531900, lon: -0.113000)
            ),
            toLocation: .station(id: angelStationID),
            viaLocation: nil,
            lastUsed: Date.utc(year: 2024, month: 4, day: 16)!
        )

        // When
        userPreferences.saveRecentJourney(oldJourney)
        userPreferences.saveRecentJourney(newJourneyAbout50MetresAway)

        // Then
        #expect(userPreferences.recentlySavedJourneys == [newJourneyAbout50MetresAway])
    }

    @Test
    func saveJourneyFromSameNamedPlaceFarAway_keepsBothJourneys() throws {
        // Given
        var userPreferences = UserPreferences.default
        let angelStationID = "940GZZLUAGL"
        let edgwareRoad = LocationName(title: "Edgware Road", subtitle: "Barnet")

        let journeyFromOneEnd = SavedJourney(
            id: UUID(),
            fromLocation: .specific(edgwareRoad, LocationCoordinate(lat: 51.5780, lon: -0.2310)),
            toLocation: .station(id: angelStationID),
            viaLocation: nil,
            lastUsed: Date.utc(year: 2024, month: 4, day: 15)!
        )
        let journeyFromAbout2KilometresAway = SavedJourney(
            id: UUID(),
            fromLocation: .specific(edgwareRoad, LocationCoordinate(lat: 51.5960, lon: -0.2500)),
            toLocation: .station(id: angelStationID),
            viaLocation: nil,
            lastUsed: Date.utc(year: 2024, month: 4, day: 16)!
        )

        // When
        userPreferences.saveRecentJourney(journeyFromOneEnd)
        userPreferences.saveRecentJourney(journeyFromAbout2KilometresAway)

        // Then
        #expect(userPreferences.recentlySavedJourneys.count == 2)
    }

    @Test
    func cleanUpSavedJourneys_sortsMostRecentlyUsedFirst() throws {
        // Given
        var userPreferences = UserPreferences.default

        let kingsCrossStationID = "HUBKGX"
        let angelStationID = "940GZZLUAGL"

        let timestamp1 = Date.utc(year: 2024, month: 4, day: 15)!
        let outboundJourney = SavedJourney(
            id: UUID(),
            fromLocation: .station(id: kingsCrossStationID),
            toLocation: .station(id: angelStationID),
            viaLocation: nil,
            lastUsed: timestamp1
        )

        let timestamp2 = Date.utc(year: 2024, month: 4, day: 16)!
        let returnJourney = SavedJourney(
            id: UUID(),
            fromLocation: .station(id: angelStationID),
            toLocation: .station(id: kingsCrossStationID),
            viaLocation: nil,
            lastUsed: timestamp2
        )

        // When
        let journeyCountBeforeInitialSave = userPreferences.recentlySavedJourneys.count
        userPreferences.saveRecentJourney(outboundJourney)
        userPreferences.saveRecentJourney(returnJourney)
        let journeyCountAfterInitialSave = userPreferences.recentlySavedJourneys.count

        userPreferences.cleanUpSavedJourneys()  // Remove duplicate / reverse journeys
        let journeyCountAfterCleanUp = userPreferences.recentlySavedJourneys.count

        // Then
        #expect(journeyCountBeforeInitialSave == 0)
        #expect(journeyCountAfterInitialSave == 2)  //
        #expect(journeyCountAfterCleanUp == 1)
        #expect(userPreferences.recentlySavedJourneys.first == returnJourney)  // N.B. Journey with most recent timestamp saved
    }

    @Test
    func markSystemStatusMessageAsRead() throws {
        var userPreferences = UserPreferences.default

        let messageID1 = "messageID1"
        let messageID2 = "messageID2"

        // 1. Check message 1 is unread
        #expect(userPreferences.readSystemStatusMessage == nil)
        #expect(!userPreferences.hasReadSystemStatusMessage(id: messageID1))

        // 2. Mark message 1 as read
        userPreferences.markAsRead(systemStatusMessageID: messageID1)
        #expect(userPreferences.hasReadSystemStatusMessage(id: messageID1))

        // 3. Check new message 2 is unread
        #expect(!userPreferences.hasReadSystemStatusMessage(id: messageID2))

    }
}
