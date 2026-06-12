import Foundation
import Testing

@testable import DataStores

struct HTTPDataTypesTests {

    @Test
    func successfulResponseIsDecoded() async throws {
        let urlSession = makeURLSession(protocolClass: SuccessfulResponseURLProtocol.self)

        let response = try await urlSession.get(
            url: URL(string: "https://example.com/status")!,
            decodedBy: JSONDecoder(),
            as: ResponseModel.self
        )

        #expect(response.statusCode == 200)
        #expect(response.decodedModel.value == "success")
    }

    @Test
    func redirectResponseThrowsStatusCodeError() async throws {
        let urlSession = makeURLSession(protocolClass: RedirectResponseURLProtocol.self)

        await #expect(throws: HTTPError.self) {
            _ = try await urlSession.get(
                url: URL(string: "https://example.com/status")!,
                decodedBy: JSONDecoder(),
                as: ResponseModel.self
            )
        }
    }

    private func makeURLSession(protocolClass: URLProtocol.Type) -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [protocolClass]
        return URLSession(configuration: configuration)
    }
}

private struct ResponseModel: Decodable, Sendable {
    let value: String
}

private final class SuccessfulResponseURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(#"{"value":"success"}"#.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

private final class RedirectResponseURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 304,
            httpVersion: nil,
            headerFields: nil
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(#"{"message":"Not modified"}"#.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
