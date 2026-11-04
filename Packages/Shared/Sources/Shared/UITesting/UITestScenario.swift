import Foundation

public typealias TubeUITestLaunchConfiguration = UITestLaunchConfiguration<UITestScenario>

/// The state and data a UI test asks Tube Service to start with.
public struct UITestScenario: Codable, Sendable {

    /// Which set of stubbed API responses to use. Screenshot and functional tests have separate sets, so changing one
    /// never changes the other.
    public enum Fixtures: String, Codable, Sendable {
        /// Curated data for App Store screenshots.
        case screenshots
        /// The unit tests' stub responses for now; functional flows get their own set as they need it.
        case functional
    }

    /// What's saved on the device at launch.
    public enum Seed: String, Codable, Sendable {
        /// Nothing saved: no favourites, recent journeys or notification setup.
        case freshInstall
        /// Favourite lines and stations, and recent journeys.
        case returningUser
    }

    public var fixtures: Fixtures
    public var seed: Seed
    /// Subscribed to Tube Service Plus (through the debug paywall bypass).
    public var hasTubeServicePlus: Bool
    /// Turns on the features still behind debug flags (status history and notifications).
    public var enablesUnreleasedFeatures: Bool

    public init(
        fixtures: Fixtures,
        seed: Seed,
        hasTubeServicePlus: Bool = false,
        enablesUnreleasedFeatures: Bool = false
    ) {
        self.fixtures = fixtures
        self.seed = seed
        self.hasTubeServicePlus = hasTubeServicePlus
        self.enablesUnreleasedFeatures = enablesUnreleasedFeatures
    }
}

public extension UITestScenario.Fixtures {
    /// The time the fixtures' dates were written around. Launch with this as `now` so their times look current.
    /// `fastlane/Snapfile` sets the simulator's status bar to the same time.
    var now: Date {
        switch self {
        case .screenshots, .functional:
            Date(timeIntervalSince1970: 1_781_253_660)  // Friday 12 June 2026, 09:41 in London (Apple's 9:41)
        }
    }
}
