import Foundation
import Models
import ModelStubs
import Testing

@testable import DataStores

@MainActor
struct JourneyPlannerStoreTests {

    private let tflAPI = StubTflAPIClient()
    private let modeIDs: Set<ModeID> = ModeID.journeyPlannerModes
    private let requestParams = JourneyRequestParams(
        from: .icsCode("HUBKGX"),
        to: .icsCode("1000254"),
        via: nil,
        modeIDs: ModeID.journeyPlannerModes,
        timeOption: nil
    )

    private func makeStore() -> JourneyPlannerStore {
        JourneyPlannerStore(
            tflAPI: tflAPI,
            localSearchResults: LocalSearchResultsStore(completerClient: StubLocalSearchCompleterClient())
        )
    }

    // MARK: - resetForNewJourney

    @Test
    func resetForNewJourney_resetsHasFetchedInitialData() async {
        let model = makeStore()
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        #expect(model.hasFetchedInitialData == true)

        model.resetForNewJourney()

        #expect(model.hasFetchedInitialData == false)
    }

    // MARK: - resetTimeSelectionIfNeeded

    @Test
    func resetTimeSelectionIfNeeded_withPastDate_resetsToLeaveNow() {
        let model = makeStore()
        model.form.timeSelection = JourneyTimeSelection.leaveAt(Date(timeIntervalSince1970: 0))

        model.resetTimeSelectionIfNeeded()

        #expect(model.form.timeSelection.option == .leaveNow)
    }

    @Test
    func resetTimeSelectionIfNeeded_withFutureDate_doesNotReset() {
        let model = makeStore()
        model.form.timeSelection = JourneyTimeSelection.leaveAt(.distantFuture)

        model.resetTimeSelectionIfNeeded()

        #expect(model.form.timeSelection.option == .leaveAt)
    }

    // MARK: - fetchInitialData (high-level)

    @Test
    func fetchInitialData_success_resolvesAndPopulatesPages() async {
        let model = makeStore()
        model.form.from = .station(ModelStubs.angelStation)
        model.form.to = .station(ModelStubs.kingsCrossStation)
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)

        await model.fetchInitialData(modeIDs: modeIDs)

