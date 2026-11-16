import Shared
import XCTest

/// The App Store screenshots, captured by `fastlane snapshot`. Only released features appear; features still behind
/// debug flags are covered by the functional tests instead.
final class ScreenshotTests: ScreenshotTestCase {

    private var configuration: TubeUITestLaunchConfiguration {
        TubeUITestLaunchConfiguration(
            now: UITestScenario.Fixtures.screenshots.now,
            timeZoneIdentifier: "Europe/London",
            disablesAnimations: true,
            scenario: UITestScenario(fixtures: .screenshots, seed: .returningUser)
        )
    }

    @MainActor
    func testAppStoreScreenshots() throws {
        XCUIDevice.shared.orientation = UIDevice.current.userInterfaceIdiom == .pad ? .landscapeLeft : .portrait
        let app = try launchApp(with: configuration)

        let lineStatus = LineStatusPage.waitingToAppear(in: app)
        capture(lineStatus, as: "ServiceStatuses-Today")

        let lineDetail = lineStatus.tapFavouriteLine("elizabeth")
        capture(lineDetail, as: "ServiceStatusDetail-Today")

        let weekend = lineDetail.tapBackButton().tapThisWeekendFilter()
        capture(weekend, as: "ServiceStatuses-Weekend")

        let journeyPlanner = weekend.tabBar.tapJourneyPlannerTab()
        capture(journeyPlanner, as: "JourneyPlannerForm")

        let journeyResults = journeyPlanner.tapFirstRecentJourney().tapFirstJourney().tapFirstStopsButton()
        capture(journeyResults, as: "JourneyPlannerResults")

        let arrivals = journeyResults.tabBar.tapArrivalsTab()
        capture(arrivals, as: "LiveArrivalsPicker")

        let arrivalsStation = arrivals.tapFavouriteStation("HUBABW")  // Abbey Wood
        capture(arrivalsStation, as: "LiveArrivalsBoard1")

        let maps = arrivalsStation.tabBar.tapMapsTab()
        capture(maps, as: "Maps")
    }
}
