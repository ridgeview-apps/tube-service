import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyResultsScreen: View {
    
    @State private var pages: [JourneyResultsPage] = []
    @State private var hasFetchedInitialData = false
    @State private var earlierTimeAdjustment: JourneyTimeAdjustment?
    @State private var laterTimeAdjustment: JourneyTimeAdjustment?
    @State private var pageCounter = 0
    
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
            Task { await fetchInitialData() }
        case .refresh:
            Task { await fetchInitialData() }
        case .earlierJourneys:
            guard let earlierTimeAdjustment else { return }
            Task { await fetchAdjacentPage(action: .earlierJourneys, timeAdjustment: earlierTimeAdjustment) }
        case .laterJourneys:
            guard let laterTimeAdjustment else { return }
            Task { await fetchAdjacentPage(action: .laterJourneys, timeAdjustment: laterTimeAdjustment) }
        }
    }

    private func fetchInitialData() async {
        let pageID = "initial"
        pages = [JourneyResultsPage(id: pageID, loadingState: .loading, cellItems: [])]
        earlierTimeAdjustment = nil
        laterTimeAdjustment = nil
        pageCounter = 0

        do {
            form = try await localSearchCompleter.resolveLocationCoordinates(forForm: form)
        } catch {
            pages = [JourneyResultsPage(id: pageID, loadingState: .failure(errorMessage: error.toUIErrorMessage()), cellItems: [])]
            saveRecentJourney()
            return
        }

        if await fetchAndUpdatePage(id: pageID, action: .initialFetch) {
            hasFetchedInitialData = true
        }
        saveRecentJourney()
    }

    private func fetchAdjacentPage(action: JourneyResultsAction, timeAdjustment: JourneyTimeAdjustment) async {
        pageCounter += 1
        let isEarlier = action == .earlierJourneys
        let pageID = "\(isEarlier ? "earlier" : "later")-\(pageCounter)"
        let loadingPage = JourneyResultsPage(id: pageID, loadingState: .loading, cellItems: [])

        if isEarlier {
            pages.insert(loadingPage, at: 0)
        } else {
            pages.append(loadingPage)
        }

        await fetchAndUpdatePage(id: pageID, action: action, timeAdjustment: timeAdjustment)
    }

    @discardableResult
    private func fetchAndUpdatePage(
        id: String,
        action: JourneyResultsAction,
        timeAdjustment: JourneyTimeAdjustment? = nil
    ) async -> Bool {
        do {
            let results = try await fetchJourneyResults(withTimeAdjustment: timeAdjustment)
            let page = makePage(id: id, with: results)
            if page.cellItems.isEmpty {
                pages.removeAll { $0.id == id }
            } else if let index = pages.firstIndex(where: { $0.id == id }) {
                pages[index] = page
            }
            updateTimeAdjustments(from: results, for: action)
            return true
        } catch HTTPError.statusCode(404, _) {
            pages.removeAll { $0.id == id }
            return true
        } catch {
            if let index = pages.firstIndex(where: { $0.id == id }) {
                pages[index].loadingState = .failure(errorMessage: error.toUIErrorMessage())
            }
            return false
        }
    }

    private func saveRecentJourney() {
        if let savedJourney = form.toNewSavedJourney() {
            userPreferences.saveRecentJourney(savedJourney)
        } else {
            assertionFailure("Failed to create a saved journey - results will be shown but not saved.")
        }
    }

    private func updateTimeAdjustments(from results: JourneyResults, for action: JourneyResultsAction) {
        let adjustments = results.searchCriteria?.timeAdjustments
        switch action {
        case .initialFetch, .refresh:
            earlierTimeAdjustment = adjustments?.earlier
            laterTimeAdjustment = adjustments?.later
        case .earlierJourneys:
            earlierTimeAdjustment = adjustments?.earlier
        case .laterJourneys:
            laterTimeAdjustment = adjustments?.later
        }
    }

    private func fetchJourneyResults(withTimeAdjustment timeAdjustment: JourneyTimeAdjustment? = nil) async throws -> JourneyResults {
        var requestParams = try form.toJourneyRequestParams(withModeIDs: userPreferences.journeyPlannerModeIDs)
        if let timeAdjustment, let timeOption = timeAdjustment.toTimeOptionParam() {
            requestParams = JourneyRequestParams(
                from: requestParams.from,
                to: requestParams.to,
                via: requestParams.via,
                modeIDs: requestParams.modeIDs,
                timeOption: timeOption,
                routeBetweenEntrances: requestParams.routeBetweenEntrances
            )
        }
        return try await transportAPI.fetchJourneyResults(for: requestParams).decodedModel
    }
    
    private func makePage(id: String, with results: JourneyResults) -> JourneyResultsPage {
        let existingTimePairs: Set<JourneyTimePair> = Set(
            pages.flatMap { $0.cellItems.map(\.journey) }
                .compactMap(JourneyTimePair.init)
        )
        let cellItems = (results.journeys ?? [])
            .sanitizedAndSortedByArrivalTime(forModeIDs: modeIDS)
            .filter { journey in
                guard let timePair = JourneyTimePair(journey) else { return true }
                return !existingTimePairs.contains(timePair)
            }
            .enumerated()
            .map { index, journey in
                JourneyResultsCellItem(journey: journey,
                                       journeyDiagramID: "\(id)-\(index)",
                                       isExpanded: false)
            }
        return JourneyResultsPage(id: id, loadingState: .loaded, cellItems: cellItems)
    }
}

private struct JourneyTimePair: Hashable {
    let start: Date
    let arrival: Date

    init?(_ journey: Journey) {
        guard let start = journey.startDateTime,
              let arrival = journey.arrivalDateTime else { return nil }
        self.start = start
        self.arrival = arrival
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
