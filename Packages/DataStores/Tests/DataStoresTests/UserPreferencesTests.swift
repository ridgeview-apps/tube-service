import Foundation
import Models
import ModelStubs
import Testing

@testable import DataStores

struct UserPreferencesTests {
    
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
    func addingAndRemovingFavouriteLineGroupIDs() throws {
        var userPreferences = UserPreferences.default
        let fakeID = "FakeLineGroupID"
        
        // 1. Initially empty
        #expect(userPreferences.favouriteLineGroupIDs.isEmpty)
        #expect(!userPreferences.containsFavouriteLineGroup(fakeID))
        
        // 2. Add a line group ID
        userPreferences.addFavouriteLineGroup(fakeID)
        #expect(userPreferences.containsFavouriteLineGroup(fakeID))
        
        // 3. Remove the line group ID
        userPreferences.removeFavouriteLineGroup(fakeID)
        #expect(!userPreferences.containsFavouriteLineGroup(fakeID))
    }
    
    @Test
    func saveRecentlyUsedStationID() throws {
        var userPreferences = UserPreferences.default
        
        let eastFinchleyStationID = ModelStubs.eastFinchleyStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        // 1. Initially empty
        #expect(userPreferences.recentlySelectedStations.isEmpty)
        
        // 2. Select Angel THEN East Finchley (twice)
        userPreferences.saveRecentlySelectedStation(angelStationID)
        userPreferences.saveRecentlySelectedStation(eastFinchleyStationID)
        userPreferences.saveRecentlySelectedStation(eastFinchleyStationID) // Duplicate save (ignored)
        
        // 3. Verify most recent selection is East Finchley
        #expect(userPreferences.recentlySelectedStations == [eastFinchleyStationID, angelStationID])
    }
    
    @Test
    func saveModeIDs() throws {
        var userPreferences = UserPreferences.default
        
        userPreferences.saveJourneyPlannerModes([.tube, .walking])
        
        #expect(userPreferences.journeyPlannerModeIDs == [.tube, .walking])
    }
    
    @Test
    func addingAndRemovingARecentJourney() throws {
        // Given
        var userPreferences = UserPreferences.default
        
        let kingsCrossStationID = ModelStubs.kingsCrossStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        let journey = SavedJourney(id: UUID(),
                                   fromLocation: .station(id: kingsCrossStationID),
                                   toLocation: .station(id: angelStationID),
                                   viaLocation: nil,
                                   lastUsed: .now)
        
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
    func saveDuplicateJourneys_savesMostRecentValueOnly() throws {
        // Given
        var userPreferences = UserPreferences.default
        let wasInitiallyEmpty = userPreferences.recentlySavedJourneys.isEmpty
        
        let kingsCrossStationID = ModelStubs.kingsCrossStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        let timestamp1 = Date.UTC(year: 2024, month: 4, day: 15)!
        let duplicateJourney1 = SavedJourney(id: UUID(),
                                             fromLocation: .station(id: kingsCrossStationID),
                                             toLocation: .station(id: angelStationID),
                                             viaLocation: nil,
                                             lastUsed: timestamp1)
        
        let timestamp2 = Date.UTC(year: 2024, month: 4, day: 16)!
        let duplicateJourney2 = SavedJourney(id: UUID(),
                                             fromLocation: .station(id: kingsCrossStationID),
                                             toLocation: .station(id: angelStationID),
                                             viaLocation: nil,
                                             lastUsed: timestamp2)
        
        let timestamp3 = Date.UTC(year: 2024, month: 4, day: 17)!
        let duplicateJourney3 = SavedJourney(id: UUID(),
                                             fromLocation: .station(id: kingsCrossStationID),
                                             toLocation: .station(id: angelStationID),
                                             viaLocation: nil,
                                             lastUsed: timestamp3)
        
        // When
        userPreferences.saveRecentJourney(duplicateJourney1)
        userPreferences.saveRecentJourney(duplicateJourney2)
        userPreferences.saveRecentJourney(duplicateJourney3)
        
        // Then
        #expect(wasInitiallyEmpty)
        #expect(userPreferences.recentlySavedJourneys.count == 1)
        #expect(userPreferences.recentlySavedJourneys.first == duplicateJourney3) // N.B. Journey with most recent timestamp saved
    }
    
    @Test
    func cleanUpSavedJourneys_sortsMostRecentlyUsedFirst() throws {
        // Given
        var userPreferences = UserPreferences.default
        
        let kingsCrossStationID = ModelStubs.kingsCrossStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        let timestamp1 = Date.UTC(year: 2024, month: 4, day: 15)!
        let outboundJourney = SavedJourney(id: UUID(),
                                           fromLocation: .station(id: kingsCrossStationID),
                                           toLocation: .station(id: angelStationID),
                                           viaLocation: nil,
                                           lastUsed: timestamp1)
        
        let timestamp2 = Date.UTC(year: 2024, month: 4, day: 16)!
        let returnJourney = SavedJourney(id: UUID(),
                                         fromLocation: .station(id: angelStationID),
                                         toLocation: .station(id: kingsCrossStationID),
                                         viaLocation: nil,
                                         lastUsed: timestamp2)
        
        // When
        let journeyCountBeforeInitialSave = userPreferences.recentlySavedJourneys.count
        userPreferences.saveRecentJourney(outboundJourney)
        userPreferences.saveRecentJourney(returnJourney)
        let journeyCountAfterInitialSave = userPreferences.recentlySavedJourneys.count
        
        userPreferences.cleanUpSavedJourneys() // Remove duplicate / reverse journeys
        let journeyCountAfterCleanUp = userPreferences.recentlySavedJourneys.count
        
        // Then
        #expect(journeyCountBeforeInitialSave == 0)
        #expect(journeyCountAfterInitialSave == 2) //
        #expect(journeyCountAfterCleanUp == 1)
        #expect(userPreferences.recentlySavedJourneys.first == returnJourney) // N.B. Journey with most recent timestamp saved
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
