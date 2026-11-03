import Foundation

public typealias TubeUITestLaunchConfiguration = UITestLaunchConfiguration<UITestScenario>

/// The state and data a UI test asks Tube Service to start with.
public struct UITestScenario: Codable, Sendable {

    /// Which set of stubbed API responses to use. Screenshot and functional tests have separate sets, so changing one
    /// never changes the other.
    public enum Fixtures: String, Codable, Sendable {
        case screenshots
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
