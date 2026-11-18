import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyPlannerScreen: View {

    @State private var recentJourneys: [RecentJourneyItem] = []
    @State private var hasLoaded = false

    @Environment(Navigator.self) private var navigator
    @Environment(JourneyPlannerStore.self) private var journeyPlanner
    @Environment(LocationDataStore.self) private var location
    @Environment(StationsDataStore.self) private var stations

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    var body: some View {
        JourneyPlannerFormView(
            form: Bindable(journeyPlanner).form,
            recentJourneys: $recentJourneys,
            locationAccessoryStatus: .loadingState(location.detectionState.toLoadingState()),
            onAction: handleFormAction
        )
        .withSettingsToolbarButton()
        .onSceneDidBecomeActive { restoreUIState() }
        .onSceneDidBecomeInactive { saveUIState() }
        .onChange(of: userPreferences.recentlySavedJourneys) {
            refreshRecentJourneys(sortByLastUsedDate: false)  // Preserve the current order (e.g. user selects a journey, we DON'T want it to jump to the top)
        }
        .navigationTitle(Text(L10n.journeyPlannerNavigationTitle))
        .detectsLocationChanges {
            handleLocationChangeAction($0)
        }
        .onCalendarDayChanged {
            journeyPlanner.resetTimeSelectionIfPast()
        }
        .task { initialLoad() }
    }

    private func initialLoad() {
        guard !hasLoaded else { return }
        restoreUIState()
        hasLoaded = true
    }

    private func saveUIState() {
        userPreferences.cleanUpSavedJourneys()
    }

    private func restoreUIState() {
        refreshRecentJourneys(sortByLastUsedDate: true)
    }

    private func handleLocationChangeAction(_ action: DetectLocationChangesAction) {
        switch action {
        case .nameChanged, .coordinateChanged, .authorizationStatusChanged:
            journeyPlanner.updateCurrentLocationInfo(
                name: location.currentLocationName,
                coordinate: location.currentLocationCoordinate,
                updatesAllowed: location.isAuthorizedOrUndetermined
            )
        }
    }

    private func refreshRecentJourneys(sortByLastUsedDate: Bool) {
        recentJourneys = userPreferences.recentlySavedJourneys.toRecentJourneyItems(
            findStationByID: stations.station(forID:),
            findNationalRailByICSCode: stations.nationalRailStation(forICSCode:),
            sortByLastUsedDate: sortByLastUsedDate
        )
    }

    // MARK: - Form actions

    private func handleFormAction(_ actionEvent: JourneyPlannerForm.Action) {
        switch actionEvent {
        case let .tappedLocationField(locationFieldID):
            navigator.present(.journeyLocationPicker(locationFieldID))
        case let .swipedToDelete(recentJourneyItem):
            userPreferences.removeRecentJourney(recentJourneyItem.id)
        case let .tappedRecentJourney(recentJourneyItem):
            journeyPlanner.form.populate(with: recentJourneyItem)
            showResults()
        case .tappedSubmit:
            showResults()
        }
    }

    private func showResults() {
        journeyPlanner.resetForNewJourney()
        navigator.push(.journeyResults)
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment(withNavigationHost: true) {
            JourneyPlannerScreen()
        }
    }
#endif
