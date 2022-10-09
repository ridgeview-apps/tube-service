import Models
import XCTest

@testable import DataClients

final class UserPreferencesClientTests: XCTestCase {
    
    func testSaveAndLoadUserPreferences() throws {
        // Given
        let userPreferencesClient = UserPreferencesClient(userDefaults: .singleTestUserDefaults())
        
        // When
        let initialValue = userPreferencesClient.load()
        let newValue = UserPreferences(favourites: ["ExampleID1","ExampleID2"],
                                       lastUsedFilterOption: .favourites,
                                       recentlySelectedStations: [])
        userPreferencesClient.save(newValue)
        
        // Then
        XCTAssertEqual(initialValue, .empty)
        XCTAssertEqual(newValue, userPreferencesClient.load())
    }
}


// MARK: - Private helpers

private extension UserDefaults {
    
    static func singleTestUserDefaults() -> UserDefaults {
        .init(suiteName: UUID().uuidString)!
    }
}
