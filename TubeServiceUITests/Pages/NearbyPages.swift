import Shared
import XCTest

struct NearbyPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.Nearby.list] }

    /// - Parameter stationID: A `Station` ID, e.g. "HUBKGX".
    func openStation(_ stationID: String) -> StationPage {
        app.buttons[AccessibilityID.Nearby.station(stationID)].tapWhenHittable()
        return .waitingToAppear(in: app)
    }
}

struct StationPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.scrollViews[AccessibilityID.Station.content] }
}
