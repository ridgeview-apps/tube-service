@testable import DataStores

import Models
import ModelStubs
import XCTest

final class UserPreferencesDataStoreTests: XCTestCase {
    
    @MainActor
    func testLoadUserPreferences_initiallyEmpty() throws {
        // Given
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        // When
        let initialValue = userPreferences.value

        // Then
        XCTAssertEqual(initialValue, .default)
    }
    
    @MainActor
    func testLoadUserPreferences_initiallyPopulated() throws {
        // Given
        let userDefaults = UserDefaults.singleTestUserDefaults()
        let initialPopulatedValue = UserPreferences(favouriteLineGroupIDs: ["ExampleID1", "ExampleID2"],
                                                    favouriteLineIDs: [.bakerloo, .northern],
                                                    recentlySelectedStations: ["ExampleID1"],
                                                    journeyPlannerModeIDs: Set(ModeID.defaultJourneyPlannerModeIDs),
                                                    recentlySavedJourneys: [.init(id: UUID(),
                                                                                  fromLocation: .station(id: ModelStubs.eastFinchleyStation.id),
                                                                                  toLocation: .station(id: ModelStubs.angelStation.id),
                                                                                  viaLocation: nil,
                                                                                  lastUsed: .now)])
        userDefaults.userPreferences = initialPopulatedValue
        
        let userPreferences = UserPreferencesDataStore(userDefaults: userDefaults)
        
        // When
        let initialValue = userPreferences.value

        // Then
        XCTAssertEqual(initialValue, initialPopulatedValue)
    }
    
    @MainActor
    func testAddingAndRemovingFavouriteLineIDs() throws {
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        // 1. Initially empty
        XCTAssertTrue(userPreferences.favouriteLineIDs.isEmpty)
        XCTAssertFalse(userPreferences.isFavourite(lineID: .bakerloo))
        
        // 2. Add a line ID
        userPreferences.add(favouriteLineID: .bakerloo)
        XCTAssertTrue(userPreferences.isFavourite(lineID: .bakerloo))
        
        // 3. Remove the line ID
        userPreferences.remove(favouriteLineID: .bakerloo)
        XCTAssertFalse(userPreferences.isFavourite(lineID: .bakerloo))
    }
    
    @MainActor
    func testAddingAndRemovingFavouriteLineGroupIDs() throws {
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        let fakeID = "FakeLineGroupID"
        
        // 1. Initially empty
        XCTAssertTrue(userPreferences.favouriteLineGroupIDs.isEmpty)
        XCTAssertFalse(userPreferences.isFavourite(lineGroupID: fakeID))
        
        // 2. Add a line group ID
        userPreferences.add(favouriteLineGroupID: fakeID)
        XCTAssertTrue(userPreferences.isFavourite(lineGroupID: fakeID))
        
        // 3. Remove the line group ID
        userPreferences.remove(favouriteLineGroupID: fakeID)
        XCTAssertFalse(userPreferences.isFavourite(lineGroupID: fakeID))
    }
    
    @MainActor
    func testSaveRecentlyUsedStationID() throws {
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        let eastFinchleyStationID = ModelStubs.eastFinchleyStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        // 1. Initially empty
        XCTAssertTrue(userPreferences.recentlySelectedStations.isEmpty)
        
        // 2. Select Angel THEN East Finchley (twice)
        userPreferences.save(recentlySelectedStationID: angelStationID)
        userPreferences.save(recentlySelectedStationID: eastFinchleyStationID)
        userPreferences.save(recentlySelectedStationID: eastFinchleyStationID) // Duplicate save (ignored)
        
        // 3. Verify most recent selection is East Finchley
        XCTAssertEqual(userPreferences.recentlySelectedStations, [eastFinchleyStationID, angelStationID])
    }
    
    @MainActor
    func testSaveModeIDs() throws {
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        userPreferences.save(journeyPlannerModeIDs: Set([.tube, .walking]))
        
        XCTAssertEqual(userPreferences.journeyPlannerModeIDs, [.tube, .walking])
    }
    
    @MainActor
    func testAddingAndRemovingASavedJourney() throws {
        // Given
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        let kingsCrossStationID = ModelStubs.kingsCrossStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        let journey = SavedJourney(id: UUID(),
                                   fromLocation: .station(id: kingsCrossStationID),
                                   toLocation: .station(id: angelStationID),
                                   viaLocation: nil,
                                   lastUsed: .now)
        
        // When
        let initialValue = userPreferences.recentlySavedJourneys
        userPreferences.insertOrReplace(journey: journey) // Add a journey
        let firstSavedValue = userPreferences.recentlySavedJourneys
        userPreferences.remove(recentJourneyID: journey.id) // Remove the journey
        let finalSavedValue = userPreferences.recentlySavedJourneys
        
        // Then
        XCTAssertTrue(initialValue.isEmpty)
        XCTAssertEqual(firstSavedValue, [journey])
        XCTAssertTrue(finalSavedValue.isEmpty)
    }
    
    @MainActor
    func testSaveDuplicateJourneys_savesMostRecentValueOnly() throws {
        // Given
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
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
        userPreferences.insertOrReplace(journey: duplicateJourney1)
        userPreferences.insertOrReplace(journey: duplicateJourney2)
        userPreferences.insertOrReplace(journey: duplicateJourney3)
        
        // Then
        XCTAssertTrue(wasInitiallyEmpty)
        XCTAssertEqual(userPreferences.recentlySavedJourneys.count, 1)
        XCTAssertEqual(userPreferences.recentlySavedJourneys.first, duplicateJourney3) // N.B. Journey with most recent timestamp saved
    }
    
    @MainActor
    func testRepairSavedJourneys_sortsMostRecentlyUsedFirst() throws {
        // Given
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
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
        userPreferences.insertOrReplace(journey: outboundJourney)
        userPreferences.insertOrReplace(journey: returnJourney)
        let journeyCountAfterInitialSave = userPreferences.recentlySavedJourneys.count
        
        userPreferences.refreshAndRepairSavedJourneyData() // Remove duplicate / reverse journeys
        let journeyCountAfterSanitize = userPreferences.recentlySavedJourneys.count
        
        // Then
        XCTAssertEqual(0, journeyCountBeforeInitialSave)
        XCTAssertEqual(2, journeyCountAfterInitialSave) //
        XCTAssertEqual(1, journeyCountAfterSanitize)
        XCTAssertEqual(userPreferences.recentlySavedJourneys.first, returnJourney) // N.B. Journey with most recent timestamp saved
    }
}


// MARK: - Private helpers

private extension UserDefaults {
    
    static func singleTestUserDefaults() -> UserDefaults {
        .init(suiteName: UUID().uuidString)!
    }
}
