import DataClients
import Foundation

#if DEBUG

extension UserPreferencesModel {
    
    static func stub(userPreferencesClient: UserPreferencesClientType = StubUserPreferencesClient()) -> UserPreferencesModel {
        return .init(userPreferencesClient: userPreferencesClient)
    }
}

#endif
