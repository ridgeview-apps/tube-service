import Foundation
import Models
import Observation

@MainActor
@Observable
public final class JourneyPlannerStore {

    private enum FetchContext {
        case initial
        case adjacent(JourneyPaginationAction)
    }

    private enum PageID: CustomStringConvertible {
        case initial
        case earlier(Int)
        case later(Int)

        var description: String {
            switch self {
            case .initial: "initial"
            case .earlier(let pageCounter): "earlier-\(pageCounter)"
            case .later(let pageCounter): "later-\(pageCounter)"
            }
        }
    }

    private struct JourneyTimePair: Hashable {
        let start: Date
        let arrival: Date

        init?(_ journey: Journey) {
            guard let start = journey.startDateTime,
                let arrival = journey.arrivalDateTime
            else { return nil }
            self.start = start
            self.arrival = arrival
        }
    }

    // MARK: - State

    public var form: JourneyPlannerForm = .empty
    public var pages: [JourneyPage] = []
    public private(set) var hasFetchedInitialData = false

    private let tflAPI: TflAPIClientType
    private let localSearchResults: LocalSearchResultsStore

    private var earlierTimeAdjustment: JourneyTimeAdjustment?
    private var laterTimeAdjustment: JourneyTimeAdjustment?
    private var pageCounter = 0

    public init(tflAPI: TflAPIClientType, localSearchResults: LocalSearchResultsStore) {
        self.tflAPI = tflAPI
        self.localSearchResults = localSearchResults
    }

    // MARK: - High-level (screen-facing)

    public func resetForNewJourney() {
        form.adjustCurrentTimeIfNeeded()
        prepareForInitialFetch()
    }

    public func resetTimeSelectionIfNeeded() {
        if form.timeSelection.date < .now {
            form.timeSelection = .leaveNow()
        }
    }

    public func updateCurrentLocationInfo(name: LocationName?, coordinate: LocationCoordinate?, updatesAllowed: Bool) {
        form.updateCurrentLocationInfo(name: name, coordinate: coordinate, updatesAllowed: updatesAllowed)
    }

    public func fetchInitialData(modeIDs: Set<ModeID>) async {
        prepareForInitialFetch()
        do {
            form = try await localSearchResults.resolveLocationCoordinates(forForm: form)
            let requestParams = try form.toJourneyRequestParams(withModeIDs: modeIDs)
            await fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        } catch {
            setInitialPageError(error)
        }
    }

    public func fetchAdjacentData(action: JourneyPaginationAction, modeIDs: Set<ModeID>) async {
        guard let requestParams = try? form.toJourneyRequestParams(withModeIDs: modeIDs) else { return }
        await fetchAdjacentResults(action: action, baseRequestParams: requestParams, modeIDs: modeIDs)
    }

    // MARK: - Lower-level (also used by unit tests)

    public func prepareForInitialFetch() {
        hasFetchedInitialData = false
        pages = [.loading(id: PageID.initial.description)]
        earlierTimeAdjustment = nil
        laterTimeAdjustment = nil
        pageCounter = 0
    }

    public func setInitialPageError(_ error: any Error) {
        if let index = pageIndex(for: .initial) {
            pages[index] = .failed(id: PageID.initial.description, error: error)
        }
    }

    public func fetchInitialResults(requestParams: JourneyRequestParams, modeIDs: Set<ModeID>) async {
        if await fetchAndUpdatePage(pageID: .initial, context: .initial, requestParams: requestParams, modeIDs: modeIDs) {
            hasFetchedInitialData = true
        }
    }

