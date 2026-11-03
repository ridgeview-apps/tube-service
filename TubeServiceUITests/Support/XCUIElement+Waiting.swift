import XCTest

/// Waits that fail the test with a clear message when they time out, so a missing element never silently skips a
/// step. With `continueAfterFailure = false` (see `UITestCase`) the failure also stops the test.
@MainActor
extension XCUIElement {

    nonisolated static let defaultTimeout: TimeInterval = 10

    @discardableResult
    func waitToExist(
        timeout: TimeInterval = defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        if !waitForExistence(timeout: timeout) {
            XCTFail("Not found within \(timeout)s: \(self)", file: file, line: line)
        }
        return self
    }

    @discardableResult
    func waitToBeHittable(
        timeout: TimeInterval = defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        waitToExist(timeout: timeout, file: file, line: line)
        if !wait(for: \.isHittable, toEqual: true, timeout: timeout) {
            XCTFail("Not hittable within \(timeout)s: \(self)", file: file, line: line)
        }
        return self
    }

    func waitToDisappear(
        timeout: TimeInterval = defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        if !waitForNonExistence(timeout: timeout) {
            XCTFail("Still showing after \(timeout)s: \(self)", file: file, line: line)
        }
    }

    func tapWhenHittable(
        timeout: TimeInterval = defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        waitToBeHittable(timeout: timeout, file: file, line: line).tap()
    }
}

@MainActor
extension XCUIApplication {

    /// Waits until no activity indicator is showing, i.e. everything on screen has loaded.
    func waitForLoadingToFinish(
        timeout: TimeInterval = XCUIElement.defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        activityIndicators.firstMatch.waitToDisappear(timeout: timeout, file: file, line: line)
    }
}
