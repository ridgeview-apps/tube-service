import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyResultsScreen: View {
    
    @State private var pages: [JourneyResultsPage] = []
    @State private var hasFetchedInitialData = false
    
    @Environment(\.transportAPI) var transportAPI
    @Environment(LocationDataStore.self) var location
    @Environment(StationsDataStore.self) var stations
    @Environment(LocalSearchCompleter.self) var localSearchCompleter
    
    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: .standard)
    private var userPreferences: UserPreferences = .default

    @Binding var form: JourneyPlannerForm
    
    @Namespace private var animationNamespace
    
    private var modeIDS: Set<ModeID> { userPreferences.journeyPlannerModeIDs }
    
    var body: some View {
        JourneyResultsView(
            pages: $pages,
            fromLocation: $form.from,
            toLocation: $form.to,
            viaLocation: form.via,
            timeoption: form.timeSelection,
            onAction: { handleAction($0) }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(.journeyResultsNavigationTitle))
    }

    private func handleAction(_ action: JourneyResultsAction) {
        switch action {
        case .initialFetch:
            guard !hasFetchedInitialData else { return }
            Task { await fetchData() }
        case .refresh:
            Task { await fetchData() }
        case .earlierJourneys:
            break
        case .laterJourneys:
            break
        }
    }
    
    private func fetchData() async {
        let pageID = "initial"
        pages = [JourneyResultsPage(id: pageID, loadingState: .loading, cellItems: [])]
        do {
            let results = try await resolveLocationCoordinatesAndFetchResults()
            pages = [makePage(id: pageID, with: results)]
            hasFetchedInitialData = true
        } catch HTTPError.statusCode(404, _) {
            pages = [JourneyResultsPage(id: pageID, loadingState: .loaded, cellItems: [])]
        } catch {
            pages = [JourneyResultsPage(id: pageID, loadingState: .failure(errorMessage: error.toUIErrorMessage()), cellItems: [])]
        }

        if let savedJourney = form.toNewSavedJourney() {
            userPreferences.saveRecentJourney(savedJourney)
        } else {
            assertionFailure("Failed to create a saved journey - results will be shown but not saved.")
        }
    }
    
    private func resolveLocationCoordinatesAndFetchResults() async throws -> JourneyResults {
        form = try await localSearchCompleter.resolveLocationCoordinates(forForm: form)
        return try await fetchJourneyResults()
    }
    
    private func fetchJourneyResults() async throws -> JourneyResults {
        let requestParams = try form.toJourneyRequestParams(withModeIDs: userPreferences.journeyPlannerModeIDs)
        return try await transportAPI.fetchJourneyResults(for: requestParams).decodedModel

    }
    
    private func makePage(id: String, with results: JourneyResults) -> JourneyResultsPage {
        let cellItems = (results.journeys ?? [])
            .sanitizedAndSortedByArrivalTime(forModeIDs: modeIDS)
            .enumerated()
            .map { index, journey in
                JourneyResultsCellItem(journey: journey,
                                       journeyDiagramID: "\(id)-\(index)",
                                       isExpanded: false)
            }
        return JourneyResultsPage(id: id, loadingState: .loaded, cellItems: cellItems)
    }
}

private extension LocalSearchCompleter {

    func resolveLocationCoordinates(forForm form: JourneyPlannerForm) async throws -> JourneyPlannerForm {

        async let resolveFrom = resolveLocationCoordinate(for: form.from)
        async let resolveTo = resolveLocationCoordinate(for: form.to)
        async let resolveVia = resolveLocationCoordinate(for: form.via)
        
        let (resolvedFromValue, resolvedToValue, resolvedViaValue) = try await (resolveFrom, resolveTo, resolveVia)
        
        var updatedForm = form
        if let resolvedFromValue {
            updatedForm.from = resolvedFromValue
        }
        if let resolvedToValue {
            updatedForm.to = resolvedToValue
        }
        if let resolvedViaValue {
            updatedForm.via = resolvedViaValue
        }
        
        return updatedForm
    }
    
    private func resolveLocationCoordinate(for pickerValue: JourneyLocationPicker.Value?) async throws -> JourneyLocationPicker.Value? {
        guard let pickerValue else {
            return nil
        }

        switch pickerValue {
        case .station, .nationalRail:
            return pickerValue
        case .namedLocation(let value):
            guard !value.isResolved else {
                return pickerValue
            }
            
            if value.isCurrentLocation {
                assertionFailure("Current location should already be resolved")
            }
            
            guard let locationName = value.name else {
                throw JourneyPlannerError.coordinateUnknown
            }
            let resolvedCoordinate = try await locationCoordinate(for: locationName)
            return .namedLocation(.init(name: locationName,
                                        coordinate: resolvedCoordinate,
                                        isCurrentLocation: value.isCurrentLocation))
        }
    }
}
