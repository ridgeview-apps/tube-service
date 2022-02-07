public struct UserPreferences: Equatable, Codable {
    
    public enum BrowserType: Int, Identifiable, CaseIterable, Codable {
        public var id: Int { rawValue }
        case external, inApp
    }
    
    public enum ArrivalsPickerFilterOption: Int, Identifiable, CaseIterable, Codable {
        public var id: Int { rawValue }
        case all, favourites
    }
    
    public var favourites: Set<Station.ArrivalsGroup.ID>
    public var lastUsedFilterOption: ArrivalsPickerFilterOption
    public var preferredBrowserType: BrowserType
    
    public static let empty: UserPreferences = .init(favourites: [],
                                                     lastUsedFilterOption: .all,
                                                     preferredBrowserType: .inApp)
    
    public init(
        favourites: Set<Station.ArrivalsGroup.ID>,
        lastUsedFilterOption: UserPreferences.ArrivalsPickerFilterOption,
        preferredBrowserType: UserPreferences.BrowserType
    ) {
        self.favourites = favourites
        self.lastUsedFilterOption = lastUsedFilterOption
        self.preferredBrowserType = preferredBrowserType
    }
}
