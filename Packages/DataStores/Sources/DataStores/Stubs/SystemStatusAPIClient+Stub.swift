import Foundation
import Models
import ModelStubs
import Shared

#if DEBUG

@MainActor
public final class StubSystemStatusAPIClient: SystemStatusAPIClientType {
    
    public init() {}
    
    public private(set) var fetchSystemStatusCallCount = 0
    public var stubbedSystemStatus: HTTPResponse<SystemStatus> = .success200(ModelStubs.systemStatusOK)
    public var fetchSystemStatusError: HTTPError?
    public func fetchSystemStatus() async throws -> HTTPResponse<SystemStatus> {
        fetchSystemStatusCallCount += 1
        if let fetchSystemStatusError { throw fetchSystemStatusError }
        return stubbedSystemStatus
    }
}

#endif
