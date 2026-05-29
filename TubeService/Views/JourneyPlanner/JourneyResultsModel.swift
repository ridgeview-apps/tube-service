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
        pages = [JourneyResultsPage(id: Self.initialPageID, loadingState: .loading, cellItems: [])]
        earlierTimeAdjustment = nil
        laterTimeAdjustment = nil
        pageCounter = 0
    }

    func setInitialPageError(_ message: String) {
        if let index = pages.firstIndex(where: { $0.id == Self.initialPageID }) {
            pages[index].loadingState = .failure(errorMessage: message)
        }
    }

    func fetchInitialResults(requestParams: JourneyRequestParams, modeIDs: Set<ModeID>) async {
        if await fetchAndUpdatePage(id: Self.initialPageID, action: .initialFetch, requestParams: requestParams, modeIDs: modeIDs) {
            hasFetchedInitialData = true
        }
    }

    func fetchAdjacentResults(action: JourneyResultsAction, baseRequestParams: JourneyRequestParams, modeIDs: Set<ModeID>) async {
        let timeAdjustment: JourneyTimeAdjustment?
        switch action {
        case .earlierJourneys: timeAdjustment = earlierTimeAdjustment
        case .laterJourneys: timeAdjustment = laterTimeAdjustment
        default: return
        }
        guard let timeAdjustment else { return }

        pageCounter += 1
        let isEarlier = action == .earlierJourneys
        let pageID = "\(isEarlier ? "earlier" : "later")-\(pageCounter)"
        let loadingPage = JourneyResultsPage(id: pageID, loadingState: .loading, cellItems: [])

        if isEarlier {
            pages.insert(loadingPage, at: 0)
        } else {
            pages.append(loadingPage)
        }

        let requestParams = Self.applyTimeAdjustment(timeAdjustment, to: baseRequestParams)
        await fetchAndUpdatePage(id: pageID, action: action, requestParams: requestParams, modeIDs: modeIDs)
    }

    // MARK: - Private

    private static let initialPageID = "initial"

    @discardableResult
    private func fetchAndUpdatePage(
        id: String,
        action: JourneyResultsAction,
        requestParams: JourneyRequestParams,
        modeIDs: Set<ModeID>
    ) async -> Bool {
        do {
            let results: JourneyResults = try await transportAPI.fetchJourneyResults(for: requestParams).decodedModel
            let page = makePage(id: id, with: results, modeIDs: modeIDs)
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

    private func makePage(id: String, with results: JourneyResults, modeIDs: Set<ModeID>) -> JourneyResultsPage {
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
                JourneyResultsCellItem(journey: journey,
                                       journeyDiagramID: "\(id)-\(index)",
                                       isExpanded: false)
            }
        return JourneyResultsPage(id: id, loadingState: .loaded, cellItems: cellItems)
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
              let arrival = journey.arrivalDateTime else { return nil }
        self.start = start
        self.arrival = arrival
    }
}
