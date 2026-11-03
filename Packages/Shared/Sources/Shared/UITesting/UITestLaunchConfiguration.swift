import Foundation

/// What a UI test asks the app to launch with, passed from the test to the app in the launch environment.
///
/// The generic settings (a fixed clock, a time zone, animations) are the same for any app; `Scenario` is the app's
/// own description of the state and data it should start with.
public struct UITestLaunchConfiguration<Scenario: Codable & Sendable>: Codable, Sendable {

    public static var environmentKey: String { "UI_TEST_LAUNCH_CONFIGURATION" }

    /// The app's clock stays at this time for the whole launch.
    public var now: Date
    /// Also sent as `TZ`, so the app formats times the same whichever time zone the simulator's host is in.
    public var timeZoneIdentifier: String
    public var disablesAnimations: Bool
    public var scenario: Scenario

    public init(
        now: Date,
        timeZoneIdentifier: String,
        disablesAnimations: Bool,
        scenario: Scenario
    ) {
        self.now = now
        self.timeZoneIdentifier = timeZoneIdentifier
        self.disablesAnimations = disablesAnimations
        self.scenario = scenario
    }

    /// For `XCUIApplication.launchEnvironment`.
    public func launchEnvironment() throws -> [String: String] {
        let data = try JSONEncoder().encode(self)
        return [
            Self.environmentKey: String(decoding: data, as: UTF8.self),
            "TZ": timeZoneIdentifier
        ]
    }

    /// The configuration the app was launched with, or `nil` if it isn't running under a UI test.
    public static func fromProcessEnvironment(
        _ environment: [String: String] = ProcessInfo.processInfo.environment
    ) -> Self? {
        guard let json = environment[environmentKey] else { return nil }
        do {
            return try JSONDecoder().decode(Self.self, from: Data(json.utf8))
        } catch {
            // A UI test that can't describe its launch would otherwise silently run against live data.
            preconditionFailure("Invalid UI test launch configuration: \(error)")
        }
    }
}