        #expect(model.hasFetchedInitialData == true)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isLoaded == true)
        #expect(model.pages.first?.cellItems?.isEmpty == false)
        #expect(tflAPI.fetchJourneyResultsCallCount == 1)
    }

    @Test
    func fetchInitialData_networkError_setsFailureState() async {
        let model = makeStore()
        model.form.from = .station(ModelStubs.angelStation)
        model.form.to = .station(ModelStubs.kingsCrossStation)
        tflAPI.fetchJourneyResultsError = HTTPError.connection(URLError(.notConnectedToInternet))

        await model.fetchInitialData(modeIDs: modeIDs)

        #expect(model.hasFetchedInitialData == false)
        #expect(model.pages.first?.isFailed == true)
    }

    // MARK: - prepareForInitialFetch

    @Test
    func prepareForInitialFetch_setsLoadingState() {
        let model = makeStore()

        model.prepareForInitialFetch()

        #expect(model.pages.count == 1)
        #expect(model.pages.first?.id == "initial")
        #expect(model.pages.first?.isLoading == true)
        #expect(model.pages.first?.cellItems == nil)
    }

    @Test
    func prepareForInitialFetch_resetsHasFetchedInitialData() async {
        let model = makeStore()
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        #expect(model.hasFetchedInitialData == true)

        model.prepareForInitialFetch()

        #expect(model.hasFetchedInitialData == false)
    }

    // MARK: - setInitialPageError

    @Test
    func setInitialPageError_setsFailureState() {
        let model = makeStore()
        model.prepareForInitialFetch()

        model.setInitialPageError(URLError(.notConnectedToInternet))

        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isFailed == true)
    }

    // MARK: - fetchInitialResults

    @Test
    func fetchInitialResults_success_populatesPagesAndSetsHasFetched() async {
        let model = makeStore()
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)

        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        #expect(model.hasFetchedInitialData == true)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isLoaded == true)
        #expect(model.pages.first?.cellItems?.isEmpty == false)
        #expect(tflAPI.fetchJourneyResultsCallCount == 1)
    }

    @Test
    func fetchInitialResults_404_keepsPageWithEmptyResults() async {
        let model = makeStore()
        model.prepareForInitialFetch()
        tflAPI.fetchJourneyResultsError = HTTPError.statusCode(404, nil)

        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        #expect(model.hasFetchedInitialData == true)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isLoaded == true)
        #expect(model.pages.first?.cellItems?.isEmpty == true)
    }

    @Test
    func fetchInitialResults_error_setsFailureState() async {
        let model = makeStore()
        model.prepareForInitialFetch()
        tflAPI.fetchJourneyResultsError = HTTPError.connection(URLError(.notConnectedToInternet))

        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        #expect(model.hasFetchedInitialData == false)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isFailed == true)
    }

    // MARK: - fetchAdjacentResults (earlier)

    @Test
    func fetchAdjacentResults_earlier_prependsPage() async {
        let model = makeStore()

        // Load initial page first (establishes time adjustments)
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        let initialPageCount = model.pages.first?.cellItems?.count ?? 0

        // Fetch earlier
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooEarlier)
        await model.fetchAdjacentResults(action: .earlierJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(tflAPI.fetchJourneyResultsCallCount == 2)
        #expect(model.pages.count >= 1)
        if model.pages.count == 2 {
            #expect(model.pages[0].id.hasPrefix("earlier"))
            #expect(model.pages[1].id == "initial")
            #expect(model.pages[0].isLoaded == true)
        }
        let totalItems = model.pages.reduce(0) { $0 + ($1.cellItems?.count ?? 0) }
        #expect(totalItems >= initialPageCount)
    }

    // MARK: - fetchAdjacentResults (later)

    @Test
    func fetchAdjacentResults_later_appendsPage() async {
        let model = makeStore()

        // Load initial page first
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        let initialPageCount = model.pages.first?.cellItems?.count ?? 0

        // Fetch later
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooLater)
        await model.fetchAdjacentResults(action: .laterJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(tflAPI.fetchJourneyResultsCallCount == 2)
        #expect(model.pages.count >= 1)
        if model.pages.count == 2 {
            #expect(model.pages[0].id == "initial")
            #expect(model.pages[1].id.hasPrefix("later"))
            #expect(model.pages[1].isLoaded == true)
        }
        let totalItems = model.pages.reduce(0) { $0 + ($1.cellItems?.count ?? 0) }
        #expect(totalItems >= initialPageCount)
    }

    // MARK: - No time adjustment available

    @Test
    func fetchAdjacentResults_withoutPriorFetch_doesNothing() async {
        let model = makeStore()

        await model.fetchAdjacentResults(action: .earlierJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(tflAPI.fetchJourneyResultsCallCount == 0)
        #expect(model.pages.isEmpty)
    }

    // MARK: - Adjacent page error handling

    @Test
    func fetchAdjacentResults_404_removesAdjacentPage() async {
        let model = makeStore()
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        // Fetch later with 404
        tflAPI.fetchJourneyResultsError = HTTPError.statusCode(404, nil)
        await model.fetchAdjacentResults(action: .laterJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(model.pages.count == 1)
        #expect(model.pages.first?.id == "initial")
    }

    @Test
    func fetchAdjacentResults_error_setsFailureOnAdjacentPage() async {
        let model = makeStore()
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        // Fetch earlier with error
        tflAPI.fetchJourneyResultsError = HTTPError.connection(URLError(.notConnectedToInternet))
        await model.fetchAdjacentResults(action: .earlierJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(model.pages.count == 2)
        #expect(model.pages[0].isFailed == true)
        #expect(model.pages[1].isLoaded == true)
    }

    // MARK: - Deduplication

    @Test
    func fetchAdjacentResults_deduplicatesJourneysAcrossPages() async {
        let model = makeStore()
        model.prepareForInitialFetch()

        // Use the same results for both pages to guarantee overlap
        let results = ModelStubs.journeyResultsKingsXToWaterlooNow
        tflAPI.stubbedJourneyResults = .success200(results)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        let initialCount = model.pages.first?.cellItems?.count ?? 0
        #expect(initialCount > 0)

        // Fetch later with identical results — all should be deduped
        tflAPI.fetchJourneyResultsError = nil
        tflAPI.stubbedJourneyResults = .success200(results)
        await model.fetchAdjacentResults(action: .laterJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        // Adjacent page should be removed since all items were duplicates
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.id == "initial")
    }
}
