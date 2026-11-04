import Shared
import XCTest

struct LineStatusPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.LineStatus.list] }

    /// A line's row outside the Favourites section.
    /// - Parameter lineID: A `TrainLineID` raw value, e.g. "elizabeth".
    func line(_ lineID: String) -> XCUIElement {
        app.buttons[AccessibilityID.LineStatus.line(lineID)]
    }

    /// A line's row in the Favourites section.
    /// - Parameter lineID: A `TrainLineID` raw value, e.g. "elizabeth".
    func favouriteLine(_ lineID: String) -> XCUIElement {
        app.buttons[AccessibilityID.LineStatus.favouriteLine(lineID)]
    }

    /// Taps a favourite line, which shows its detail.
    func tapFavouriteLine(_ lineID: String) -> LineDetailPage {
        favouriteLine(lineID).tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    /// Taps Edit in the Favourites header, which shows the reorder and remove controls.
    func tapEditFavouritesButton() -> LineStatusPage {
        app.buttons[AccessibilityID.LineStatus.editFavouritesButton].tapWhenHittable()
        // The controls slide in, so wait for them to settle before anything taps them
        app.images[Self.removeControlImage].firstMatch.waitToStopMoving()
        return self
    }

    /// Taps Done in the Favourites header, which hides the reorder and remove controls.
    func tapDoneEditingFavouritesButton() -> LineStatusPage {
        app.buttons[AccessibilityID.LineStatus.editFavouritesButton].tapWhenHittable()
        app.images[Self.reorderHandleImage].firstMatch.waitToDisappear()
        return self
    }

    /// Drags a favourite line's reorder handle onto the lower part of another favourite, which moves it below that
    /// line. Tap Edit first.
    func dragFavouriteLine(_ lineID: String, below otherLineID: String) -> LineStatusPage {
        // Like the remove control, the handle can fail XCTest's hittability check, so it's pressed by coordinate
        let handle = favouriteCell(lineID).images[Self.reorderHandleImage].firstMatch.waitToStopMoving()
        let target = favouriteCell(otherLineID).coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        handle.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            .press(forDuration: 0.5, thenDragTo: target, withVelocity: .slow, thenHoldForDuration: 0.5)
        return self
    }

    /// Taps a favourite line's remove control, which shows its Delete button. Tap Edit first.
    func tapRemoveButton(onFavouriteLine lineID: String) -> LineStatusPage {
        // Each row exposes two identical remove images, so XCTest can't work out where either is hittable; tap its
        // centre instead, once it has finished sliding in
        let removeControl = favouriteCell(lineID).images[Self.removeControlImage].firstMatch.waitToStopMoving()
        removeControl.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        return self
    }

    /// Taps a favourite line's Delete button, which removes it from favourites. Tap its remove control first.
    func tapDeleteButton(onFavouriteLine lineID: String) -> LineStatusPage {
        // The system's Delete button has no identifier, so it's found by its label (see AGENTS.md). It sits outside the
        // list's element tree, so it can't be scoped to the row, but only one row shows it at a time.
        app.buttons["Delete"].tapWhenHittable()
        favouriteLine(lineID).waitToDisappear()
        return self
    }

    // The system's edit mode controls have no identifiers, but their images are named after their SF Symbols
    private static let reorderHandleImage = "line.horizontal.3"
    private static let removeControlImage = "minus.circle.fill"

    private func favouriteCell(_ lineID: String) -> XCUIElement {
        app.cells.containing(.button, identifier: AccessibilityID.LineStatus.favouriteLine(lineID)).firstMatch
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
