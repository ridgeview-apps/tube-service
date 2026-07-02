import Foundation

public struct FeatureFlags: Codable, Sendable {

    public static let `default` = FeatureFlags()

    public var isStatusHistoryEnabled: Bool
    public var isNotificationsEnabled: Bool
    public var isPaywallBypassed: Bool

    // TODO: switch off later
    public init(
        isStatusHistoryEnabled: Bool = true,
        isNotificationsEnabled: Bool = true,
        isPaywallBypassed: Bool = false
    ) {
        self.isStatusHistoryEnabled = isStatusHistoryEnabled
        self.isNotificationsEnabled = isNotificationsEnabled
        self.isPaywallBypassed = isPaywallBypassed
    }
}
