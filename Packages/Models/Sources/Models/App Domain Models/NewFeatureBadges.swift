import Foundation

public enum NewFeature: String, CaseIterable, Codable, CodingKeyRepresentable, Sendable {
    case statusHistory
    case lineNotifications
}

/// Tracks which features are still worth flagging as "New". A badge shows until the user taps the feature,
/// or until it has been on screen for `badgeDuration`, counted from when the user first saw it rather than
/// from release, so people who open the app less often still get to notice it.
public struct NewFeatureBadges: Equatable, Sendable {

    public static let `default` = NewFeatureBadges(firstSeenAt: [:], usedFeatures: [])

    public static let badgeDuration: TimeInterval = 14 * 24 * 60 * 60

    public var firstSeenAt: [NewFeature: Date]
    public var usedFeatures: Set<NewFeature>

    public init(firstSeenAt: [NewFeature: Date], usedFeatures: Set<NewFeature>) {
        self.firstSeenAt = firstSeenAt
        self.usedFeatures = usedFeatures
    }

    public func showsBadge(for feature: NewFeature, now: Date) -> Bool {
        guard !usedFeatures.contains(feature) else { return false }
        guard let firstSeen = firstSeenAt[feature] else { return true }
        return now < firstSeen + Self.badgeDuration
    }

    /// Only the first sighting is kept, so the badge's lifetime isn't extended each time the feature is shown.
    public mutating func recordSeen(_ feature: NewFeature, at date: Date) {
        if firstSeenAt[feature] == nil {
            firstSeenAt[feature] = date
        }
    }

    public mutating func recordUsed(_ feature: NewFeature) {
        usedFeatures.insert(feature)
    }
}
