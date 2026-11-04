import Shared
import XCTest

/// Editing the favourite lines on the Status screen. The returning user starts with Elizabeth then Victoria.
final class FavouriteLinesTests: UITestCase {

    private var configuration: TubeUITestLaunchConfiguration {
        TubeUITestLaunchConfiguration(
            now: UITestScenario.Fixtures.functional.now,
            timeZoneIdentifier: "Europe/London",
            disablesAnimations: true,
            scenario: UITestScenario(fixtures: .functional, seed: .returningUser)
        )
    }

    @MainActor
    func testDraggingAFavouriteReordersFavourites() throws {
        let app = try launchApp(with: configuration)
        let lineStatus = LineStatusPage.waitingToAppear(in: app)
        XCTAssertLessThan(
            lineStatus.favouriteLine("elizabeth").frame.minY,
            lineStatus.favouriteLine("victoria").frame.minY
        )

        let reordered =
            lineStatus
            .tapEditFavouritesButton()
            .dragFavouriteLine("elizabeth", below: "victoria")
            .tapDoneEditingFavouritesButton()

        XCTAssertLessThan(
            reordered.favouriteLine("victoria").frame.minY,
            reordered.favouriteLine("elizabeth").frame.minY
        )
    }

    @MainActor
    func testDeletingAFavouriteRemovesItFromFavourites() throws {
        let app = try launchApp(with: configuration)
        let lineStatus =
            LineStatusPage.waitingToAppear(in: app)
            .tapEditFavouritesButton()
            .tapRemoveButton(onFavouriteLine: "elizabeth")
            .tapDeleteButton(onFavouriteLine: "elizabeth")
            .tapDoneEditingFavouritesButton()

        XCTAssertFalse(lineStatus.favouriteLine("elizabeth").exists)
        XCTAssertTrue(lineStatus.favouriteLine("victoria").exists)
        // Elizabeth is disrupted, so it moves to the Disruptions section
        lineStatus.line("elizabeth").waitToExist()
    }
}
