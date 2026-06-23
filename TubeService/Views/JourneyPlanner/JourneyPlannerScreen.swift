import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyPlannerScreen: View {

    @State private var session = JourneyPlannerSession()
    @State private var recentJourneys: [RecentJourneyItem] = []
    @State private var hasLoaded = false

    @Environment(AppRouter.self) private var router
    @Environment(AppDataStore.self) private var appData
    @Environment(LocationDataStore.self) private var location
    @Environment(StationsDataStore.self) private var stations
    @Environment(LocalSearchResultsStore.self) private var localSearchResults

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    var body: some View {
        @Bindable var router = router
        @Bindable var session = session
        NavigationStack(path: $router.journeyPath) {
            JourneyPlannerFormView(
                form: $session.form,
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
                resetTimeSelection()
            }
            .task { initialLoad() }
        }
        .environment(session)
    }

    private func initialLoad() {
        guard !hasLoaded else {
            return
        }
        restoreUIState()
        hasLoaded = true
    }

    private func saveUIState() {
        userPreferences.cleanUpSavedJourneys()
    }

    private func restoreUIState() {
        refreshRecentJourneys(sortByLastUsedDate: true)
    }

    private func resetTimeSelection() {
        if session.form.timeSelection.date < .now {
            session.form.timeSelection = .leaveNow()
        }
    }

    private func handleLocationChangeAction(_ action: DetectLocationChangesAction) {
        switch action {
        case .nameChanged, .coordinateChanged, .authorizationStatusChanged:
            session.form.updateCurrentLocationInfo(
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
            get: {
                session.form.locationPickerValue(for: locationFieldID)
            },
            set: { newValue in
                session.form.populate(locationFieldID: locationFieldID, withValue: newValue)
            }
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
            session.form.populate(with: recentJourneyItem)
            showResults()
        case .tappedSubmit:
            showResults()
        }
    }

    private func showResults() {
        session.form.adjustCurrentTimeIfNeeded()
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
