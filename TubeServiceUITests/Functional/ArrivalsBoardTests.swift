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

    private let kingsCrossStationID = "HUBKGX"
    private let kingsCrossNorthernLineGroupID = "940GZZLUKSX-northern"

    @MainActor
    func testFavouritedBoardAddsItsStationToFavourites() throws {
        let app = try launchApp(with: configuration)
        let arrivals = LineStatusPage.waitingToAppear(in: app).tabBar.tapArrivalsTab()
        XCTAssertFalse(arrivals.favouriteStation(kingsCrossStationID).exists)

        let station =
            arrivals
            .tapNearbyStation(kingsCrossStationID)
            .tapLineChip(kingsCrossNorthernLineGroupID)

        XCTAssertTrue(station.lineChip(kingsCrossNorthernLineGroupID).isSelected)
        station.platformNames.firstMatch.waitToExist()
        XCTAssertEqual(
            station.platformNames.allElementsBoundByIndex.map(\.label),
            ["Northbound - Platform 7", "Southbound - Platform 8"]
        )

        let returnedArrivals =
            station
            .tapFavouriteButton()
            .tapBackButton()
        returnedArrivals.favouriteStation(kingsCrossStationID).waitToExist()
    }
}
