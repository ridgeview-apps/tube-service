import Shared
import XCTest

final class StationInfoTests: UITestCase {

    private var configuration: TubeUITestLaunchConfiguration {
        TubeUITestLaunchConfiguration(
            now: UITestScenario.Fixtures.functional.now,
            timeZoneIdentifier: "Europe/London",
            disablesAnimations: true,
            scenario: UITestScenario(fixtures: .functional, seed: .freshInstall)
        )
    }

    private let kingsCrossStationID = "HUBKGX"

    @MainActor
    func testTappingALineShowsItsDetailInsideTheSheet() throws {
        let app = try launchApp(with: configuration)
        let station =
            LineStatusPage.waitingToAppear(in: app)
            .tabBar.tapArrivalsTab()
            .tapNearbyStation(kingsCrossStationID)

        let returnedStation =
            station
            .tapInfoButton()
            .tapLine("northern")
            .tapBackButton()
            .tapCloseButton()

        app.collectionViews[AccessibilityID.StationInfo.list].waitToDisappear()
        returnedStation.platformNames.firstMatch.waitToExist()
    }
}
