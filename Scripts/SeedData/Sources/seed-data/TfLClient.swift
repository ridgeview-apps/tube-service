import Foundation
import SeedDataCore

struct TfLClient {

    struct RequestFailed: Error, CustomStringConvertible {
        let url: URL
        let statusCode: Int

        var description: String { "TfL returned HTTP \(statusCode) for \(url.path)" }
    }

    // No app_key: the only key is the app's, and requests from here would count against its users' rate limit.
    // A run is a handful of requests, well within TfL's keyless limit; if that ever bites, get this tool its own key.
    private let baseURL = URL(string: "https://api.tfl.gov.uk")!
    // TfL's gateway answers a slow request with a 504 after about 60 seconds, URLSession's default timeout. Waiting
    // longer lets the 504 arrive, so it's retried like any other server error.
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        return URLSession(configuration: configuration)
    }()
    private let maximumAttempts = 3

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
        let url = baseURL.appending(path: path)

        for attempt in 1...maximumAttempts {
            let retryableError: any Error
            let reason: String
            do {
                let (data, response) = try await session.data(from: url)
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

                if (200..<300).contains(statusCode) {
                    return try JSONDecoder().decode(Response.self, from: data)
                }
                let isRetryable = statusCode == 429 || (500..<600).contains(statusCode)
                guard isRetryable else {
                    throw RequestFailed(url: url, statusCode: statusCode)
                }
                retryableError = RequestFailed(url: url, statusCode: statusCode)
                reason = "TfL returned HTTP \(statusCode)"
            } catch let error as URLError where error.code == .timedOut {
                retryableError = error
                reason = "The request timed out"
            }

            guard attempt < maximumAttempts else { throw retryableError }
            print("\(reason) for \(path), retrying (\(attempt)/\(maximumAttempts - 1))")
            try await Task.sleep(for: .seconds(5 * attempt))
        }

        throw RequestFailed(url: url, statusCode: 0)
    }
}
