import Foundation
import Testing

@testable import DataStores

struct HTTPConnectionErrorTests {

    @Test
    func cancelledRequestBecomesACancellationError() {
        let error = URLSession.connectionError(for: URLError(.cancelled))

        #expect(error is CancellationError)
    }

    @Test
    func otherURLErrorsBecomeConnectionErrors() {
        let error = URLSession.connectionError(for: URLError(.notConnectedToInternet))

        #expect((error as? HTTPError) == .connection(URLError(.notConnectedToInternet)))
    }
}
