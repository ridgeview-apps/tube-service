import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyPlannerScreen: View {

    @State private var recentJourneys: [RecentJourneyItem] = []
    @State private var hasLoaded = false

    @Environment(AppRouter.self) private var router
    @Environment(JourneyPlannerStore.self) private var journeyPlanner
    @Environment(LocationDataStore.self) private var location
    @Environment(StationsDataStore.self) private var stations

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    var body: some View {
        @Bindable var router = router
        @Bindable var journeyPlanner = journeyPlanner
        NavigationStack(path: $router.journeyPath) {
            JourneyPlannerFormView(
                form: $journeyPlanner.form,
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
            .appRouteDestinations()
            .detectsLocationChanges {
                handleLocationChangeAction($0)
            }
            .onCalendarDayChanged {
                journeyPlanner.resetTimeSelectionIfNeeded()
            }
            .task { initialLoad() }
        }
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

    private func currentFormValue(forLocationFieldID locationFieldID: JourneyPlannerForm.FieldID.LocationID) -> Binding<JourneyLocationPicker.Value?> {
        .init(
            get: { journeyPlanner.form.locationValue(for: locationFieldID) },
            set: { newValue in journeyPlanner.form.populate(locationFieldID: locationFieldID, with: newValue) }
        )
    }

    // MARK: - Form actions

    private func handleFormAction(_ actionEvent: JourneyPlannerForm.Action) {
        switch actionEvent {
        case let .tappedLocationField(locationFieldID):
            let config = JourneyLocationPickerScreen.Config(
                navigationTitle: locationFieldID.navigationTitle,
                recentJourneys: recentJourneys,
                currentSelection: currentFormValue(forLocationFieldID: locationFieldID)
            )
            router.showSheet(.journeyLocationPicker(config))
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
        router.push(.journeyResults)
    }
}

private extension JourneyPlannerForm.FieldID.LocationID {

    var navigationTitle: LocalizedStringResource {
        switch self {
        case .from:
            L10n.journeyPlannerLocationPickerScreenFromNavigationTitle
        case .to:
            L10n.journeyPlannerLocationPickerScreenToNavigationTitle
        case .via:
            L10n.journeyPlannerLocationPickerScreenViaNavigationTitle
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            JourneyPlannerScreen()
        }
        .environment(AppRouter())
    }
#endif
