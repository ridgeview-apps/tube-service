import Models

public enum Settings {} // Namespace

public extension Settings {
    
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
    
    struct EditableValues: Equatable {
        public var journeyPlannerModesSelection: Set<ModeID>
        
        var allJourneyPlannerModesSelected: Bool {
            journeyPlannerModesSelection.count == ModeID.journeyPlannerModeIDs.count
        }
        
        public init(journeyPlannerModesSelection: Set<ModeID>) {
            self.journeyPlannerModesSelection = journeyPlannerModesSelection
        }
        
        public static let `default` = EditableValues(journeyPlannerModesSelection: Set(ModeID.journeyPlannerModeIDs))
    }

}
