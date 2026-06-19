import Foundation

public struct FeatureFlags: Codable, Sendable {

    public static let `default` = FeatureFlags()

    public var isStatusHistoryEnabled: Bool
    public var isNotificationsEnabled: Bool

    public init(isStatusHistoryEnabled: Bool = false, isNotificationsEnabled: Bool = false) {
        self.isStatusHistoryEnabled = isStatusHistoryEnabled
        self.isNotificationsEnabled = isNotificationsEnabled
    }
}
