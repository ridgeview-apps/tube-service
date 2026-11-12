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

    /// Taps a station outside the Favourites section, which opens its Station screen.
    ///
    /// - Parameter stationID: A `Station` ID, e.g. "HUBKGX".
    func tapStation(_ stationID: String) -> StationPage {
        app.buttons[AccessibilityID.ArrivalsPicker.station(stationID)].tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    /// A station's row in the Favourites section.
    ///
    /// - Parameter stationID: A `Station` ID, e.g. "HUBKGX".
    func favouriteStation(_ stationID: String) -> XCUIElement {
        app.buttons[AccessibilityID.ArrivalsPicker.favouriteStation(stationID)]
    }

    /// Taps a favourite station, which opens its Station screen.
    func tapFavouriteStation(_ stationID: String) -> StationPage {
        favouriteStation(stationID).tapWhenHittable()
        return .waitingToAppear(in: app)
    }
}
