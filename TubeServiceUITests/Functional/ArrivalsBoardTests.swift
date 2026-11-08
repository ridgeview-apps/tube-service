import Shared
import XCTest

final class ArrivalsBoardTests: UITestCase {

    private var configuration: TubeUITestLaunchConfiguration {
        TubeUITestLaunchConfiguration(
            now: UITestScenario.Fixtures.functional.now,
            timeZoneIdentifier: "Europe/London",
            disablesAnimations: true,
            scenario: UITestScenario(fixtures: .functional, seed: .freshInstall)
        )
    }

    private let kingsCrossNorthernLineGroupID = "940GZZLUKSX-northern"

    @MainActor
    func testFavouritedBoardAppearsInFavourites() throws {
        let app = try launchApp(with: configuration)
        let arrivalsPicker = LineStatusPage.waitingToAppear(in: app).tabBar.tapArrivalsTab()
        XCTAssertFalse(arrivalsPicker.favouriteLineGroup(kingsCrossNorthernLineGroupID).exists)

        let board =
            arrivalsPicker
            .typeInSearchField("King's Cross")
            .tapStation("HUBKGX")
            .tapLineGroup(kingsCrossNorthernLineGroupID)

        board.platformNames.firstMatch.waitToExist()
        XCTAssertEqual(
            board.platformNames.allElementsBoundByIndex.map(\.label),
            ["Northbound - Platform 7", "Southbound - Platform 8"]
        )

        let returnedArrivalsPicker =
            board
            .tapFavouriteButton()
            .tapBackButton()
            .tapEndSearchButton()
        returnedArrivalsPicker.favouriteLineGroup(kingsCrossNorthernLineGroupID).waitToExist()
    }
}
