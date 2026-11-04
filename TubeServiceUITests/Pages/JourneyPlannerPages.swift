import Shared
import XCTest

struct JourneyPlannerPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.JourneyPlanner.form] }

    var recentJourneys: XCUIElementQuery { app.buttons.matching(identifier: AccessibilityID.JourneyPlanner.recentJourney) }

    /// Taps the From field, which opens the location picker.
    func tapFromField() -> JourneyLocationPickerPage {
        app.buttons[AccessibilityID.JourneyPlanner.fromField].tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    /// Taps the To field, which opens the location picker.
    func tapToField() -> JourneyLocationPickerPage {
        app.buttons[AccessibilityID.JourneyPlanner.toField].tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    /// Taps Show journeys, which shows the results for the form and saves it as a recent journey.
    func tapShowJourneysButton() -> JourneyResultsPage {
        app.buttons[AccessibilityID.JourneyPlanner.showJourneysButton].tapWhenHittable()
        return .waitingToAppear(in: app)
    }

    /// Taps the most recent journey, which fills in the form and shows its results.
    func tapFirstRecentJourney() -> JourneyResultsPage {
        recentJourneys.firstMatch.tapWhenHittable()
        return .waitingToAppear(in: app)
    }
}

struct JourneyLocationPickerPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.JourneyLocationPicker.list] }

    /// Types into the search field, which replaces the suggestions with matching places.
    func typeInSearchField(_ text: String) -> JourneyLocationPickerPage {
        let searchField = app.textFields[AccessibilityID.JourneyLocationPicker.searchField]
        searchField.tapWhenHittable()
        searchField.typeText(text)
        return self
    }

    /// Taps the first search result, which fills in the field and closes the picker.
    func tapFirstSearchResult() -> JourneyPlannerPage {
        app.buttons[AccessibilityID.JourneyLocationPicker.searchResult].firstMatch.tapWhenHittable()
        rootElement.waitToDisappear()
        return .waitingToAppear(in: app)
    }
}

struct JourneyResultsPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.scrollViews[AccessibilityID.JourneyResults.content] }

    // Journey cards expand on tap, so they're exposed as switches
    private var firstJourney: XCUIElement { app.switches[AccessibilityID.JourneyResults.journey].firstMatch }
    private var firstStopsToggle: XCUIElement {
        app.switches[AccessibilityID.JourneyResults.stopsToggle].firstMatch
    }

    func tapBackButton() -> JourneyPlannerPage {
        app.tapBackButton()
        return .waitingToAppear(in: app)
    }

    /// Taps the first journey, which expands it to show its legs.
    func tapFirstJourney() -> JourneyResultsPage {
        firstJourney.tapWhenHittable()
        firstStopsToggle.waitToExist()
        return self
    }

    /// Taps the first journey's first stops button, which shows that leg's stops. Tap the journey first.
    func tapFirstStopsButton() -> JourneyResultsPage {
        // The toggle's label and value stay the same when it opens, but the journey's card grows to fit the stops
        let collapsedHeight = firstJourney.frame.height
        firstStopsToggle.tapWhenHittable()
        let deadline = Date.now.addingTimeInterval(XCUIElement.defaultTimeout)
        while firstJourney.frame.height <= collapsedHeight, Date.now < deadline {
            RunLoop.current.run(until: .now.addingTimeInterval(0.2))
        }
        if firstJourney.frame.height <= collapsedHeight {
            XCTFail("The first leg's stops didn't appear")
        }
        return self
    }
}
