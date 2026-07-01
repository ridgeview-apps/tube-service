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
    @Environment(AppRouter.self) var router
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

    let lineID: TrainLineID
    let request: LineStatusDataStore.LineStatusRequest

    private var line: Line? {
        model.lineStatusData(for: request)?.value.first { $0.id == lineID }
    }

    private var loadingState: LoadingState {
        return model.lineStatusData(for: .live)?.fetchState.loadingState ?? .loaded
    }

    private var refreshDate: Date? {
        return model.lineStatusData(for: .live)?.fetchedAt
    }

    private var historyState: LineStatusHistoryButton.HistoryState? {
        guard let snapshots = model.disruptionSnapshots(for: lineID) else { return nil }
        let count = model.disruptionCountsByLineID[lineID] ?? 1
        if count > 1 {
            return .multipleDisruptions(count: count, firstAt: snapshots.last?.observedAt ?? snapshots[0].observedAt)
        }
        return snapshots.last.map {
            line?.isDisrupted == true
                ? .ongoingDisruption(since: $0.observedAt)
                : .resolvedDisruption(at: $0.observedAt)
        }
    }

    private var historyButtonState: LineStatusHistoryButton.ButtonState? {
        guard featureFlags.isStatusHistoryEnabled else { return nil }
        return purchases.hasTubeServicePlus ? .unlocked(historyState) : .locked(historyState)
    }

    private var statusContext: LineStatusDetailView.StatusContext {
        switch request {
        case .live: .live
        case .planned: .planned
        }
    }

    private var notificationButtonState: NotificationsButtonState? {
        guard featureFlags.isNotificationsEnabled else { return nil }
        guard purchases.hasTubeServicePlus else { return .locked }
        guard let prefs = notifications.preferences, !prefs.lines.isEmpty else {
            return .notSetUp
        }
        if notifications.canReceivePushNotifications {
            return prefs.lines.contains(where: { $0.lineId == lineID.rawValue && $0.enabled }) ? .active : .inactive
        } else if notifications.isPermissionDenied {
            return .permissionDenied
        } else {
            return .notSetUp
        }
    }

    var body: some View {
        Group {
            if let line {
                LineStatusDetailView(
                    line: line,
                    isFavourite: isFavouriteLine(for: lineID),
                    loadingState: loadingState,
                    refreshDate: refreshDate,
                    historyButtonState: historyButtonState,
                    statusContext: statusContext,
                    notificationButtonState: notificationButtonState,
                    onAction: handleDetailViewAction
                )
            }
        }
        .navigationTitle(lineID.name)
        .toolbar {
            FavouritesButton(style: .small, isSelected: isFavouriteLine(for: lineID))
        }
    }

    private func handleDetailViewAction(_ action: LineStatusDetailView.Action) {
        switch action {
        case .linkTapped(let link):
            openURL(link.url)
        case .statusHistoryTapped:
            if purchases.hasTubeServicePlus {
                router.push(.lineStatusHistory(lineID: lineID))
            } else {
                router.showSheet(
                    .tubeServicePlus(
                        .statusHistory,
                        onAction: handleTubeServicePlusAction
                    )
                )
            }
        case .notifyMeTapped:
            router.showSheet(
                .notificationSettings(.lineDetail(lineID), notifications.hasCompletedOnboarding ? .manage : .onboarding)
            )
        }
    }

    private func handleTubeServicePlusAction(_ action: TubeServicePlusView.Action) {
        switch action {
        case .purchaseSuccess:
            router.dismissSheets()
            router.push(.lineStatusHistory(lineID: lineID))
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
