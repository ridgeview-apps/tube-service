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
        let arrivalsPicker = LineStatusPage.waitingToAppear(in: app).tabBar.tapArrivalsTab()
        XCTAssertFalse(arrivalsPicker.favouriteStation(kingsCrossStationID).exists)

        let station =
            arrivalsPicker
            .typeInSearchField("King's Cross")
            .tapStation(kingsCrossStationID)
            .tapLineChip(kingsCrossNorthernLineGroupID)

        XCTAssertTrue(station.lineChip(kingsCrossNorthernLineGroupID).isSelected)
        station.platformNames.firstMatch.waitToExist()
        XCTAssertEqual(
            station.platformNames.allElementsBoundByIndex.map(\.label),
            ["Northbound - Platform 7", "Southbound - Platform 8"]
        )

        let returnedArrivalsPicker =
            station
            .tapFavouriteButton()
            .tapBackButton()
            .tapEndSearchButton()
        returnedArrivalsPicker.favouriteStation(kingsCrossStationID).waitToExist()
    }
}
