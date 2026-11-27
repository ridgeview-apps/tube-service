import Foundation
import SeedDataCore

/// DfT's NaPTAN API, the source of stop codes, which TfL only returns a stop at a time.
struct NaptanClient {

    private let fetcher = RetryingFetcher()

    /// ATCO area 490 is London.
    func fetchLondonStops() async throws -> [NaptanStop] {
        var components = URLComponents(string: "https://naptan.api.dft.gov.uk/v1/access-nodes")!
        components.queryItems = [URLQueryItem(name: "atcoAreaCodes", value: "490"), URLQueryItem(name: "dataFormat", value: "csv")]
        let data = try await fetcher.data(from: components.url!)
        return try NaptanStop.parse(csv: String(decoding: data, as: UTF8.self))
    }
}
