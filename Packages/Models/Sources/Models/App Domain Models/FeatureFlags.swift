import Foundation

public struct FeatureFlags: Codable, Sendable {

    public static let `default` = FeatureFlags()

    public var isStatusHistoryEnabled: Bool
    public var isNotificationsEnabled: Bool

    // TODO: switch off later
    public init(isStatusHistoryEnabled: Bool = true, isNotificationsEnabled: Bool = true) {
        self.isStatusHistoryEnabled = isStatusHistoryEnabled
        self.isNotificationsEnabled = isNotificationsEnabled
    }
}
