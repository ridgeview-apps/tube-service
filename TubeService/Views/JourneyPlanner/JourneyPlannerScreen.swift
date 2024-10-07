import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyPlannerScreen: View {
    
    enum DestinationID: Identifiable, Hashable {
        var id: Self { self }
        case results
    }
    
    @State private var form: JourneyPlannerForm = .empty
    @State private var recentJourneys: [RecentJourneyItem] = []
    @State private var hasLoaded = false

    @State private var navigationState = NavigationState<DestinationID>()
    
    @Environment(LocationDataStore.self) var location
    @Environment(StationsDataStore.self) var stations
    @Environment(LocalSearchCompleter.self) var localSearchCompleter
    @Environment(\.showSheet) var showSheet
    
    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: .standard)
    private var userPreferences: UserPreferences = .default
    
    var body: some View {
        NavigationStack(path: $navigationState.navigationPath) {
            JourneyPlannerFormView(
                form: $form,
                recentJourneys: $recentJourneys,
                locationAccessoryStatus: .loadingState(location.detectionState.toLoadingState()),
                onAction: handleFormAction
            )
            .withSettingsToolbarButton()
            .onSceneDidBecomeActive { restoreUIState() }
            .onSceneDidBecomeInactive { saveUIState() }
            .onChange(of: userPreferences.recentlySavedJourneys) {
                refreshRecentJourneys(sortByLastUsedDate: false) // Preserve the current order (e.g. user selects a journey, we DON'T want it to jump to the top)
            }
            .navigationTitle(Text(.journeyPlannerNavigationTitle))
            .withNavigationState($navigationState) { destinationID in
                destinationScreen(for: destinationID)
            }
            .detectsLocationChanges {
                handleLocationChangeAction($0)
            }
            .onCalendarDayChanged {
                resetTimeSelection()
            }
            .task { initialLoad() }
        }
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
        if form.timeSelection.date < .now {
            form.timeSelection = .leaveNow()
        }
    }

    private func handleLocationChangeAction(_ action: DetectLocationChangesAction) {
        switch action {
        case .nameChanged, .coordinateChanged, .authorizationStatusChanged:
            form.updateCurrentLocationInfo(
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
    
    
    // MARK: - Navigation
    
    @ViewBuilder
    private func destinationScreen(for destinationID: DestinationID) -> some View {
        Group {
            switch destinationID {
            case .results:
                JourneyResultsScreen(form: $form)
            }
        }
    }
    
    private func currentFormValue(forLocationFieldID locationFieldID: JourneyPlannerForm.FieldID.LocationID) -> Binding<JourneyLocationPicker.Value?> {
        .init(
            get: {
                form.locationPickerValue(for: locationFieldID)
            },
            set: { newValue in
                form.populate(locationFieldID: locationFieldID, withValue: newValue)
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
            showSheet(.journeyLocationPicker(config))
        case let .swipedToDelete(recentJourneyItem):
            userPreferences.removeRecentJourney(recentJourneyItem.id)
        case let .tappedRecentJourney(recentJourneyItem):
            form.populate(with: recentJourneyItem)
            showResults()
        case .tappedSubmit:
            showResults()
        }
    }
    
    private func showResults() {
        form.adjustCurrentTimeIfNeeded()
        navigationState.push(to: .results)
    }
}

private extension JourneyPlannerForm.FieldID.LocationID {
    
    var navigationTitle: LocalizedStringResource {
        switch self {
        case .from:
            .journeyPlannerLocationPickerScreenFromNavigationTitle
        case .to:
            .journeyPlannerLocationPickerScreenToNavigationTitle
        case .via:
            .journeyPlannerLocationPickerScreenViaNavigationTitle
        }
    }
}


// MARK: - Previews

#if DEBUG
#Preview {
    JourneyPlannerScreen()
        .withStubbedEnvironment()
}
#endif
