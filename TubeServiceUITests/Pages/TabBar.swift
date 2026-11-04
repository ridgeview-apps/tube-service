import Shared
import XCTest

/// The tab bar on iPhone, or the sidebar or top tab bar on iPad.
@MainActor
struct TabBar {

    /// The app's tabs, in the order it shows them.
    enum Tab: Int {
        case lineStatus, journeyPlanner, arrivals, nearby, maps

        var identifier: String {
            switch self {
            case .lineStatus: AccessibilityID.Tab.lineStatus
            case .journeyPlanner: AccessibilityID.Tab.journeyPlanner
            case .arrivals: AccessibilityID.Tab.arrivals
            case .nearby: AccessibilityID.Tab.nearby
            case .maps: AccessibilityID.Tab.maps
            }
        }
    }

    let app: XCUIApplication

    func tapJourneyPlannerTab() -> JourneyPlannerPage {
        tap(.journeyPlanner)
        return .waitingToAppear(in: app)
    }

    func tapArrivalsTab() -> ArrivalsPickerPage {
        tap(.arrivals)
        return .waitingToAppear(in: app)
    }

    func tapNearbyTab() -> NearbyPage {
        tap(.nearby)
        return .waitingToAppear(in: app)
    }

    func tapMapsTab() -> MapsPage {
        tap(.maps)
        return .waitingToAppear(in: app)
    }

    private func tap(_ tab: Tab) {
        item(for: tab).tapWhenHittable()
    }

    private func item(for tab: Tab) -> XCUIElement {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // A cell in the sidebar or a button in the top tab bar, whichever the iPad shows
            app.descendants(matching: .any).matching(identifier: tab.identifier).firstMatch
        } else {
            // The iPhone tab bar's buttons have no identifiers until the selected tab first changes (see `AccessibilityID.Tab`)
            app.tabBars.buttons.element(boundBy: tab.rawValue)
        }
    }
}

extension Page {
    var tabBar: TabBar { TabBar(app: app) }
}
