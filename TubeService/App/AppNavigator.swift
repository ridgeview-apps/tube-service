import DataStores
import Models
import PresentationViews
import SwiftUI

// MARK: - AppTab

enum AppTab: CaseIterable, Hashable {
    case lineStatus
    case journeyPlanner
    case arrivals
    case maps
}

// MARK: - AppNavigator

@Observable
@MainActor
final class AppNavigator {

    var selectedTab: AppTab = .lineStatus

    let lineStatus: Navigator
    let journeyPlanner: Navigator
    let arrivals: Navigator
    let maps: Navigator

    init(purchases: PurchaseStore) {
        lineStatus = Navigator(purchases: purchases)
        journeyPlanner = Navigator(purchases: purchases)
        arrivals = Navigator(purchases: purchases)
        maps = Navigator(purchases: purchases)
    }

    var selectedTabNavigator: Navigator {
        navigator(for: selectedTab)
    }

    func navigator(for tab: AppTab) -> Navigator {
        switch tab {
        case .lineStatus: lineStatus
        case .journeyPlanner: journeyPlanner
        case .arrivals: arrivals
        case .maps: maps
        }
    }

    /// Dismissing a tab's modal also takes down any sheets presented above it.
    func handleNotificationLaunch(_ payload: LineStatusNotificationPayload) {
        for tab in AppTab.allCases {
            navigator(for: tab).dismissModal()
        }
        selectedTab = .lineStatus
        lineStatus.popToRoot()
        lineStatus.push(.lineStatus(.detail(lineID: payload.lineID, request: .live)))
    }
}
