import DataStores
import Models
import PresentationViews
import SwiftUI

// MARK: - AppTab

enum AppTab: Hashable {
    case lineStatus
    case journeyPlanner
    case arrivals
    case maps
    case search
}

// MARK: - AppRoute

enum AppRoute: Hashable {
    case journeyResults
    case lineStatusDetail(lineID: TrainLineID, request: LineStatusDataStore.LineStatusRequest)
    case lineStatusHistory(lineID: TrainLineID)
    case station(Station)
    case mapDetail(mapLink: MapLink)
}

// MARK: - SearchFieldState

struct SearchFieldState {
    var text = ""
    var isPresented = false
}

// MARK: - AppRouter

@Observable
@MainActor
final class AppRouter {

    // Tabs
    var selectedTab: AppTab = .lineStatus

    // Paths
    var lineStatus = NavigationRouter<AppRoute>()
    var journeyPlanner = NavigationRouter<AppRoute>()
    var arrivals = NavigationRouter<AppRoute>()
    var maps = NavigationRouter<AppRoute>()
    var search = NavigationRouter<AppRoute>()

    // Search
    var searchField = SearchFieldState()

    func startSearch() {
        selectedTab = .search
        searchField.isPresented = true
    }

    // Sheets
    var sheetPresenter = SheetPresenter()

    func showSheet(_ sheet: Sheet) {
        sheetPresenter.show(sheet)
    }

    func dismissSheets(
        closePresentedSheet: Bool = true,
        closeFullScreenSheet: Bool = true
    ) {
        sheetPresenter.dismiss(
            closePresentedSheet: closePresentedSheet,
            closeFullScreenSheet: closeFullScreenSheet
        )
    }

    func push(_ route: AppRoute, on targetTab: AppTab? = nil) {
        selectedTab = targetTab ?? selectedTab
        switch selectedTab {
        case .lineStatus: lineStatus.push(route)
        case .journeyPlanner: journeyPlanner.push(route)
        case .arrivals: arrivals.push(route)
        case .maps: maps.push(route)
        case .search: search.push(route)
        }
    }

    func popToRoot(on tab: AppTab) {
        switch tab {
        case .lineStatus: lineStatus.popToRoot()
        case .journeyPlanner: journeyPlanner.popToRoot()
        case .arrivals: arrivals.popToRoot()
        case .maps: maps.popToRoot()
        case .search: search.popToRoot()
        }
    }

    func handleNotificationLaunch(_ payload: LineStatusNotificationPayload) {
        dismissSheets()
        popToRoot(on: .lineStatus)
        push(.lineStatusDetail(lineID: payload.lineID, request: .live), on: .lineStatus)
    }
}
