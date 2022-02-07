import Foundation
import Model

public extension UserPreferences {
    
    static func fake(favourites: Set<Station.ArrivalsGroup.ID> = [],
                     lastUsedFilterOption: ArrivalsPickerFilterOption = .all,
                     preferredBrowserType: UserPreferences.BrowserType = .inApp) -> UserPreferences {
        .init(favourites: favourites,
              lastUsedFilterOption: lastUsedFilterOption,
              preferredBrowserType: preferredBrowserType)
    }
}
