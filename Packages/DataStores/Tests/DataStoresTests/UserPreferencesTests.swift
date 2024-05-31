@testable import DataStores

import Models
import ModelStubs
import XCTest

final class UserPreferencesTests: XCTestCase {
    
    func testAddingAndRemovingFavouriteLineIDs() throws {
        var userPreferences = UserPreferences.default
        
        // 1. Initially empty
        XCTAssertTrue(userPreferences.favouriteLineIDs.isEmpty)
        XCTAssertFalse(userPreferences.containsFavouriteLine(.bakerloo))
        
        // 2. Add a line ID
        userPreferences.addFavouriteLine(.bakerloo)
        XCTAssertTrue(userPreferences.containsFavouriteLine(.bakerloo))
        
        // 3. Remove the line ID
        userPreferences.removeFavouriteLine(.bakerloo)
        XCTAssertFalse(userPreferences.containsFavouriteLine(.bakerloo))
    }
    
    func testAddingAndRemovingFavouriteLineGroupIDs() throws {
        var userPreferences = UserPreferences.default
        let fakeID = "FakeLineGroupID"
        
        // 1. Initially empty
        XCTAssertTrue(userPreferences.favouriteLineGroupIDs.isEmpty)
        XCTAssertFalse(userPreferences.containsFavouriteLineGroup(fakeID))
        
        // 2. Add a line group ID
        userPreferences.addFavouriteLineGroup(fakeID)
        XCTAssertTrue(userPreferences.containsFavouriteLineGroup(fakeID))
        
        // 3. Remove the line group ID
        userPreferences.removeFavouriteLineGroup(fakeID)
        XCTAssertFalse(userPreferences.containsFavouriteLineGroup(fakeID))
    }
    
    func testSaveRecentlyUsedStationID() throws {
        var userPreferences = UserPreferences.default
        
        let eastFinchleyStationID = ModelStubs.eastFinchleyStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        // 1. Initially empty
        XCTAssertTrue(userPreferences.recentlySelectedStations.isEmpty)
        
        // 2. Select Angel THEN East Finchley (twice)
        userPreferences.saveRecentlySelectedStation(angelStationID)
        userPreferences.saveRecentlySelectedStation(eastFinchleyStationID)
        userPreferences.saveRecentlySelectedStation(eastFinchleyStationID) // Duplicate save (ignored)
        
        // 3. Verify most recent selection is East Finchley
        XCTAssertEqual(userPreferences.recentlySelectedStations, [eastFinchleyStationID, angelStationID])
    }
    
    func testSaveModeIDs() throws {
        var userPreferences = UserPreferences.default
        
        userPreferences.saveJourneyPlannerModes([.tube, .walking])
        
        XCTAssertEqual(userPreferences.journeyPlannerModeIDs, [.tube, .walking])
    }
    
    func testAddingAndRemovingARecentJourney() throws {
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
        XCTAssertTrue(initialValue.isEmpty)
        XCTAssertEqual(firstSavedValue, [journey])
        XCTAssertTrue(finalSavedValue.isEmpty)
    }
    
    func testSaveDuplicateJourneys_savesMostRecentValueOnly() throws {
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
        XCTAssertTrue(wasInitiallyEmpty)
        XCTAssertEqual(userPreferences.recentlySavedJourneys.count, 1)
        XCTAssertEqual(userPreferences.recentlySavedJourneys.first, duplicateJourney3) // N.B. Journey with most recent timestamp saved
    }
    
    @MainActor
    func testCleanUpSavedJourneys_sortsMostRecentlyUsedFirst() throws {
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
        let journeyCountAfterSanitize = userPreferences.recentlySavedJourneys.count
        
        // Then
        XCTAssertEqual(0, journeyCountBeforeInitialSave)
        XCTAssertEqual(2, journeyCountAfterInitialSave) //
        XCTAssertEqual(1, journeyCountAfterSanitize)
        XCTAssertEqual(userPreferences.recentlySavedJourneys.first, returnJourney) // N.B. Journey with most recent timestamp saved
    }
}
