import Shared
import XCTest

struct MapsPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.scrollViews[AccessibilityID.Maps.list] }
}
