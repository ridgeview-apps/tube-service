import Foundation

public struct FeatureFlags: Codable, Sendable {

    public static let `default` = FeatureFlags()

    public var isStatusHistoryEnabled: Bool
    public var isNotificationsEnabled: Bool
    public var isPaywallBypassed: Bool

    public init(
        isStatusHistoryEnabled: Bool = false,
        isNotificationsEnabled: Bool = false,
        isPaywallBypassed: Bool = false
    ) {
        self.isStatusHistoryEnabled = isStatusHistoryEnabled
        self.isNotificationsEnabled = isNotificationsEnabled
        self.isPaywallBypassed = isPaywallBypassed
    }
}
