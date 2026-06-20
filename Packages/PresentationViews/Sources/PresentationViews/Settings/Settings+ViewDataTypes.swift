import Models

public enum Settings {}  // Namespace

public extension Settings {

    // MARK: - Contact us

    struct ContactUs: Equatable, Sendable {
        public let emailAddress: String
        public let appVersion: String
        public let appName: String
        public let deviceInfo: String
        public let localeInfo: String

        public init(
            emailAddress: String,
            appVersion: String,
            appName: String,
            deviceInfo: String,
            localeInfo: String
        ) {
            self.emailAddress = emailAddress
            self.appVersion = appVersion
            self.appName = appName
            self.deviceInfo = deviceInfo
            self.localeInfo = localeInfo
        }

        public static let empty: ContactUs = .init(
            emailAddress: "",
            appVersion: "",
            appName: "",
            deviceInfo: "",
            localeInfo: ""
        )
    }


    // MARK: - Notifications row state

    enum NotificationsRowState: Sendable, Equatable {
        case notSetUp
        case active
        case permissionDenied
    }


    // MARK: - Debug state

    enum DebugAction: Sendable {
        case resetUserDefaults
    }
}
