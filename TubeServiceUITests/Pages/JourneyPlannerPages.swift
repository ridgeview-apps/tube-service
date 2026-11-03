import Shared
import XCTest

struct JourneyPlannerPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.JourneyPlanner.form] }

    /// Taps the most recent journey, which fills in the form and shows its results.
    func tapFirstRecentJourney() -> JourneyResultsPage {
        app.buttons[AccessibilityID.JourneyPlanner.recentJourney].firstMatch.tapWhenHittable()
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
