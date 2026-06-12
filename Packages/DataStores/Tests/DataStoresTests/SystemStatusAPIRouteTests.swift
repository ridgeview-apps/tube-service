import Foundation
import Testing

@testable import DataStores

struct SystemStatusAPIRouteTests {

    private let baseURL = URL(string: "https://foo.com/")!

    @Test
    func systemStatusEndpoint() throws {
        let route: SystemStatusAPIRoute = .getSystemStatus(fileName: "status.json")

        let url = try route.toURL(relativeTo: baseURL)

        #expect(url.absoluteString == "https://foo.com/system-status/status.json")
    }

    @Test
    func systemStatusRouteBuildsJSONGetRequest() throws {
        let route: SystemStatusAPIRoute = .getSystemStatus(fileName: "status.json")

        let request = try route.toURLRequest(relativeTo: baseURL)

        #expect(request.httpMethod == "GET")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }
}
