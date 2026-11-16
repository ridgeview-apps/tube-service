import Shared
import XCTest

struct ArrivalsPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.Arrivals.list] }

    /// Taps a station in the Nearby section, which opens its Station screen.
    ///
    /// - Parameter stationID: A `Station` ID, e.g. "HUBKGX".
    func tapNearbyStation(_ stationID: String) -> StationPage {
        app.buttons[AccessibilityID.Nearby.station(stationID)].tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    /// A station's row in the Favourites section.
    ///
    /// - Parameter stationID: A `Station` ID, e.g. "HUBKGX".
    func favouriteStation(_ stationID: String) -> XCUIElement {
        app.buttons[AccessibilityID.Arrivals.favouriteStation(stationID)]
    }

    /// Taps a favourite station, which opens its Station screen.
    func tapFavouriteStation(_ stationID: String) -> StationPage {
        favouriteStation(stationID).tapWhenHittable()
        return .waitingToAppear(in: app)
    }
}
