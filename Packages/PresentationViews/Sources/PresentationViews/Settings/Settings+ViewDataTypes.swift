import Models

public enum Settings {} // Namespace

public extension Settings {
    
    // MARK: - Contact us
    
    struct ContactUs: Equatable {
        public let emailAddress: String
        public let appVersion: String
        public let appName: String
        public let deviceInfo: String
        public let localeInfo: String
        
        public init(emailAddress: String,
                    appVersion: String,
                    appName: String,
                    deviceInfo: String,
                    localeInfo: String) {
            self.emailAddress = emailAddress
            self.appVersion = appVersion
            self.appName = appName
            self.deviceInfo = deviceInfo
            self.localeInfo = localeInfo
        }
        
        public static let empty: ContactUs = .init(emailAddress: "",
                                                   appVersion: "",
                                                   appName: "",
                                                   deviceInfo: "",
                                                   localeInfo: "")
    }
    
    
    // MARK: - Editable values
    
    struct EditableValues: Equatable {
        public var journeyPlannerModesSelection: Set<ModeID>
        
        var allJourneyPlannerModesSelected: Bool {
            journeyPlannerModesSelection.count == ModeID.allJourneyPlannerModeIDs.count
        }
        
        public init(journeyPlannerModesSelection: Set<ModeID>) {
            self.journeyPlannerModesSelection = journeyPlannerModesSelection
        }
        
        public static let `default` = EditableValues(journeyPlannerModesSelection: Set(ModeID.defaultJourneyPlannerModeIDs))
    }
    
    
    // MARK: - Debug state

    enum DebugAction: Sendable {
        case resetUserDefaults
    }
}
