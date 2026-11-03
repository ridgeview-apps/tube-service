import Shared
import XCTest

struct LineStatusPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.LineStatus.list] }

    /// - Parameter lineID: A `TrainLineID` raw value, e.g. "elizabeth".
    func tapLine(_ lineID: String) -> LineDetailPage {
        app.buttons[AccessibilityID.LineStatus.line(lineID)].tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    func tapThisWeekendFilter() -> LineStatusPage {
        let filter = app.buttons[AccessibilityID.LineStatus.filterThisWeekend]
        filter.tapWhenHittable()
        if !filter.wait(for: \.isSelected, toEqual: true, timeout: XCUIElement.defaultTimeout) {
            XCTFail("The This weekend filter wasn't selected")
        }
        return .waitingToAppear(in: app)
    }
}

struct LineDetailPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.scrollViews[AccessibilityID.LineStatusDetail.content] }

    func tapBackButton() -> LineStatusPage {
        app.tapBackButton()
        return .waitingToAppear(in: app)
    }
}
