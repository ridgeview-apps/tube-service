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
}

// MARK: - AppNavigator

@Observable
@MainActor
final class AppNavigator {

    var selectedTab: AppTab = .lineStatus

    let lineStatus = Navigator()
    let journeyPlanner = Navigator()
    let arrivals = Navigator()
    let maps = Navigator()

    var sheetPresenter = SheetPresenter()

    func showSheet(_ sheet: Sheet) {
        sheetPresenter.show(sheet)
    }

    func dismissSheets() {
        sheetPresenter.dismiss()
    }

    func handleNotificationLaunch(_ payload: LineStatusNotificationPayload) {
        dismissSheets()
        selectedTab = .lineStatus
        lineStatus.popToRoot()
        lineStatus.push(.lineStatusDetail(lineID: payload.lineID, request: .live))
    }
}
