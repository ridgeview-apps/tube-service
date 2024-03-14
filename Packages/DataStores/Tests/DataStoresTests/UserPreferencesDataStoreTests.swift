@testable import DataStores

import Models
import XCTest

final class UserPreferencesDataStoreTests: XCTestCase {
    
    @MainActor
    func testLoadUserPreferences_initiallyEmpty() throws {
        // Given
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        // When
        let initialValue = userPreferences.value

        // Then
        XCTAssertEqual(initialValue, .empty)
    }
    
    @MainActor
    func testLoadUserPreferences_initiallyPopulated() throws {
        // Given
        let userDefaults = UserDefaults.singleTestUserDefaults()
        let initialPopulatedValue = UserPreferences(favouriteLineGroupIDs: ["ExampleID1", "ExampleID2"],
                                                    favouriteLineIDs: [.bakerloo, .northern],
                                                    recentlySelectedStations: ["ExampleID1"],
                                                    journeyPlannerModeIDs: Set(ModeID.journeyPlannerModeIDs),
                                                    recentlySavedJourneys: [.init(fromLocation: .station(id: ModelStubs.eastFinchleyStation.id),
                                                                                  toLocation: .station(id: ModelStubs.angelStation.id),
                                                                                  viaLocation: nil)])
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
        
        XCTAssertEqual(userPreferences.journeyPlannerModeIDs, [])
        
        userPreferences.save(journeyPlannerModeIDs: Set([.tube, .walking]))
        
        XCTAssertEqual(userPreferences.journeyPlannerModeIDs, [.tube, .walking])
    }
    
    @MainActor
    func testAddingAndRemovingARecentJourney() throws {
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        let kingsCrossStationID = ModelStubs.kingsCrossStation.id
        let eastFinchleyStationID = ModelStubs.eastFinchleyStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        let journeyToAngel = SavedJourney(fromLocation: .station(id: kingsCrossStationID),
                                          toLocation: .station(id: angelStationID),
                                          viaLocation: nil)
        
        let journeyToEastFinchley = SavedJourney(fromLocation: .station(id: kingsCrossStationID),
                                                 toLocation: .station(id: eastFinchleyStationID),
                                                 viaLocation: nil)
        
        // 1. Initially empty
        XCTAssertTrue(userPreferences.recentlySavedJourneys.isEmpty)
        
        // 2. Save Angel journey THEN East Finchley journey (twice)
        userPreferences.save(recentJourney: journeyToAngel)
        userPreferences.save(recentJourney: journeyToEastFinchley)
        userPreferences.save(recentJourney: journeyToEastFinchley) // Duplicate save (ignored)
        
        // 3. Verify most recent journey is East Finchley
        XCTAssertEqual(userPreferences.recentlySavedJourneys, [journeyToEastFinchley,
                                                               journeyToAngel])
        
        // 4. Now Remove the East Finchley journey
        userPreferences.remove(recentJourney: journeyToEastFinchley)
        XCTAssertEqual(userPreferences.recentlySavedJourneys, [journeyToAngel])
    }
    
    @MainActor
    func testSaveRecentJourneys_reverseJourneyIsRemoved() throws {
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        let kingsCrossStationID = ModelStubs.kingsCrossStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        // Outbound journey
        let kingsXToAngel = SavedJourney(fromLocation: .station(id: kingsCrossStationID),
                                         toLocation: .station(id: angelStationID),
                                         viaLocation: nil)
        
        // Return journey
        let angelToKingsX = SavedJourney(fromLocation: .station(id: angelStationID),
                                         toLocation: .station(id: kingsCrossStationID),
                                         viaLocation: nil)
        
        // 1. Initially empty
        XCTAssertTrue(userPreferences.recentlySavedJourneys.isEmpty)
        
        // 2. Save outbound journey THEN return journey
        userPreferences.save(recentJourney: kingsXToAngel)
        userPreferences.save(recentJourney: angelToKingsX)
        userPreferences.save(recentJourney: angelToKingsX) // Duplicate save (ignored)
        
        // 3. Verify only the latest journey is saved
        XCTAssertEqual(userPreferences.recentlySavedJourneys.count, 1)
        XCTAssertEqual(userPreferences.recentlySavedJourneys, [angelToKingsX])
    }
}


// MARK: - Private helpers

private extension UserDefaults {
    
    static func singleTestUserDefaults() -> UserDefaults {
        .init(suiteName: UUID().uuidString)!
    }
}
