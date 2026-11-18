import Shared
import XCTest

struct StationArrivalsPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.scrollViews[AccessibilityID.StationArrivals.content] }

    /// The name of each platform's board for the selected line group, in the order they're shown.
    var platformNames: XCUIElementQuery {
        app.staticTexts.matching(identifier: AccessibilityID.ArrivalsBoard.platformName)
    }

    /// A line group's chip, shown only at stations with more than one line group.
    ///
    /// - Parameter lineGroupID: A `Station.LineGroup` ID, e.g. "940GZZLUKSX-northern".
    func lineChip(_ lineGroupID: String) -> XCUIElement {
        app.buttons[AccessibilityID.StationArrivals.lineChip(lineGroupID)]
    }

    /// Taps a line group's chip, which shows that line group's boards.
    func tapLineChip(_ lineGroupID: String) -> StationArrivalsPage {
        lineChip(lineGroupID).tapWhenHittable()
        return self
    }

    /// Taps the star in the navigation bar, which adds the station to the favourites (or asks to remove it).
    func tapFavouriteButton() -> StationArrivalsPage {
        app.buttons[AccessibilityID.FavouritesButton.button("small")].tapWhenHittable()
        return self
    }

    /// Taps the info button in the navigation bar, which presents the station's line statuses and notices.
    func tapInfoButton() -> StationInfoPage {
        app.buttons[AccessibilityID.StationArrivals.infoButton].tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    /// Taps the back button, which returns to the Arrivals screen the Station screen was opened from.
    func tapBackButton() -> ArrivalsPage {
        app.tapBackButton()
        return .waitingToAppear(in: app)
    }
}

struct StationInfoPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.StationInfo.list] }

    /// Taps a line's row, which pushes its detail inside the sheet.
    ///
    /// - Parameter lineID: A `TrainLineID` raw value, e.g. "northern".
    func tapLine(_ lineID: String) -> LineDetailPage<StationInfoPage> {
        app.buttons[AccessibilityID.StationInfo.line(lineID)].tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    /// Taps the close button, which returns to the Station screen underneath.
    func tapCloseButton() -> StationArrivalsPage {
        app.buttons[AccessibilityID.NavigationButton.close].tapWhenHittable()
        return .waitingToAppear(in: app)
    }
}
