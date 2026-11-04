import XCTest

/// Waits that fail the test with a clear message when they time out, so a missing element never silently skips a
/// step. With `continueAfterFailure = false` (see `UITestCase`) the failure also stops the test.
///
/// Each wait checks once straight away: XCTest's own waits only re-check about once a second, so they cost a second
/// even when the element is already there.
@MainActor
extension XCUIElement {

    nonisolated static let defaultTimeout: TimeInterval = 10

    @discardableResult
    func waitToExist(
        timeout: TimeInterval = defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        if !exists, !waitForExistence(timeout: timeout) {
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
        if !isHittable, !wait(for: \.isHittable, toEqual: true, timeout: timeout) {
            XCTFail("Not hittable within \(timeout)s: \(self)", file: file, line: line)
        }
        return self
    }

    /// Waits until the element has stopped moving, such as controls that slide in when a list enters edit mode. A tap
    /// while it's still moving can miss it.
    @discardableResult
    func waitToStopMoving(
        timeout: TimeInterval = defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        waitToExist(timeout: timeout, file: file, line: line)
        let deadline = Date.now.addingTimeInterval(timeout)
        var previousFrame = frame
        while Date.now < deadline {
            RunLoop.current.run(until: .now.addingTimeInterval(0.1))
            let currentFrame = frame
            if currentFrame == previousFrame { return self }
            previousFrame = currentFrame
        }
        XCTFail("Still moving after \(timeout)s: \(self)", file: file, line: line)
        return self
    }

    func waitToDisappear(
        timeout: TimeInterval = defaultTimeout,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        if exists, !waitForNonExistence(timeout: timeout) {
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

@MainActor
extension XCUIApplication {

    /// Taps the navigation bar's back button, which the system identifies as "BackButton" whatever its title.
    func tapBackButton() {
        navigationBars.buttons["BackButton"].tapWhenHittable()
    }
}
