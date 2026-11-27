import Foundation
import SeedDataCore

struct TfLClient {

    // No app_key: the only key is the app's, and requests from here would count against its users' rate limit.
    // A run is a few dozen requests, well within TfL's keyless limit; if that ever bites, get this tool its own key.
    private let baseURL = URL(string: "https://api.tfl.gov.uk")!
    private let fetcher = RetryingFetcher()

    /// Every rail station, whatever its mode. `/StopPoint/Mode/national-rail` leaves out stations TfL has since
    /// retagged (Acton Central is only "overground", Alsager has no modes at all), and times out without `page`.
    func fetchRailStations() async throws -> [TfLStopPoint] {
        try await get("/StopPoint/Type/NaptanRailStation")
    }

    func fetchLines(modes: [String]) async throws -> [TfLLine] {
        try await get("/Line/Mode/\(modes.joined(separator: ","))")
    }

    func fetchStopPoints(line lineID: String) async throws -> [TfLStopPoint] {
        try await get("/Line/\(lineID)/StopPoints")
    }

    /// The hubs (e.g. "HUBPAD") that group a station's tube, rail and DLR stop points.
    func fetchInterchanges() async throws -> [TfLStopPoint] {
        try await get("/StopPoint/Type/TransportInterchange")
    }

    /// One page of 1,000 bus stop points, stop pairs and bus stations. TfL requires `page` for buses.
    func fetchBusStopPoints(page: Int) async throws -> TfLStopPointsPage {
        try await get("/StopPoint/Mode/bus", query: [URLQueryItem(name: "page", value: String(page))])
    }

    private func get<Response: Decodable>(_ path: String, query: [URLQueryItem] = []) async throws -> Response {
        let url = baseURL.appending(path: path).appending(queryItems: query)
        return try JSONDecoder().decode(Response.self, from: try await fetcher.data(from: url))
    }
}
