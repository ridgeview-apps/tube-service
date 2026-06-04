import DataStores
import Foundation
import Models
import Observation
import PresentationViews

@Observable @MainActor
final class JourneyResultsModel {

    var pages: [JourneyResultsPage] = []
    private(set) var hasFetchedInitialData = false

    private var earlierTimeAdjustment: JourneyTimeAdjustment?
    private var laterTimeAdjustment: JourneyTimeAdjustment?
    private var pageCounter = 0

    private let transportAPI: TransportAPIClientType

    init(transportAPI: TransportAPIClientType) {
        self.transportAPI = transportAPI
    }

    // MARK: - Public

    func prepareForInitialFetch() {
        pages = [JourneyResultsPage(id: PageID.initial.description, loadingState: .loading, cellItems: [])]
        earlierTimeAdjustment = nil
        laterTimeAdjustment = nil
        pageCounter = 0
    }

    func setInitialPageError(_ message: String) {
        if let index = pageIndex(for: .initial) {
            pages[index].loadingState = .failure(errorMessage: message)
        }
    }

    func fetchInitialResults(requestParams: JourneyRequestParams, modeIDs: Set<ModeID>) async {
        if await fetchAndUpdatePage(pageID: .initial, action: .initialFetch, requestParams: requestParams, modeIDs: modeIDs) {
            hasFetchedInitialData = true
        }
    }

    func fetchAdjacentResults(action: JourneyResultsAction, baseRequestParams: JourneyRequestParams, modeIDs: Set<ModeID>) async {
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
        default:
            return
        }

        let loadingPage = JourneyResultsPage(id: pageID.description, loadingState: .loading, cellItems: [])

        if case .earlier = pageID {
            pages.insert(loadingPage, at: 0)
        } else {
            pages.append(loadingPage)
        }

        let requestParams = Self.applyTimeAdjustment(timeAdjustment, to: baseRequestParams)
        await fetchAndUpdatePage(pageID: pageID, action: action, requestParams: requestParams, modeIDs: modeIDs)
    }

    // MARK: - Private

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

    private func pageIndex(for pageID: PageID) -> Int? {
        pages.firstIndex(where: { $0.id == pageID.description })
    }

    @discardableResult
    private func fetchAndUpdatePage(
        pageID: PageID,
        action: JourneyResultsAction,
        requestParams: JourneyRequestParams,
        modeIDs: Set<ModeID>
    ) async -> Bool {
        do {
            let results: JourneyResults = try await transportAPI.fetchJourneyResults(for: requestParams).decodedModel
            let page = makePage(pageID: pageID, with: results, modeIDs: modeIDs)
            if page.cellItems.isEmpty {
                clearPage(pageID: pageID)
            } else if let index = pageIndex(for: pageID) {
                pages[index] = page
            }
            updateTimeAdjustments(from: results, for: action)
            return true
        } catch HTTPError.statusCode(404, _) {
            clearPage(pageID: pageID)
            return true
        } catch {
            if let index = pageIndex(for: pageID) {
                pages[index].loadingState = .failure(errorMessage: error.toUIErrorMessage())
            }
            return false
        }
    }

    private func clearPage(pageID: PageID) {
        guard let index = pageIndex(for: pageID) else { return }
        if case .initial = pageID {
            pages[index] = JourneyResultsPage(id: pageID.description, loadingState: .loaded, cellItems: [])
        } else {
            pages.remove(at: index)
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

    private func makePage(pageID: PageID, with results: JourneyResults, modeIDs: Set<ModeID>) -> JourneyResultsPage {
        let existingTimePairs: Set<JourneyTimePair> = Set(
            pages.flatMap { $0.cellItems.map(\.journey) }
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
                    journeyDiagramID: "\(pageID)-\(index)",
                    isExpanded: false
                )
            }
        return JourneyResultsPage(id: pageID.description, loadingState: .loaded, cellItems: cellItems)
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
