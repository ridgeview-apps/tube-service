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

        do {
            _ = try await urlSession.get(
                url: URL(string: "https://example.com/status")!,
                decodedBy: JSONDecoder(),
                as: ResponseModel.self
            )
            Issue.record("Expected a status code error")
        } catch let HTTPError.statusCode(statusCode, errorModel) {
            #expect(statusCode == 304)
            #expect(errorModel?.message == "Not modified")
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func serverErrorWithMalformedBodyHasNoErrorModel() async throws {
        let urlSession = makeURLSession(protocolClass: MalformedErrorResponseURLProtocol.self)

        do {
            _ = try await urlSession.get(
                url: URL(string: "https://example.com/status")!,
                decodedBy: JSONDecoder(),
                as: ResponseModel.self
            )
            Issue.record("Expected a status code error")
        } catch let HTTPError.statusCode(statusCode, errorModel) {
            #expect(statusCode == 500)
            #expect(errorModel == nil)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func connectionFailureIsWrapped() async throws {
        let urlSession = makeURLSession(protocolClass: ConnectionFailureURLProtocol.self)

        do {
            _ = try await urlSession.get(
                url: URL(string: "https://example.com/status")!,
                decodedBy: JSONDecoder(),
                as: ResponseModel.self
            )
            Issue.record("Expected a connection error")
        } catch let HTTPError.connection(error as URLError) {
            #expect(error.code == .notConnectedToInternet)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func nonHTTPResponseThrowsStatusCodeMissing() async throws {
        let urlSession = makeURLSession(protocolClass: NonHTTPResponseURLProtocol.self)

        do {
            _ = try await urlSession.get(
                url: URL(string: "https://example.com/status")!,
                decodedBy: JSONDecoder(),
                as: ResponseModel.self
            )
            Issue.record("Expected a missing status code error")
        } catch HTTPError.statusCodeMissing {
            // Expected error.
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func malformedSuccessfulResponseThrowsDecodingError() async throws {
        let urlSession = makeURLSession(protocolClass: MalformedSuccessResponseURLProtocol.self)

        await #expect(throws: DecodingError.self) {
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

private final class MalformedErrorResponseURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data("Internal Server Error".utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

private final class ConnectionFailureURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        client?.urlProtocol(self, didFailWithError: URLError(.notConnectedToInternet))
    }

    override func stopLoading() {}
}

private final class NonHTTPResponseURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let response = URLResponse(
            url: request.url!,
            mimeType: "application/json",
            expectedContentLength: 2,
            textEncodingName: nil
        )
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data("{}".utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

private final class MalformedSuccessResponseURLProtocol: URLProtocol {

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
        client?.urlProtocol(self, didLoad: Data(#"{"unexpected":true}"#.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
