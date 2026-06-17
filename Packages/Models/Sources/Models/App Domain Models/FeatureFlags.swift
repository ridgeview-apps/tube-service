import Foundation

public struct FeatureFlags: Codable, Sendable {

    public static let `default` = FeatureFlags()

    public var isStatusHistoryEnabled: Bool

    public init(isStatusHistoryEnabled: Bool = false) {
        self.isStatusHistoryEnabled = isStatusHistoryEnabled
    }
}
