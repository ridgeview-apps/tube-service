import DataStores
import Models
import PresentationViews
import SwiftUI

struct JourneyResultsScreen: View {
    
    @State private var loadingState: LoadingState = .loaded
    @State private var journeyItinerary: JourneyItinerary?
    
    @Environment(\.transportAPI) var transportAPI
    @EnvironmentObject var location: LocationDataStore
    @EnvironmentObject var stations: StationsDataStore
    @EnvironmentObject var localSearchCompleter: LocalSearchCompleter
    @EnvironmentObject var userPreferences: UserPreferencesDataStore

    @Binding var form: JourneyPlannerForm
    
    @Namespace private var animationNamespace
    
    private var modeIDS: Set<ModeID> { userPreferences.journeyPlannerModeIDs }
    private var sortedJourneys: [Journey] {
        journeyItinerary?.journeys?.sanitizedAndSortedByArrivalTime(forModeIDs: modeIDS) ?? []
    }
    
    var body: some View {
        JourneyResultsView(
            loadingState: loadingState,
            journeys: sortedJourneys,
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
            await fetchData()
        }
    }
    
    private func fetchData() async {
        do {
            loadingState = .loading
            form = try await form.resolvingLocations(currentLocationName: location.currentLocationName,
                                                     currentLocationCoordinate: location.currentLocationCoordinate,
                                                     findLocationCoordinate: localSearchCompleter.locationCoordinate(for:))
            let requestParams = try form.toJourneyRequestParams(withModeIDs: userPreferences.journeyPlannerModeIDs)
            journeyItinerary = try await transportAPI.fetchJourneyItinerary(for: requestParams).decodedModel
            loadingState = .loaded
        } catch TransportAPIError.httpStatusCode(404, _) {
            journeyItinerary = nil
            loadingState = .loaded
        } catch {
            loadingState = .failure(errorMessage: error.toUIErrorMessage())
        }
        
        saveRecentJourney()
    }
    
    private func saveRecentJourney() {
        guard let recentJourney = form.toSavedJourney() else {
            assertionFailure("Unable to save recent journey for \(form)")
            return
        }
        userPreferences.save(recentJourney: recentJourney)
    }
}
