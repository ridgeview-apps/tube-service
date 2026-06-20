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

    private var notificationButtonState: LineStatusNotificationButton.SubscriptionState? {
        guard featureFlags.isNotificationsEnabled else { return nil }
        if notifications.preferences == nil && notifications.isFetchingPreferences { return nil }
        guard let prefs = notifications.preferences, prefs.enabled else { return .notSubscribed }
        switch notifications.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return prefs.lineIds.contains(line.id.rawValue) ? .active : .inactive
        default:
            return .permissionDenied
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
                showSheet(.tubeServicePlus) {
                    if purchases.hasTubeServicePlus {
                        isShowingStatusHistory = true
                    }
                }
            }
        case .notifyMeTapped(let action):
            switch action {
            case .notSubscribedTapped:
                showSheet(.notificationsOnboarding(preselectedLine: line.id))
            case .permissionDeniedTapped:
                if notifications.authorizationStatus == .denied {
                    openURL(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    showSheet(.notificationsOnboarding(preselectedLine: line.id))
                }
            case .addLine:
                Task { await addLineToNotifications() }
            case .removeLine:
                Task { await removeLineFromNotifications() }
            }
        }
    }

    private func addLineToNotifications() async {
        guard let prefs = notifications.preferences else { return }
        let update = NotificationPreferencesUpdate(
            enabled: prefs.enabled,
            lineIds: prefs.lineIds + [line.id.rawValue],
            severityThreshold: prefs.severityThreshold,
            notifyRecoveries: prefs.notifyRecoveries,
            schedulePreset: prefs.schedulePreset,
            customSchedules: prefs.customSchedules
        )
        await notifications.updatePreferences(update)
    }

    private func removeLineFromNotifications() async {
        guard let prefs = notifications.preferences else { return }
        let update = NotificationPreferencesUpdate(
            enabled: prefs.enabled,
            lineIds: prefs.lineIds.filter { $0 != line.id.rawValue },
            severityThreshold: prefs.severityThreshold,
            notifyRecoveries: prefs.notifyRecoveries,
            schedulePreset: prefs.schedulePreset,
            customSchedules: prefs.customSchedules
        )
        await notifications.updatePreferences(update)
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
