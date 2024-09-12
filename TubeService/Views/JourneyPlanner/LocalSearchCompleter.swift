import Foundation
import MapKit
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
final class LocalSearchCompleter: NSObject {
    
    private(set) var results: [LocationName] = []
    private(set) var errorMessage: String?
    
    private let searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    private let searchCompleterDelegate = LocalSearchCompleterDelegate()
    
    static let london = MKCoordinateRegion(center: .init(latitude: 51.5007282,
                                                         longitude: -0.1246263),
                                                         span: .init(latitudeDelta: 50000,
                                                                     longitudeDelta: 50000))
    
    let searchRegion: MKCoordinateRegion
    
    init(searchRegion: MKCoordinateRegion? = nil) {
        self.searchRegion = searchRegion ?? Self.london
        super.init()
        searchCompleter.resultTypes = [.pointOfInterest, .address]

        searchCompleterDelegate.onAction = { [weak self] action in
            self?.handleLocalSearchCompleterDelegateAction(action)
        }
        searchCompleter.delegate = searchCompleterDelegate
    }
    
    func searchForPlaces(matching searchTerm: String) {
        results = []
        searchCompleter.cancel()
        searchCompleter.queryFragment = searchTerm
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
        case didUpdateResults(MKLocalSearchCompleter)
        case didFailWithError(MKLocalSearchCompleter, Error)
    }
    
    var onAction: ((Action) -> Void)?
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onAction?(.didUpdateResults(completer))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        onAction?(.didFailWithError(completer, error))
    }
}

private extension LocalSearchCompleter {
    
    func handleLocalSearchCompleterDelegateAction(_ action: LocalSearchCompleterDelegate.Action) {
        switch action {
        case .didUpdateResults(let completer):
            errorMessage = nil
            
            results = completer
                        .results
                        .map {
                            LocationName(title: $0.title, subtitle: $0.subtitle)
                        }
                        .removingDuplicates()
            
        case .didFailWithError(_, let error):
            errorMessage = error.localizedDescription
        }
    }
}
