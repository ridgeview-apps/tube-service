import Foundation
import Models

enum TflAPIRoute {
    case currentLineStatuses([ModeID])
    case lineStatusesForDateRange([TrainLineID], DateInterval)
    case arrivalPredictions(stationCode: String, [TrainLineID])
    case arrivalDepartures(stationCode: String, [TrainLineID])
    case stationDisruptions([ModeID])
    case journeyResults(JourneyRequestParams)

    func toURL(relativeTo baseURL: URL, appKey: String) throws -> URL {
        var urlComponents = try toURLComponents(relativeTo: baseURL)
        urlComponents.queryItems =
            [URLQueryItem(name: "app_key", value: appKey)]
            + (urlComponents.queryItems ?? [])

        guard let url = urlComponents.url else {
            throw HTTPError.invalidRequestURL
        }
        return url
    }

    func toURLRequest(relativeTo baseURL: URL, appKey: String) throws -> URLRequest {
        var request = URLRequest(url: try toURL(relativeTo: baseURL, appKey: appKey))
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private var pathComponents: [String] {
        switch self {
        case let .currentLineStatuses(modes):
            return ["Line", "Mode", modes.toURLPathParam(), "Status"]
        case let .lineStatusesForDateRange(lineIDs, dateInterval):
            return [
                "Line", lineIDs.toURLPathParam(), "Status",
                dateInterval.start.toAPIDateParam(), "to", dateInterval.end.toAPIDateParam()
            ]
        case let .arrivalPredictions(stationCode, lineIDs):
            return ["Line", lineIDs.toURLPathParam(), "Arrivals", stationCode]
        case let .arrivalDepartures(stationCode, _):
            return ["StopPoint", stationCode, "ArrivalDepartures"]
        case let .stationDisruptions(modes):
            return ["StopPoint", "Mode", modes.toURLPathParam(), "Disruption"]
        case let .journeyResults(params):
            return [
                "Journey", "JourneyResults", params.from.toURLPathParam(), "to",
                params.to.toURLPathParam()
            ]
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .currentLineStatuses, .lineStatusesForDateRange, .arrivalPredictions,
            .stationDisruptions:
            return []
        case let .arrivalDepartures(_, lineIDs):
            return [URLQueryItem(name: "lineIds", value: lineIDs.toURLPathParam())]
        case let .journeyResults(params):
            let alternativeCycle =
                params.modeIDs.contains(.cycle) || params.modeIDs.contains(.cycleHire)
            var items = [
                URLQueryItem(
                    name: "routeBetweenEntrances",
                    value: "\(params.routeBetweenEntrances)"
                ),
                URLQueryItem(name: "mode", value: params.modeIDs.toURLPathParam()),
                URLQueryItem(name: "alternativeCycle", value: "\(alternativeCycle)")
            ]
            if let via = params.via {
                items.append(URLQueryItem(name: "via", value: via.toURLPathParam()))
            }
            if let timeOption = params.timeOption {
                items.append(contentsOf: timeOption.toURLQueryItems)
            }
            return items
        }
    }

    private func toURLComponents(relativeTo baseURL: URL) throws -> URLComponents {
        try .route(
            relativeTo: baseURL,
            pathComponents: pathComponents,
            queryItems: queryItems
        )
    }
}
