import Foundation
@preconcurrency import MapKit
import Models
import Testing

@testable import DataStores

@MainActor
struct LocalSearchResultsStoreTests {

    @Test
    func searchForPlacesClearsResultsAndForwardsQuery() {
        // Given
        let completerClient = StubLocalSearchCompleterClient()
        let model = LocalSearchResultsStore(completerClient: completerClient)
        completerClient.searchResults = [.init(title: "King's Cross", subtitle: "London")]
        completerClient.simulateDidUpdateResults()

        // When
        model.searchForPlaces(matching: "waterloo")

        // Then
        #expect(model.results.isEmpty)
        #expect(completerClient.cancelCallCount == 1)
        #expect(completerClient.queryFragment == "waterloo")
    }

    @Test
    func didUpdateResultsPublishesDeduplicatedValuesAndClearsError() {
        // Given
        let completerClient = StubLocalSearchCompleterClient()
        let model = LocalSearchResultsStore(completerClient: completerClient)

        completerClient.simulateDidFailWithError(TestError.expected)
        #expect(model.lastErrorMessage != nil)

        completerClient.searchResults = [
            .init(title: "Baker Street", subtitle: "London"),
            .init(title: "Baker Street", subtitle: "London"),
            .init(title: "Oxford Circus", subtitle: "London")
        ]

        // When
        completerClient.simulateDidUpdateResults()

        // Then
        #expect(model.lastErrorMessage == nil)
        #expect(model.results.count == 2)
        #expect(model.results[0] == .init(title: "Baker Street", subtitle: "London"))
        #expect(model.results[1] == .init(title: "Oxford Circus", subtitle: "London"))
    }

    @Test
    func didFailWithErrorPublishesLocalizedDescription() {
        // Given
        let completerClient = StubLocalSearchCompleterClient()
        let model = LocalSearchResultsStore(completerClient: completerClient)

        // When
        completerClient.simulateDidFailWithError(TestError.expected)

        // Then
        #expect(model.lastErrorMessage == TestError.expected.localizedDescription)
    }
}

private enum TestError: Error {
    case expected
}

private final class StubLocalSearchCompleterClient: LocalSearchCompleterClientType, @unchecked Sendable {
    var queryFragment: String = ""
    var resultTypes: MKLocalSearchCompleter.ResultType = []
    var searchResults: [LocationName] = []

    private(set) var cancelCallCount = 0
    private weak var delegate: MKLocalSearchCompleterDelegate?

    func cancel() {
        cancelCallCount += 1
    }

    func setDelegate(_ delegate: MKLocalSearchCompleterDelegate) {
        self.delegate = delegate
    }

    func simulateDidUpdateResults() {
        delegate?.completerDidUpdateResults?(MKLocalSearchCompleter())
    }

    func simulateDidFailWithError(_ error: Error) {
        delegate?.completer?(MKLocalSearchCompleter(), didFailWithError: error)
    }
}
