import Shared
import XCTest

/// The base for every UI test: it stops at the first failure and launches the app with a launch configuration, so
/// each test chooses its clock, time zone and starting state.
class UITestCase: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    /// Launches a fresh instance of the app with `configuration`, in portrait on iPhone and landscape on iPad.
    @MainActor
    func launchApp<Scenario>(with configuration: UITestLaunchConfiguration<Scenario>) throws -> XCUIApplication {
        // The simulator keeps the last test's orientation, and in portrait the iPad's sidebar layout (forced in UI
        // tests) swallows taps on the Line Status Edit button
        XCUIDevice.shared.orientation = UIDevice.current.userInterfaceIdiom == .pad ? .landscapeLeft : .portrait
        let app = XCUIApplication()
        app.launchEnvironment.merge(try configuration.launchEnvironment()) { _, new in new }
        prepareForLaunch(app)
        app.launch()
        return app
    }

    /// Called just before `launchApp(with:)` launches the app. Override to add launch arguments.
    @MainActor
    func prepareForLaunch(_ app: XCUIApplication) {}
}
