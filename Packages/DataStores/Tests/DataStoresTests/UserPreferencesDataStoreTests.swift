@testable import DataStores

import Models
import XCTest

@MainActor
final class UserPreferencesDataStoreTests: XCTestCase {
    
    func testLoadUserPreferences_initiallyEmpty() throws {
        // Given
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        // When
        let initialValue = userPreferences.value

        // Then
        XCTAssertEqual(initialValue, .empty)
    }
    
    func testLoadUserPreferences_initiallyPopulated() throws {
        // Given
        let userDefaults = UserDefaults.singleTestUserDefaults()
        let initialPopulatedValue = UserPreferences(favouriteLineGroupIDs: ["ExampleID1", "ExampleID2"],
                                                    favouriteLineIDs: [.bakerloo, .northern],
                                                    recentlySelectedStations: ["ExampleID1"])
        userDefaults.userPreferences = initialPopulatedValue
        
        let userPreferences = UserPreferencesDataStore(userDefaults: userDefaults)
        
        // When
        let initialValue = userPreferences.value

        // Then
        XCTAssertEqual(initialValue, initialPopulatedValue)
    }
    
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
    
    func testSaveRecentlyUsedStationID() throws {
        let userPreferences = UserPreferencesDataStore(userDefaults: .singleTestUserDefaults())
        
        let eastFinchleyStationID = ModelStubs.eastFinchleyStation.id
        let angelStationID = ModelStubs.angelStation.id
        
        // 1. Initially empty
        XCTAssertTrue(userPreferences.recentlySelectedStations.isEmpty)
        
        // 2. Select Angel THEN East Finchley
        userPreferences.save(recentlySelectedStationID: angelStationID)
        userPreferences.save(recentlySelectedStationID: eastFinchleyStationID)
        
        // 3. Verify most recent selection is East Finchley
        XCTAssertEqual(userPreferences.recentlySelectedStations, [eastFinchleyStationID, angelStationID])
    }
}


// MARK: - Private helpers

private extension UserDefaults {
    
    static func singleTestUserDefaults() -> UserDefaults {
        .init(suiteName: UUID().uuidString)!
    }
}
