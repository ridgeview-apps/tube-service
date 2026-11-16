import Foundation
import SeedDataCore

struct TfLClient {

    struct RequestFailed: Error, CustomStringConvertible {
        let url: URL
        let statusCode: Int

        var description: String { "TfL returned HTTP \(statusCode) for \(url.path)" }
    }

    private let baseURL = URL(string: "https://api.tfl.gov.uk")!
    private let appKey: String?
    private let session: URLSession = .shared
    private let maximumAttempts = 3

    /// The key is optional: TfL serves keyless requests at a lower rate limit.
    init(appKey: String?) {
        self.appKey = appKey?.isEmpty == false ? appKey : nil
    }

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

    private func get<Response: Decodable>(_ path: String) async throws -> Response {
        var components = URLComponents(url: baseURL.appending(path: path), resolvingAgainstBaseURL: false)!
        if let appKey {
            components.queryItems = [URLQueryItem(name: "app_key", value: appKey)]
        }
        let url = components.url!

        for attempt in 1...maximumAttempts {
            let (data, response) = try await session.data(from: url)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            if (200..<300).contains(statusCode) {
                return try JSONDecoder().decode(Response.self, from: data)
            }

            let isRetryable = statusCode == 429 || (500..<600).contains(statusCode)
            guard isRetryable, attempt < maximumAttempts else {
                throw RequestFailed(url: url, statusCode: statusCode)
            }
            print("TfL returned HTTP \(statusCode) for \(path), retrying (\(attempt)/\(maximumAttempts - 1))")
            try await Task.sleep(for: .seconds(5 * attempt))
        }

        throw RequestFailed(url: url, statusCode: 0)
    }
}
