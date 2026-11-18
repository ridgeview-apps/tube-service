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

    // `@Observable` moves a property's default value outside the class's main-actor isolation, where creating a
    // main-actor `Navigator` can't be shown to be safe. Creating them here keeps them on the main actor.
    let lineStatus: Navigator
    let journeyPlanner: Navigator
    let arrivals: Navigator
    let maps: Navigator

    var sheetPresenter = SheetPresenter()

    init() {
        lineStatus = Navigator()
        journeyPlanner = Navigator()
        arrivals = Navigator()
        maps = Navigator()
    }

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
