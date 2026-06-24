import DataStores
import Models
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
}

// MARK: - AppRouter

@Observable
@MainActor
final class AppRouter {

    var selectedTab: AppTab = .lineStatus
    var lineStatusPath: [AppRoute] = []
    var journeyPath: [AppRoute] = []
    var arrivalsPath: [AppRoute] = []
    var nearbyPath: [AppRoute] = []
    var mapsPath: [AppRoute] = []
    var presentedSheet: Sheet?

    func showSheet(_ sheet: Sheet) {
        presentedSheet = sheet
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func push(_ route: AppRoute, on targetTab: AppTab? = nil) {
        selectedTab = targetTab ?? selectedTab
        switch selectedTab {
        case .lineStatus: lineStatusPath.append(route)
        case .journeyPlanner: journeyPath.append(route)
        case .arrivals: arrivalsPath.append(route)
        case .nearby: nearbyPath.append(route)
        case .maps: mapsPath.append(route)
        }
    }
}