    public func fetchAdjacentResults(action: JourneyPaginationAction, baseRequestParams: JourneyRequestParams, modeIDs: Set<ModeID>) async {
        let timeAdjustment: JourneyTimeAdjustment
        let pageID: PageID

        switch action {
        case .earlierJourneys:
            guard let earlier = earlierTimeAdjustment else { return }
            timeAdjustment = earlier
            pageCounter += 1
            pageID = .earlier(pageCounter)
        case .laterJourneys:
            guard let later = laterTimeAdjustment else { return }
            timeAdjustment = later
            pageCounter += 1
            pageID = .later(pageCounter)
        }

        if case .earlier = pageID {
            pages.insert(.loading(id: pageID.description), at: 0)
        } else {
            pages.append(.loading(id: pageID.description))
        }

        let requestParams = Self.applyTimeAdjustment(timeAdjustment, to: baseRequestParams)
        await fetchAndUpdatePage(pageID: pageID, context: .adjacent(action), requestParams: requestParams, modeIDs: modeIDs)
    }

    // MARK: - Private implementation

    private func pageIndex(for pageID: PageID) -> Int? {
        pages.firstIndex(where: { $0.id == pageID.description })
    }

    @discardableResult
    private func fetchAndUpdatePage(
        pageID: PageID,
        context: FetchContext,
        requestParams: JourneyRequestParams,
        modeIDs: Set<ModeID>
    ) async -> Bool {
        do {
            let results: JourneyResults = try await tflAPI.fetchJourneyResults(for: requestParams).decodedModel
            let page = makePage(pageID: pageID, with: results, modeIDs: modeIDs)
            if page.cellItems?.isEmpty == true {
                clearPage(pageID: pageID)
            } else if let index = pageIndex(for: pageID) {
                pages[index] = page
            }
            updateTimeAdjustments(from: results, for: context)
            return true
        } catch HTTPError.statusCode(404, _) {
            clearPage(pageID: pageID)
            return true
        } catch {
            if let index = pageIndex(for: pageID) {
                pages[index] = .failed(id: pageID.description, error: error)
            }
            return false
        }
    }

    private func clearPage(pageID: PageID) {
        guard let index = pageIndex(for: pageID) else { return }
        if case .initial = pageID {
            pages[index] = .loaded(id: pageID.description, cellItems: [])
        } else {
            pages.remove(at: index)
        }
    }

    private func updateTimeAdjustments(from results: JourneyResults, for context: FetchContext) {
        let adjustments = results.searchCriteria?.timeAdjustments
        switch context {
        case .initial:
            earlierTimeAdjustment = adjustments?.earlier
            laterTimeAdjustment = adjustments?.later
        case .adjacent(let action):
            switch action {
            case .earlierJourneys:
                earlierTimeAdjustment = adjustments?.earlier
            case .laterJourneys:
                laterTimeAdjustment = adjustments?.later
            }
        }
    }

    private func makePage(pageID: PageID, with results: JourneyResults, modeIDs: Set<ModeID>) -> JourneyPage {
        let existingTimePairs: Set<JourneyTimePair> = Set(
            pages.compactMap { page -> [Journey]? in
                if case .loaded(_, let items) = page { return items.map(\.journey) }
                return nil
            }
            .flatMap { $0 }
            .compactMap(JourneyTimePair.init)
        )
        let cellItems = (results.journeys ?? [])
            .sanitizedAndSortedByArrivalTime(forModeIDs: modeIDs)
            .filter { journey in
                guard let timePair = JourneyTimePair(journey) else { return true }
                return !existingTimePairs.contains(timePair)
            }
            .enumerated()
            .map { index, journey in
                JourneyResultsCellItem(
                    journey: journey,
                    journeyDiagramID: "\(pageID)-\(index)"
                )
            }
        return .loaded(id: pageID.description, cellItems: cellItems)
    }

    private static func applyTimeAdjustment(_ timeAdjustment: JourneyTimeAdjustment, to params: JourneyRequestParams) -> JourneyRequestParams {
        guard let timeOption = timeAdjustment.toTimeOptionParam() else { return params }
        return JourneyRequestParams(
            from: params.from,
            to: params.to,
            via: params.via,
            modeIDs: params.modeIDs,
            timeOption: timeOption,
            routeBetweenEntrances: params.routeBetweenEntrances
        )
    }
}
