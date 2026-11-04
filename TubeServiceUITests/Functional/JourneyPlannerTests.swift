import Shared
import XCTest

final class JourneyPlannerTests: UITestCase {

    private var configuration: TubeUITestLaunchConfiguration {
        TubeUITestLaunchConfiguration(
            now: UITestScenario.Fixtures.functional.now,
            timeZoneIdentifier: "Europe/London",
            disablesAnimations: true,
            scenario: UITestScenario(fixtures: .functional, seed: .freshInstall)
        )
    }

    @MainActor
    func testPlannedJourneyAppearsInRecentJourneys() throws {
        let app = try launchApp(with: configuration)
        let journeyPlanner = LineStatusPage.waitingToAppear(in: app).tabBar.tapJourneyPlannerTab()
        XCTAssertEqual(journeyPlanner.recentJourneys.count, 0)

        let results =
            journeyPlanner
            .tapFromField().typeInSearchField("King's Cross").tapFirstSearchResult()
            .tapToField().typeInSearchField("Waterloo").tapFirstSearchResult()
            .tapPlanMyJourneyButton()

        let returnedJourneyPlanner = results.tapBackButton()
        returnedJourneyPlanner.recentJourneys.firstMatch.waitToExist()
        XCTAssertEqual(returnedJourneyPlanner.recentJourneys.count, 1)
    }
}
