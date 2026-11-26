import Foundation
import Testing

@testable import Models

struct FeatureFlagsTests {

    @Test
    func decodingOlderStoredValueTurnsNewFlagsOff() throws {
        let decoded = try #require(FeatureFlags(rawValue: #"{"isStatusHistoryEnabled":true}"#))

        #expect(decoded.isStatusHistoryEnabled)
        #expect(!decoded.isBusesEnabled)
    }

    @Test
    func roundTripsThroughRawValue() throws {
        let flags = FeatureFlags(isBusesEnabled: true)

        let decoded = try #require(FeatureFlags(rawValue: flags.rawValue))

        #expect(decoded.isBusesEnabled)
        #expect(!decoded.isStatusHistoryEnabled)
    }
}
