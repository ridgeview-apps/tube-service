@testable import Tube_Service

import Models
import DataClients
import XCTest

@MainActor
final class UserPreferencesModelTests: XCTestCase {
    
    func testLoadUserPreferences() {
        // Given
        let stubbedPreferences = UserPreferences(favouriteLineGroupIDs: ["foo1", "foo2"],
                                                 favouriteLineIDs: [.bakerloo],
                                                 recentlySelectedStations: [ModelStubs.kingsCrossStation.id])
        
        let userPreferencesClient = StubUserPreferencesClient()
        userPreferencesClient.stubbedPreferences = stubbedPreferences
        
        // When
        let userPreferencesModel = UserPreferencesModel(userPreferencesClient: userPreferencesClient)
        
        // Then
        XCTAssertEqual(userPreferencesModel.recentlySelectedStations, [ModelStubs.kingsCrossStation.id])
        XCTAssertEqual(userPreferencesModel.favouriteLineGroupIDs, ["foo1", "foo2"])
        XCTAssertEqual(userPreferencesModel.favouriteLineIDs, [.bakerloo])
        XCTAssertTrue(userPreferencesModel.isFavourite(lineGroupID: "foo1"))
        XCTAssertFalse(userPreferencesModel.isFavourite(lineGroupID: "bar"))
        XCTAssertTrue(userPreferencesModel.isFavourite(lineID: .bakerloo))
        XCTAssertFalse(userPreferencesModel.isFavourite(lineID: .circle))
    }
    
    func testAddingAndRemovingFavouriteLineGroups() {
        // Given
        let stubbedPreferences = UserPreferences(favouriteLineGroupIDs: ["foo1", "foo2"],
                                                 favouriteLineIDs: [.bakerloo],
                                                 recentlySelectedStations: [ModelStubs.kingsCrossStation.id])
        
        let userPreferencesClient = StubUserPreferencesClient()
        userPreferencesClient.stubbedPreferences = stubbedPreferences
        
        // Not yet added
        let userPreferencesModel = UserPreferencesModel(userPreferencesClient: userPreferencesClient)
        XCTAssertFalse(userPreferencesModel.isFavourite(lineGroupID: "bar1"))
        
        // Added
        userPreferencesModel.add(favouriteLineGroupID: "bar1")
        XCTAssertTrue(userPreferencesModel.isFavourite(lineGroupID: "bar1"))
        
        // Removed
        userPreferencesModel.remove(favouriteLineGroupID: "bar1")
        XCTAssertFalse(userPreferencesModel.isFavourite(lineGroupID: "bar1"))
    }
    
    func testAddingAndRemovingFavouriteLineIDs() {
        // Given
        let stubbedPreferences = UserPreferences(favouriteLineGroupIDs: [],
                                                 favouriteLineIDs: nil,
                                                 recentlySelectedStations: [])
        
        let userPreferencesClient = StubUserPreferencesClient()
        userPreferencesClient.stubbedPreferences = stubbedPreferences
        
        // Not yet added
        let userPreferencesModel = UserPreferencesModel(userPreferencesClient: userPreferencesClient)
        XCTAssertFalse(userPreferencesModel.isFavourite(lineID: .bakerloo))
        
        // Added
        userPreferencesModel.add(favouriteLineID: .bakerloo)
        XCTAssertTrue(userPreferencesModel.isFavourite(lineID: .bakerloo))
        
        // Removed
        userPreferencesModel.remove(favouriteLineID: .bakerloo)
        XCTAssertFalse(userPreferencesModel.isFavourite(lineID: .bakerloo))
    }
    
    
    func testSaveRecentlyUsedStations() {
        // Given
        let stubbedPreferences = UserPreferences(favouriteLineGroupIDs: ["foo1", "foo2"],
                                                 favouriteLineIDs: [.bakerloo],
                                                 recentlySelectedStations: [])
        
        let userPreferencesClient = StubUserPreferencesClient()
        userPreferencesClient.stubbedPreferences = stubbedPreferences
        
        // Initially empty
        let userPreferencesModel = UserPreferencesModel(userPreferencesClient: userPreferencesClient)
        XCTAssertTrue(userPreferencesModel.recentlySelectedStations.isEmpty)
        
        // Save a first one
        userPreferencesModel.save(recentlySelectedStationID: ModelStubs.kingsCrossStation.id)
        XCTAssertEqual(userPreferencesModel.recentlySelectedStations, [ModelStubs.kingsCrossStation.id])
        
        // Save another one (should insert at top of the list)
        userPreferencesModel.save(recentlySelectedStationID: ModelStubs.paddingtonStation.id)
        XCTAssertEqual(userPreferencesModel.recentlySelectedStations, [ModelStubs.paddingtonStation.id,
                                                                       ModelStubs.kingsCrossStation.id])
        
        // Save another one (should insert at top of the list)
        userPreferencesModel.save(recentlySelectedStationID: ModelStubs.highBarnetStation.id)
        XCTAssertEqual(userPreferencesModel.recentlySelectedStations, [ModelStubs.highBarnetStation.id,
                                                                       ModelStubs.paddingtonStation.id,
                                                                       ModelStubs.kingsCrossStation.id])
        
        // Re-save the last one multiple times (no change / duplicates ignored)
        (1...5).forEach { _ in
            userPreferencesModel.save(recentlySelectedStationID: ModelStubs.highBarnetStation.id)
        }
        XCTAssertEqual(userPreferencesModel.recentlySelectedStations, [ModelStubs.highBarnetStation.id,
                                                                       ModelStubs.paddingtonStation.id,
                                                                       ModelStubs.kingsCrossStation.id])

    }
    
    
}



