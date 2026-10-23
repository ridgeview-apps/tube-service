import Foundation
import Models
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

    private func makeStation(id: String, icsCode: String, name: String) -> Station {
        Station(
            id: id,
            icsCode: icsCode,
            name: name,
            location: LocationCoordinate(lat: 51.5, lon: -0.1),
            lineGroups: []
        )
    }

    // MARK: - resetForNewJourney

    @Test
    func resetForNewJourney_resetsHasLoadedJourneys() async {
        let model = makeStore()
        model.prepareForInitialLoad()
        await model.loadInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        #expect(model.hasLoadedJourneys == true)

        model.resetForNewJourney()

        #expect(model.hasLoadedJourneys == false)
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

    // MARK: - loadJourneys (high-level)

    @Test
    func loadJourneys_success_resolvesAndPopulatesPages() async {
        let model = makeStore()
        model.form.from = .station(makeStation(id: "940GZZLUAGL", icsCode: "1000004", name: "Angel"))
        model.form.to = .station(makeStation(id: "940GZZLUKSX", icsCode: "1000129", name: "King's Cross"))

        await model.loadJourneys(modeIDs: modeIDs)

        #expect(model.hasLoadedJourneys == true)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isLoaded == true)
        #expect(model.pages.first?.cellItems?.isEmpty == false)
        #expect(tflAPI.fetchJourneyResultsCallCount == 1)
    }

    @Test
    func loadJourneys_networkError_setsFailureState() async {
        let model = makeStore()
        model.form.from = .station(makeStation(id: "940GZZLUAGL", icsCode: "1000004", name: "Angel"))
        model.form.to = .station(makeStation(id: "940GZZLUKSX", icsCode: "1000129", name: "King's Cross"))
        tflAPI.fetchJourneyResultsError = HTTPError.connection(URLError(.notConnectedToInternet))

        await model.loadJourneys(modeIDs: modeIDs)

        #expect(model.hasLoadedJourneys == false)
        #expect(model.pages.first?.isFailed == true)
    }

    // MARK: - prepareForInitialLoad

    @Test
    func prepareForInitialLoad_setsLoadingState() {
        let model = makeStore()

        model.prepareForInitialLoad()

        #expect(model.pages.count == 1)
        #expect(model.pages.first?.id == "initial")
        #expect(model.pages.first?.isLoading == true)
        #expect(model.pages.first?.cellItems == nil)
    }

    @Test
    func prepareForInitialLoad_resetsHasLoadedJourneys() async {
        let model = makeStore()
        model.prepareForInitialLoad()
        await model.loadInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        #expect(model.hasLoadedJourneys == true)

        model.prepareForInitialLoad()

        #expect(model.hasLoadedJourneys == false)
    }

    // MARK: - setInitialPageError

    @Test
    func setInitialPageError_setsFailureState() {
        let model = makeStore()
        model.prepareForInitialLoad()

        model.setInitialPageError(URLError(.notConnectedToInternet))

        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isFailed == true)
    }

    // MARK: - loadInitialResults

    @Test
    func loadInitialResults_success_populatesPagesAndSetsHasLoadedJourneys() async {
        let model = makeStore()
        model.prepareForInitialLoad()

        await model.loadInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        #expect(model.hasLoadedJourneys == true)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isLoaded == true)
        #expect(model.pages.first?.cellItems?.isEmpty == false)
        #expect(tflAPI.fetchJourneyResultsCallCount == 1)
    }

    @Test
    func loadInitialResults_404_keepsPageWithEmptyResults() async {
        let model = makeStore()
        model.prepareForInitialLoad()
        tflAPI.fetchJourneyResultsError = HTTPError.statusCode(404, nil)

        await model.loadInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        #expect(model.hasLoadedJourneys == true)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isLoaded == true)
        #expect(model.pages.first?.cellItems?.isEmpty == true)
    }

    @Test
    func loadInitialResults_error_setsFailureState() async {
        let model = makeStore()
        model.prepareForInitialLoad()
        tflAPI.fetchJourneyResultsError = HTTPError.connection(URLError(.notConnectedToInternet))

        await model.loadInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        #expect(model.hasLoadedJourneys == false)
        #expect(model.pages.count == 1)
        #expect(model.pages.first?.isFailed == true)
    }

    // MARK: - loadAdjacentResults (no prior load)

    @Test
    func loadAdjacentResults_withoutPriorLoad_doesNothing() async {
        let model = makeStore()

        await model.loadAdjacentResults(action: .earlierJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(tflAPI.fetchJourneyResultsCallCount == 0)
        #expect(model.pages.isEmpty)
    }

    // MARK: - loadAdjacentResults error handling

    @Test
    func loadAdjacentResults_404_removesAdjacentPage() async {
        let model = makeStore()
        model.prepareForInitialLoad()
        await model.loadInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        tflAPI.fetchJourneyResultsError = HTTPError.statusCode(404, nil)
        await model.loadAdjacentResults(action: .laterJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(model.pages.count == 1)
        #expect(model.pages.first?.id == "initial")
    }

    @Test
    func loadAdjacentResults_error_setsFailureOnAdjacentPage() async {
        let model = makeStore()
        model.prepareForInitialLoad()
        await model.loadInitialResults(requestParams: requestParams, modeIDs: modeIDs)

        tflAPI.fetchJourneyResultsError = HTTPError.connection(URLError(.notConnectedToInternet))
        await model.loadAdjacentResults(action: .earlierJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(model.pages.count == 2)
        #expect(model.pages[0].isFailed == true)
        #expect(model.pages[1].isLoaded == true)
    }

    // MARK: - Deduplication

    @Test
    func loadAdjacentResults_deduplicatesJourneysAcrossPages() async {
        let model = makeStore()
        model.prepareForInitialLoad()
        await model.loadInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        let initialCount = model.pages.first?.cellItems?.count ?? 0
        #expect(initialCount > 0)

        // Load later journeys with identical results — all should be deduped, adjacent page removed
        await model.loadAdjacentResults(action: .laterJourneys, baseRequestParams: requestParams, modeIDs: modeIDs)

        #expect(model.pages.count == 1)
        #expect(model.pages.first?.id == "initial")
    }
}
