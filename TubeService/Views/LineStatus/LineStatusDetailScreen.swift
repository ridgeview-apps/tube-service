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

    @AppStorage(
        UserDefaults.Keys.newFeatureBadges.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var newFeatureBadges: NewFeatureBadges = .default

    @State private var notificationSavingState: LoadingState = .loaded
    @State private var notificationSaveSuccessCount = 0

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

    private var historyState: LineStatusHistoryButton.HistoryState {
        guard let snapshots = model.disruptionSnapshots(for: lineID) else { return .noDisruption }
        let count = model.disruptionCountsByLineID[lineID] ?? 1
        if count > 1 {
            return .multipleDisruptions(count: count, firstAt: snapshots.last?.observedAt ?? snapshots[0].observedAt)
        }
        return snapshots.last.map {
            line?.isDisrupted == true
                ? .ongoingDisruption(since: $0.observedAt)
                : .resolvedDisruption(at: $0.observedAt)
        } ?? .noDisruption
    }

    private var historyButtonState: LineStatusHistoryButton.ButtonState? {
        guard featureFlags.isStatusHistoryEnabled else { return nil }
        return purchases.hasTubeServicePlus ? .unlocked(historyState) : .locked
    }

    /// The new features whose buttons are on screen; the buttons only appear for live statuses.
    private var displayedNewFeatures: Set<NewFeature> {
        guard case .live = request else { return [] }
        var features: Set<NewFeature> = []
        if historyButtonState != nil { features.insert(.statusHistory) }
        if notificationButtonState != nil { features.insert(.lineNotifications) }
        return features
    }

    private var badgedNewFeatures: Set<NewFeature> {
        displayedNewFeatures.filter { newFeatureBadges.showsBadge(for: $0, now: .now) }
    }

    private var statusContext: LineStatusDetailView.StatusContext {
        switch request {
        case .live: .live
        case .planned: .planned
        }
    }

    private var notificationButtonState: LineNotificationsButtonState? {
        guard featureFlags.isNotificationsEnabled else { return nil }
        guard purchases.hasTubeServicePlus else { return .locked }
        if notifications.isPermissionDenied {
            return .permissionDenied
        }
        if notifications.isNotifying(for: lineID) { return .active }
        let isPaused = notifications.linePreferences.contains(where: { $0.lineId == lineID.rawValue && !$0.enabled })
        return isPaused ? .paused : .notSetUp
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
                    notificationSavingState: notificationSavingState,
                    newFeatures: badgedNewFeatures,
                    onAction: handleDetailViewAction
                )
            }
        }
        .onAppear {
            for feature in displayedNewFeatures {
                newFeatureBadges.recordSeen(feature, at: .now)
            }
        }
        .sensoryFeedback(.success, trigger: notificationSaveSuccessCount)
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
            newFeatureBadges.recordUsed(.statusHistory)
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
        case .notifyMeTapped(let state):
            newFeatureBadges.recordUsed(.lineNotifications)
            if state == .permissionDenied {
                openSettings()
            } else if notifications.isConfigured {
                router.showSheet(
                    .notificationsFlow(.manage(.singleLine(lineID)))
                )
            } else {
                router.showSheet(
                    .notificationsFlow(.onboarding(defaultLineID: lineID))
                )
            }
        case .setNotificationsPaused(let isPaused):
            setNotificationsPaused(isPaused)
        case .notificationsErrorDismissed:
            // Tapping Try Again also dismisses the alert; leave the retry's loading state alone.
            if case .failure = notificationSavingState {
                notificationSavingState = .loaded
            }
        }
    }

    private func setNotificationsPaused(_ isPaused: Bool) {
        notificationSavingState = .loading
        Task {
            do {
                try await notifications.updateLinePreferences(with: .setEnabled(!isPaused, for: lineID))
                notificationSavingState = .loaded
                notificationSaveSuccessCount += 1
            } catch {
                notificationSavingState = .failure(errorMessage: error.toSaveErrorMessage())
            }
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
