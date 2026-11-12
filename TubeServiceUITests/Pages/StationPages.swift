import Shared
import XCTest

struct StationPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.scrollViews[AccessibilityID.Station.content] }

    /// The name of each platform's board for the selected line group, in the order they're shown.
    var platformNames: XCUIElementQuery {
        app.staticTexts.matching(identifier: AccessibilityID.ArrivalsBoard.platformName)
    }

    /// A line group's chip, shown only at stations with more than one line group.
    ///
    /// - Parameter lineGroupID: A `Station.LineGroup` ID, e.g. "940GZZLUKSX-northern".
    func lineChip(_ lineGroupID: String) -> XCUIElement {
        app.buttons[AccessibilityID.Station.lineChip(lineGroupID)]
    }

    /// Taps a line group's chip, which shows that line group's boards.
    func tapLineChip(_ lineGroupID: String) -> StationPage {
        lineChip(lineGroupID).tapWhenHittable()
        return self
    }

    /// Taps the star in the navigation bar, which adds the station to the favourites (or asks to remove it).
    func tapFavouriteButton() -> StationPage {
        app.buttons[AccessibilityID.FavouritesButton.button("small")].tapWhenHittable()
        return self
    }

    /// Taps the back button, which returns to the Arrivals picker the Station screen was opened from.
    func tapBackButton() -> ArrivalsPickerPage {
        app.tapBackButton()
        return .waitingToAppear(in: app)
    }
}
