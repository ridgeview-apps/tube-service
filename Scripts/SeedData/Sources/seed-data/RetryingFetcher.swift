import Foundation

struct RetryingFetcher {

    struct RequestFailed: Error, CustomStringConvertible {
        let url: URL
        let statusCode: Int

        var description: String { "\(url.host() ?? "The server") returned HTTP \(statusCode) for \(url.path)" }
    }

    // TfL's gateway answers a slow request with a 504 after about 60 seconds, URLSession's default timeout. Waiting
    // longer lets the 504 arrive, so it's retried like any other server error.
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        return URLSession(configuration: configuration)
    }()
    private let maximumAttempts = 3

    func data(from url: URL) async throws -> Data {
        for attempt in 1...maximumAttempts {
            let retryableError: any Error
            let reason: String
            do {
                let (data, response) = try await session.data(from: url)
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

                if (200..<300).contains(statusCode) {
                    return data
                }
                let isRetryable = statusCode == 429 || (500..<600).contains(statusCode)
                guard isRetryable else {
                    throw RequestFailed(url: url, statusCode: statusCode)
                }
                retryableError = RequestFailed(url: url, statusCode: statusCode)
                reason = "HTTP \(statusCode)"
            } catch let error as URLError where error.code == .timedOut {
                retryableError = error
                reason = "The request timed out"
            }

            guard attempt < maximumAttempts else { throw retryableError }
            print("\(reason) for \(url.path), retrying (\(attempt)/\(maximumAttempts - 1))")
            try await Task.sleep(for: .seconds(5 * attempt))
        }

        throw RequestFailed(url: url, statusCode: 0)
    }
}
