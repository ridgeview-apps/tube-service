import Foundation
import Testing

@testable import Models

struct NewFeatureBadgesTests {

    private let now = Date(timeIntervalSince1970: 1_800_000_000)

    @Test
    func badgeShowsBeforeFeatureIsSeen() {
        #expect(NewFeatureBadges.default.showsBadge(for: .statusHistory, now: now))
    }

    @Test
    func badgeExpiresAfterDurationFromFirstSeen() {
        // Given
        var badges = NewFeatureBadges.default
        badges.recordSeen(.statusHistory, at: now)

        // Then
        #expect(badges.showsBadge(for: .statusHistory, now: now + NewFeatureBadges.badgeDuration - 1))
        #expect(!badges.showsBadge(for: .statusHistory, now: now + NewFeatureBadges.badgeDuration))
    }

    @Test
    func laterSightingsDoNotExtendBadge() {
        // Given
        var badges = NewFeatureBadges.default
        badges.recordSeen(.statusHistory, at: now)

        // When
        badges.recordSeen(.statusHistory, at: now + NewFeatureBadges.badgeDuration - 1)

        // Then
        #expect(badges.firstSeenAt[.statusHistory] == now)
    }

    @Test
    func usingFeatureHidesOnlyItsBadge() {
        // Given
        var badges = NewFeatureBadges.default

        // When
        badges.recordUsed(.lineNotifications)

        // Then
        #expect(!badges.showsBadge(for: .lineNotifications, now: now))
        #expect(badges.showsBadge(for: .statusHistory, now: now))
    }

    @Test
    func roundTripsThroughRawValue() throws {
        // Given
        var badges = NewFeatureBadges.default
        badges.recordSeen(.statusHistory, at: now)
        badges.recordUsed(.lineNotifications)

        // When
        let decoded = try #require(NewFeatureBadges(rawValue: badges.rawValue))

        // Then
        #expect(decoded == badges)
    }
}
