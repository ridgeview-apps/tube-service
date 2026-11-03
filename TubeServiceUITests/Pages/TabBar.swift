import Shared
import XCTest

/// The tab bar on iPhone, or the sidebar on iPad.
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

    func openJourneyPlanner() -> JourneyPlannerPage {
        select(.journeyPlanner)
        return .waitingToAppear(in: app)
    }

    func openArrivals() -> ArrivalsPickerPage {
        select(.arrivals)
        return .waitingToAppear(in: app)
    }

    func openNearby() -> NearbyPage {
        select(.nearby)
        return .waitingToAppear(in: app)
    }

    func openMaps() -> MapsPage {
        select(.maps)
        return .waitingToAppear(in: app)
    }

    private func select(_ tab: Tab) {
        item(for: tab).tapWhenHittable()
    }

    private func item(for tab: Tab) -> XCUIElement {
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.cells[tab.identifier]
        } else {
            // The iPhone tab bar's buttons have no identifiers until the selected tab first changes (see `AccessibilityID.Tab`)
            app.tabBars.buttons.element(boundBy: tab.rawValue)
        }
    }
}

extension Page {
    var tabBar: TabBar { TabBar(app: app) }
}
