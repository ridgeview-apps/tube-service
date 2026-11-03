import XCTest

/// A helper for one screen of the app (a page object). Its methods perform the screen's actions and return the screen
/// they lead to, so a test reads as a path through the app.
///
/// Create screens with `waitingToAppear(in:)` rather than `init(app:)`, so a test never acts on a screen that
/// hasn't loaded.
@MainActor
protocol Screen {
    var app: XCUIApplication { get }
    /// An element that only exists while this screen is showing.
    var rootElement: XCUIElement { get }

    init(app: XCUIApplication)
}

extension Screen {

    /// The screen, once its root element exists and nothing on it is still loading. Fails the test otherwise.
    static func waitingToAppear(
        in app: XCUIApplication,
        timeout: TimeInterval = XCUIElement.defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        let screen = Self(app: app)
        screen.rootElement.waitToExist(timeout: timeout, file: file, line: line)
        app.waitForLoadingToFinish(timeout: timeout, file: file, line: line)
        return screen
    }
}
