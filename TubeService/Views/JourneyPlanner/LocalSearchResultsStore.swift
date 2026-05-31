import Foundation
@preconcurrency import MapKit
import Models
import Observation

enum LocalSearchError: Error {
    case coordinateNotFound
}

extension LocationName {
    init(searchCompletion: MKLocalSearchCompletion) {
        self = .init(title: searchCompletion.title,
                     subtitle: searchCompletion.subtitle)
    }
}

@MainActor
@Observable
final class LocalSearchResultsStore {
    
    private(set) var results: [LocationName] = []
    private(set) var lastErrorMessage: String?
    
    private let completerClient: LocalSearchCompleterClientType
    private let searchCompleterDelegate = LocalSearchCompleterDelegate()
    
    static let london = MKCoordinateRegion(center: .init(latitude: 51.5007282,
                                                         longitude: -0.1246263),
                                                         span: .init(latitudeDelta: 50000,
                                                                     longitudeDelta: 50000))
    
    let searchRegion: MKCoordinateRegion
    
    init(completerClient: LocalSearchCompleterClientType = MKLocalSearchCompleter(),
         searchRegion: MKCoordinateRegion? = nil) {
        self.completerClient = completerClient
        self.searchRegion = searchRegion ?? Self.london
        completerClient.resultTypes = [.pointOfInterest, .address]

        searchCompleterDelegate.onAction = { [weak self] action in
            self?.handleLocalSearchCompleterDelegateAction(action)
        }
        completerClient.setDelegate(searchCompleterDelegate)
    }
    
    func searchForPlaces(matching searchTerm: String) {
        results = []
        completerClient.cancel()
        completerClient.queryFragment = searchTerm
    }
    
    func locationCoordinate(for searchResult: LocationName) async throws -> LocationCoordinate {
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
}

// MARK: - MKLocalSearchCompleterDelegate

private class LocalSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    enum Action {
        case didUpdateResults([MKLocalSearchCompletion])
        case didFailWithError(Error)
    }
    
    var onAction: ((Action) -> Void)?
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onAction?(.didUpdateResults(completer.results))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        onAction?(.didFailWithError(error))
    }
}

private extension LocalSearchResultsStore {
    
    func handleLocalSearchCompleterDelegateAction(_ action: LocalSearchCompleterDelegate.Action) {
        switch action {
        case .didUpdateResults(let rawResults):
            lastErrorMessage = nil
            
            results = rawResults
                        .map {
                            LocationName(title: $0.title, subtitle: $0.subtitle)
                        }
                        .removingDuplicates()
            
        case .didFailWithError(let error):
            lastErrorMessage = error.localizedDescription
        }
    }
}
