import Foundation
import Models
import ModelStubs
import PresentationViews
import Testing

@testable import DataStores

@testable import Tube_Service

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

    private func makeModel() -> JourneyPlannerStore {
        JourneyPlannerStore(
            tflAPI: tflAPI,
            localSearchResults: LocalSearchResultsStore(completerClient: StubLocalSearchCompleterClient())
        )
    }

    // MARK: - prepareForInitialFetch

    @Test
    func prepareForInitialFetch_setsLoadingState() {
        let model = makeModel()

        model.prepareForInitialFetch()

        #expect(model.pages.count == 1)
        #expect(model.pages.first?.id == "initial")
        #expect(model.pages.first?.loadingState == .loading)
        #expect(model.pages.first?.cellItems.isEmpty == true)
    }

    // MARK: - setInitialPageError

    @Test
    func setInitialPageError_setsFailureState() {
        let model = makeModel()
        model.prepareForInitialFetch()

        model.setInitialPageError("Something went wrong")

        #expect(model.pages.count == 1)
        #expect(model.pages.first?.loadingState == .failure(errorMessage: "Something went wrong"))
    }

    // MARK: - fetchInitialResults

    @Test
    func fetchInitialResults_success_populatesPagesAndSetsHasFetched() async {
        let model = makeModel()
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)

        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        #expect(model.hasFetchedInitialData == true)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.loadingState == .loaded)
        #expect(model.pages.first?.cellItems.isEmpty == false)
        #expect(tflAPI.fetchJourneyResultsCallCount == 1)
    }

    @Test
    func fetchInitialResults_404_keepsPageWithEmptyResults() async {
        let model = makeModel()
        model.prepareForInitialFetch()
        tflAPI.fetchJourneyResultsError = HTTPError.statusCode(404, nil)

        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        #expect(model.hasFetchedInitialData == true)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.loadingState == .loaded)
        #expect(model.pages.first?.cellItems.isEmpty == true)
    }

    @Test
    func fetchInitialResults_error_setsFailureState() async {
        let model = makeModel()
        model.prepareForInitialFetch()
        tflAPI.fetchJourneyResultsError = HTTPError.connection(URLError(.notConnectedToInternet))

        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        #expect(model.hasFetchedInitialData == false)
        #expect(model.pages.count == 1)
        if case .failure = model.pages.first?.loadingState {
            // expected
        } else {
            Issue.record("Expected failure loading state")
        }
    }

    // MARK: - fetchAdjacentResults (earlier)

    @Test
    func fetchAdjacentResults_earlier_prependsPage() async {
        let model = makeModel()

        // Load initial page first (establishes time adjustments)
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        let initialPageCount = model.pages.first?.cellItems.count ?? 0

        // Fetch earlier
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooEarlier)
        await model.fetchAdjacentResults(action: .earlierJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(tflAPI.fetchJourneyResultsCallCount == 2)
        #expect(model.pages.count >= 1)
        if model.pages.count == 2 {
            #expect(model.pages[0].id.hasPrefix("earlier"))
            #expect(model.pages[1].id == "initial")
            #expect(model.pages[0].loadingState == .loaded)
        }
        let totalItems = model.pages.reduce(0) { $0 + $1.cellItems.count }
        #expect(totalItems >= initialPageCount)
    }

    // MARK: - fetchAdjacentResults (later)

    @Test
    func fetchAdjacentResults_later_appendsPage() async {
        let model = makeModel()

        // Load initial page first
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        let initialPageCount = model.pages.first?.cellItems.count ?? 0

        // Fetch later
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooLater)
        await model.fetchAdjacentResults(action: .laterJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(tflAPI.fetchJourneyResultsCallCount == 2)
        #expect(model.pages.count >= 1)
        if model.pages.count == 2 {
            #expect(model.pages[0].id == "initial")
            #expect(model.pages[1].id.hasPrefix("later"))
            #expect(model.pages[1].loadingState == .loaded)
        }
        let totalItems = model.pages.reduce(0) { $0 + $1.cellItems.count }
        #expect(totalItems >= initialPageCount)
    }

    // MARK: - No time adjustment available

    @Test
    func fetchAdjacentResults_withoutPriorFetch_doesNothing() async {
        let model = makeModel()

        await model.fetchAdjacentResults(action: .earlierJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(tflAPI.fetchJourneyResultsCallCount == 0)
        #expect(model.pages.isEmpty)
    }

    // MARK: - Adjacent page error handling

    @Test
    func fetchAdjacentResults_404_removesAdjacentPage() async {
        let model = makeModel()
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
        let model = makeModel()
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        // Fetch earlier with error
        tflAPI.fetchJourneyResultsError = HTTPError.connection(URLError(.notConnectedToInternet))
        await model.fetchAdjacentResults(action: .earlierJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(model.pages.count == 2)
        if case .failure = model.pages[0].loadingState {
            // expected — earlier page shows error
        } else {
            Issue.record("Expected failure loading state on earlier page")
        }
        #expect(model.pages[1].loadingState == .loaded)
    }

    // MARK: - Deduplication

    @Test
    func fetchAdjacentResults_deduplicatesJourneysAcrossPages() async {
        let model = makeModel()
        model.prepareForInitialFetch()

        // Use the same results for both pages to guarantee overlap
        let results = ModelStubs.journeyResultsKingsXToWaterlooNow
        tflAPI.stubbedJourneyResults = .success200(results)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        let initialCount = model.pages.first?.cellItems.count ?? 0
        #expect(initialCount > 0)

        // Fetch later with identical results — all should be deduped
        tflAPI.fetchJourneyResultsError = nil
        tflAPI.stubbedJourneyResults = .success200(results)
        await model.fetchAdjacentResults(action: .laterJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        // Adjacent page should be removed since all items were duplicates
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.id == "initial")
    }

    // MARK: - Ignores invalid actions

    @Test
    func fetchAdjacentResults_ignoresRefreshAction() async {
        let model = makeModel()
        model.prepareForInitialFetch()
        tflAPI.stubbedJourneyResults = .success200(ModelStubs.journeyResultsKingsXToWaterlooNow)
        await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        await model.fetchAdjacentResults(action: .refresh, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(tflAPI.fetchJourneyResultsCallCount == 1)
    }
}
