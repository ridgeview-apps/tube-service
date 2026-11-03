import XCTest

/// The base for fastlane snapshot tests. Screenshots are numbered in the order they're captured, so they appear in
/// that order in App Store Connect.
class ScreenshotTestCase: UITestCase {

    private var captureCount = 0

    @MainActor
    override func prepareForLaunch(_ app: XCUIApplication) {
        setupSnapshot(app)
    }

    /// Captures `screen` as "NN-`name`" once it has finished loading.
    @MainActor
    func capture(
        _ screen: some Screen,
        as name: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        screen.rootElement.waitToExist(file: file, line: line)
        screen.app.waitForLoadingToFinish(file: file, line: line)
        captureCount += 1
        snapshot(String(format: "%02d-%@", captureCount, name))
    }
}
