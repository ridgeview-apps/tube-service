import Shared
import XCTest

struct ArrivalsPickerPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.ArrivalsPicker.list] }

    /// Taps the first row for a line group (its favourite, when it's a favourite), which opens its arrivals board.
    ///
    /// - Parameter lineGroupID: A `Station.LineGroup` ID, e.g. "910GABWDXR-elizabeth".
    func tapLineGroup(_ lineGroupID: String) -> ArrivalsBoardPage {
        app.buttons[AccessibilityID.ArrivalsPicker.lineGroup(lineGroupID)].firstMatch.tapWhenHittable()
        return .waitingToAppear(in: app)
    }
}

struct ArrivalsBoardPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.scrollViews[AccessibilityID.ArrivalsBoard.content] }
}
