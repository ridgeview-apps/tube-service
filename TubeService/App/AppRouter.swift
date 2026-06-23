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
    private var onSheetDismiss: (() -> Void)?

    func showSheet(_ sheet: Sheet, onDismiss: (() -> Void)? = nil) {
        presentedSheet = sheet
        onSheetDismiss = onDismiss
    }

    func handleSheetDismiss() {
        onSheetDismiss?()
        onSheetDismiss = nil
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
