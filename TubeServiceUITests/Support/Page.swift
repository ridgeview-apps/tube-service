import XCTest

/// A page object: the queries and actions for one screen of the app. Actions return the page they lead to, so a test
/// reads as a path through the app. Pages don't assert on content; tests do.
///
/// Get pages from `waitingToAppear(in:)` rather than `init(app:)`, so a test never acts on a screen that hasn't
/// loaded.
@MainActor
protocol Page {
    var app: XCUIApplication { get }
    /// An element that only exists while this page is showing.
    var rootElement: XCUIElement { get }

    init(app: XCUIApplication)
}

extension Page {

    /// The page, once its root element exists and nothing on it is still loading. Fails the test otherwise.
    static func waitingToAppear(
        in app: XCUIApplication,
        timeout: TimeInterval = XCUIElement.defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        let page = Self(app: app)
        page.rootElement.waitToExist(timeout: timeout, file: file, line: line)
        app.waitForLoadingToFinish(timeout: timeout, file: file, line: line)
        return page
    }
}
