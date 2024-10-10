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
    
    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: .standard)
    private var userPreferences: UserPreferences = .default

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
        .navigationTitle(Text(.journeyResultsNavigationTitle))
        .task {
            if !hasFetchedData {
                await fetchData()
            }
        }
    }
    
    private func fetchData() async {
        do {
            loadingState = .loading
            let itinerary = try await resolveLocationCoordinatesAndFetchItinerary()
            makeCellItems(for: itinerary)
            loadingState = .loaded
            hasFetchedData = true
        } catch HTTPError.statusCode(404, _) {
            cellItems = []
            loadingState = .loaded
        } catch {
            loadingState = .failure(errorMessage: error.toUIErrorMessage())
        }
        
        if let savedJourney = form.toNewSavedJourney() {
            userPreferences.saveRecentJourney(savedJourney)
        } else {
            assertionFailure("Failed to create a saved journey - results will be shown but not saved.")
        }
    }
    
    private func resolveLocationCoordinatesAndFetchItinerary() async throws -> JourneyItinerary {
        form = try await localSearchCompleter.resolveLocationCoordinates(forForm: form)
        return try await fetchItinerary()
    }
    
    private func fetchItinerary() async throws -> JourneyItinerary {
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
