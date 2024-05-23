import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyResultsScreen: View {
    
    @State private var loadingState: LoadingState = .loaded
    @State private var cellItems: [JourneyResultsCellItem] = []
    @State private var hasFetchedData = false
    
    @Environment(\.transportAPI) var transportAPI
    @Environment(LocationDataStore.self) var location
    @Environment(StationsDataStore.self) var stations
    @Environment(LocalSearchCompleter.self) var localSearchCompleter
    @Environment(UserPreferencesDataStore.self) var userPreferences

    @Binding var form: JourneyPlannerForm
    
    @Namespace private var animationNamespace
    
    private var modeIDS: Set<ModeID> { userPreferences.journeyPlannerModeIDs }
    
    var body: some View {
        JourneyResultsView(
            loadingState: loadingState,
            cellItems: $cellItems,
            fromLocation: $form.from,
            toLocation: $form.to,
            viaLocation: form.via,
            timeoption: form.timeSelection,
            onRefresh: {
                Task { await fetchData() }
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("journey.results.navigation.title")
        .task {
            if !hasFetchedData {
                await fetchData()
            }
        }
    }
    
    private func fetchData() async {
        do {
            loadingState = .loading
            let itinerary = try await fetchItineraryWithResolvedLocations()
            makeCellItems(for: itinerary)
            loadingState = .loaded
            hasFetchedData = true
        } catch TransportAPIError.httpStatusCode(404, _) {
            cellItems = []
            loadingState = .loaded
        } catch {
            loadingState = .failure(errorMessage: error.toUIErrorMessage())
        }
        
        if let savedJourney = form.toNewSavedJourney() {
            userPreferences.insertOrReplace(journey: savedJourney)
        } else {
            assertionFailure("Failed to create a saved journey - results will be shown but not saved.")
        }
    }
    
    private func fetchItineraryWithResolvedLocations() async throws -> JourneyItinerary {
        form = try await form.resolvingLocations(
            findLocationCoordinate: localSearchCompleter.locationCoordinate(for:)
        )
        let requestParams = try form.toJourneyRequestParams(withModeIDs: userPreferences.journeyPlannerModeIDs)
        return try await transportAPI.fetchJourneyItinerary(for: requestParams).decodedModel
    }
    
    private func makeCellItems(for itinerary: JourneyItinerary) {
        cellItems = (itinerary.journeys ?? [])
            .sanitizedAndSortedByArrivalTime(forModeIDs: modeIDS)
            .enumerated()
            .map { index, journey in
                JourneyResultsCellItem(journey: journey,
                                       journeyDiagramID: String(index),
                                       isExpanded: false)
            }
    }
}
