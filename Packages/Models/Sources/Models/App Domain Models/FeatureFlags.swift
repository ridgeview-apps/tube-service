import Foundation

public struct FeatureFlags: Codable, Sendable {

    public static let `default` = FeatureFlags()

    public var isStatusHistoryEnabled: Bool
    public var isNotificationsEnabled: Bool
    public var isPaywallBypassed: Bool
    public var isBusesEnabled: Bool

    public init(
        isStatusHistoryEnabled: Bool = false,
        isNotificationsEnabled: Bool = false,
        isPaywallBypassed: Bool = false,
        isBusesEnabled: Bool = false
    ) {
        self.isStatusHistoryEnabled = isStatusHistoryEnabled
        self.isNotificationsEnabled = isNotificationsEnabled
        self.isPaywallBypassed = isPaywallBypassed
        self.isBusesEnabled = isBusesEnabled
    }
}
