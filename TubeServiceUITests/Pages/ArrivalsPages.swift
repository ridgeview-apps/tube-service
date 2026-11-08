import Shared
import XCTest

struct ArrivalsPickerPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.ArrivalsPicker.list] }

    // The list's search field and its buttons are system controls with no identifiers or images. The field is found
    // as the only search field, and the buttons by their labels in the narrowest scope that contains them (see
    // AGENTS.md).
    private var searchField: XCUIElement { app.searchFields.firstMatch }
    private static let closeSearchButtonLabel = "Close"
    private static let clearSearchButtonLabel = "Clear text"

    /// Types into the search field, which replaces the list with the matching stations.
    func typeInSearchField(_ text: String) -> ArrivalsPickerPage {
        searchField.tapWhenHittable()
        searchField.typeText(text)
        return self
    }

    /// Taps the button that ends the search, which shows the favourites again: Close beside the search field on
    /// iPhone, or the field's Clear text button on iPad, where the field sits in the toolbar with no Close button.
    func tapEndSearchButton() -> ArrivalsPickerPage {
        let button =
            UIDevice.current.userInterfaceIdiom == .pad
            ? searchField.buttons[Self.clearSearchButtonLabel]
            : app.navigationBars.buttons[Self.closeSearchButtonLabel]
        button.tapWhenHittable()
        // Each button only shows while there's a search to end
        button.waitToDisappear()
        return self
    }

    /// Taps a station outside the Favourites section, which expands it to show its line groups.
    ///
    /// - Parameter stationID: A `Station` ID, e.g. "HUBKGX".
    func tapStation(_ stationID: String) -> ArrivalsPickerPage {
        app.buttons[AccessibilityID.ArrivalsPicker.station(stationID)].tapWhenHittable()
        return self
    }

    /// Taps a line group outside the Favourites section, which opens its arrivals board.
    ///
    /// - Parameter lineGroupID: A `Station.LineGroup` ID, e.g. "940GZZLUKSX-northern".
    func tapLineGroup(_ lineGroupID: String) -> ArrivalsBoardPage {
        app.buttons[AccessibilityID.ArrivalsPicker.lineGroup(lineGroupID)].tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    /// A line group's row in the Favourites section.
    ///
    /// - Parameter lineGroupID: A `Station.LineGroup` ID, e.g. "910GABWDXR-elizabeth".
    func favouriteLineGroup(_ lineGroupID: String) -> XCUIElement {
        app.buttons[AccessibilityID.ArrivalsPicker.favouriteLineGroup(lineGroupID)]
    }

    /// Taps a favourite line group, which opens its arrivals board.
    func tapFavouriteLineGroup(_ lineGroupID: String) -> ArrivalsBoardPage {
        favouriteLineGroup(lineGroupID).tapWhenHittable()
        return .waitingToAppear(in: app)
    }
}

struct ArrivalsBoardPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.scrollViews[AccessibilityID.ArrivalsBoard.content] }

    /// The name of each platform's board, in the order they're shown.
    var platformNames: XCUIElementQuery {
        app.staticTexts.matching(identifier: AccessibilityID.ArrivalsBoard.platformName)
    }

    /// Taps the star in the navigation bar, which adds the line group to the favourites (or asks to remove it).
    func tapFavouriteButton() -> ArrivalsBoardPage {
        app.buttons[AccessibilityID.FavouritesButton.button("small")].tapWhenHittable()
        return self
    }

    func tapBackButton() -> ArrivalsPickerPage {
        app.tapBackButton()
        return .waitingToAppear(in: app)
    }
}
