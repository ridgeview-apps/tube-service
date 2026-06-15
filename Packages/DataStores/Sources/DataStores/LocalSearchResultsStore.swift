import Foundation
@preconcurrency import MapKit
import Models
import Observation

public enum LocalSearchError: Error {
    case coordinateNotFound
}

@MainActor
@Observable
public final class LocalSearchResultsStore {

    public static let london = MKCoordinateRegion(
        center: .init(
            latitude: 51.5007282,
            longitude: -0.1246263
        ),
        span: .init(
            latitudeDelta: 50000,
            longitudeDelta: 50000
        )
    )

    // MARK: - State

    private let completerClient: LocalSearchCompleterClientType
    private let searchCompleterDelegate = LocalSearchCompleterDelegate()
    private let searchRegion: MKCoordinateRegion

    public private(set) var results: [LocationName] = []
    public private(set) var lastErrorMessage: String?

    public init(
        completerClient: LocalSearchCompleterClientType = MKLocalSearchCompleter(),
        searchRegion: MKCoordinateRegion? = nil
    ) {
        self.completerClient = completerClient
        self.searchRegion = searchRegion ?? Self.london
        completerClient.resultTypes = [.pointOfInterest, .address]

        searchCompleterDelegate.onAction = { [weak self] action in
            self?.handleLocalSearchCompleterDelegateAction(action)
        }
        completerClient.setDelegate(searchCompleterDelegate)
    }

    // MARK: - Actions

    public func searchForPlaces(matching searchTerm: String) {
        results = []
        completerClient.cancel()
        completerClient.queryFragment = searchTerm
    }

    public func locationCoordinate(for searchResult: LocationName) async throws -> LocationCoordinate {
        let request: MKLocalSearch.Request

        request = MKLocalSearch.Request()
        request.naturalLanguageQuery = [searchResult.title, searchResult.subtitle].joined(separator: " ")
        request.region = searchRegion

        let search = MKLocalSearch(request: request)

        let response = try await search.start()
        guard let coordinate = response.mapItems.first?.placemark.coordinate else {
            throw LocalSearchError.coordinateNotFound
        }

        return LocationCoordinate(lat: coordinate.latitude, lon: coordinate.longitude)
    }

    // MARK: - Implementation

    private func handleLocalSearchCompleterDelegateAction(_ action: LocalSearchCompleterDelegate.Action) {
        switch action {
        case .didUpdateResults:
            lastErrorMessage = nil
            results = completerClient.searchResults.removingDuplicates()
        case .didFailWithError(let error):
            lastErrorMessage = error.localizedDescription
        }
    }
}

private class LocalSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    enum Action {
        case didUpdateResults
        case didFailWithError(Error)
    }

    var onAction: ((Action) -> Void)?

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        _ = completer
        onAction?(.didUpdateResults)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        onAction?(.didFailWithError(error))
    }
}
