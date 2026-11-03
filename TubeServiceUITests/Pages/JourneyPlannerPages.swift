import Shared
import XCTest

struct JourneyPlannerPage: Page {
    let app: XCUIApplication
    var rootElement: XCUIElement { app.collectionViews[AccessibilityID.JourneyPlanner.form] }

    /// Plans the most recent journey, which fills in the form and shows its results.
    func planRecentJourney() -> JourneyResultsPage {
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

    /// Expands the first journey to show its legs.
    func expandFirstJourney() -> JourneyResultsPage {
        firstJourney.tapWhenHittable()
        firstStopsToggle.waitToExist()
        return self
    }

    /// Shows the stops of the first journey's first leg that has them. Expand the journey first.
    func showFirstLegStops() -> JourneyResultsPage {
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
