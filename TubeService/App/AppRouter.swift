import DataStores
import Models
import PresentationViews
import SwiftUI

// MARK: - AppTab

enum AppTab: Hashable {
    case lineStatus
    case journeyPlanner
    case arrivals
    case nearby
    case maps
}

// MARK: - AppRoute

enum AppRoute: Hashable {
    case journeyResults
    case lineStatusDetail(lineID: TrainLineID, request: LineStatusDataStore.LineStatusRequest)
    case lineStatusHistory(lineID: TrainLineID)
    case arrivalsBoard(lineGroup: Station.LineGroup, stationName: String)
    case stationDetail(station: Station)
    case mapDetail(mapLink: MapLink)
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
    var nearby = NavigationRouter<AppRoute>()
    var maps = NavigationRouter<AppRoute>()

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
        case .nearby: nearby.push(route)
        case .maps: maps.push(route)
        }
    }

    func popToRoot(on tab: AppTab) {
        switch tab {
        case .lineStatus: lineStatus.popToRoot()
        case .journeyPlanner: journeyPlanner.popToRoot()
        case .arrivals: arrivals.popToRoot()
        case .nearby: nearby.popToRoot()
        case .maps: maps.popToRoot()
        }
    }

    func handleNotificationLaunch(_ payload: LineStatusNotificationPayload) {
        dismissSheets()
        popToRoot(on: .lineStatus)
        push(.lineStatusDetail(lineID: payload.lineID, request: .live), on: .lineStatus)
    }
}
