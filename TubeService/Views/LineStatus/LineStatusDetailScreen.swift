import DataStores
import Models
import PresentationViews
import Shared
import SwiftUI

@MainActor
struct LineStatusDetailScreen: View {

    @Environment(PurchaseStore.self) var purchases
    @Environment(LineStatusDataStore.self) var model
    @Environment(NotificationsDataStore.self) var notifications
    @Environment(\.showSheet) var showSheet
    @Environment(\.openURL) var openURL
    @Environment(\.openSettings) var openSettings

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @AppStorage(
        UserDefaults.Keys.featureFlags.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var featureFlags: FeatureFlags = .default

    @State private var isShowingStatusHistory = false

    let line: Line
    let request: LineStatusDataStore.LineStatusRequest

    private var loadingState: LoadingState {
        return model.statusResult(for: .live)?.fetchState.loadingState ?? .loaded
    }

    private var refreshDate: Date? {
        return model.statusResult(for: .live)?.fetchedAt
    }

    private var statusHistoryAccess: LineStatusHistoryButton.Access {
        purchases.hasTubeServicePlus ? .unlocked : .locked
    }

    private var historyState: LineStatusHistoryButton.HistoryState? {
        guard let snapshots = model.disruptionSnapshots(for: line.id) else { return nil }
        let count = model.disruptionCountsByLineID[line.id] ?? 1
        if count > 1 {
            return .multipleDisruptions(count: count, firstAt: snapshots.last?.observedAt ?? snapshots[0].observedAt)
        }
        return snapshots.last.map {
            line.isDisrupted
                ? .ongoingDisruption(since: $0.observedAt)
                : .resolvedDisruption(at: $0.observedAt)
        }
    }

    private var statusContext: LineStatusDetailView.StatusContext {
        switch request {
        case .live: .live
        case .planned: .planned
        }
    }

    private var notificationButtonState: NotificationsButtonState? {
        guard featureFlags.isNotificationsEnabled else { return nil }
        guard let prefs = notifications.preferences, !prefs.lines.isEmpty else { return .notSetUp }
        switch notifications.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return prefs.lines.contains(where: { $0.lineId == line.id.rawValue && $0.enabled }) ? .active : .inactive
        case .denied:
            return .permissionDenied
        default:
            return .notSetUp
        }
    }

    var body: some View {
        LineStatusDetailView(
            line: line,
            isFavourite: isFavouriteLine(for: line.id),
            loadingState: loadingState,
            refreshDate: refreshDate,
            statusHistoryAccess: statusHistoryAccess,
            historyState: historyState,
            statusContext: statusContext,
            isStatusHistoryEnabled: featureFlags.isStatusHistoryEnabled,
            notificationButtonState: notificationButtonState,
            onAction: handleDetailViewAction
        )
        .navigationTitle(line.id.name)
        .navigationDestination(isPresented: $isShowingStatusHistory) {
            LineStatusHistoryScreen(lineID: line.id)
        }
        .toolbar {
            FavouritesButton(style: .small, isSelected: isFavouriteLine(for: line.id))
        }
    }

    private func handleDetailViewAction(_ action: LineStatusDetailView.Action) {
        switch action {
        case .linkTapped(let link):
            openURL(link.url)
        case .statusHistoryTapped:
            if purchases.hasTubeServicePlus {
                isShowingStatusHistory = true
            } else {
                showSheet(.tubeServicePlus(.statusHistory)) {
                    if purchases.hasTubeServicePlus {
                        isShowingStatusHistory = true
                    }
                }
            }
        case .notifyMeTapped:
            switch notificationButtonState {
            case .permissionDenied:
                openSettings()
            case .notSetUp, nil:
                showSheet(.notificationsOnboarding(.fullOnboarding(preselectedLine: line.id)))
            case .inactive, .active:
                showSheet(.notificationsOnboarding(.manage))
            }
        }
    }

    private func isFavouriteLine(for lineID: TrainLineID) -> Binding<Bool> {
        .init {
            userPreferences.containsFavouriteLine(lineID)
        } set: { isFavourite in
            if isFavourite {
                userPreferences.addFavouriteLine(lineID)
            } else {
                userPreferences.removeFavouriteLine(lineID)
            }
        }
    }
}
