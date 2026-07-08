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

    // MARK: - Notification row state

    struct NotificationRowState: Equatable, Sendable {
        public let isVisible: Bool
        public let showsPermissionWarning: Bool
        public let isPaused: Bool

        public init(
            isVisible: Bool = false,
            showsPermissionWarning: Bool = false,
            isPaused: Bool = false
        ) {
            self.isVisible = isVisible
            self.showsPermissionWarning = showsPermissionWarning
            self.isPaused = isPaused
        }

        public static let hidden = NotificationRowState()
    }


    // MARK: - Debug state

    enum DebugAction: Sendable {
        case resetUserDefaults
    }
}
