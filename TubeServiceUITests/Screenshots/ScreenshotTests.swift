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

        let lineDetail = lineStatus.openLine("elizabeth")
        capture(lineDetail, as: "ServiceStatusDetail-Today")

        let weekend = lineDetail.goBack().showThisWeekend()
        capture(weekend, as: "ServiceStatuses-Weekend")

        let journeyPlanner = weekend.tabBar.openJourneyPlanner()
        capture(journeyPlanner, as: "JourneyPlannerForm")

        let journeyResults = journeyPlanner.planRecentJourney().expandFirstJourney().showFirstLegStops()
        capture(journeyResults, as: "JourneyPlannerResults")

        let arrivalsPicker = journeyResults.tabBar.openArrivals()
        capture(arrivalsPicker, as: "LiveArrivalsPicker")

        let arrivalsBoard = arrivalsPicker.openLineGroup("910GABWDXR-elizabeth")  // Abbey Wood
        capture(arrivalsBoard, as: "LiveArrivalsBoard1")

        let nearby = arrivalsBoard.tabBar.openNearby()
        capture(nearby, as: "NearbyStations-List")

        let station = nearby.openStation("HUBKGX")  // King's Cross St Pancras
        capture(station, as: "NearbyStations-Detail")

        let maps = station.tabBar.openMaps()
        capture(maps, as: "Maps")
    }
}
