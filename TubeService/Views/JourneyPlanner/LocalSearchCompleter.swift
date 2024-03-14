import Foundation
import MapKit
import Models

enum LocalSearchError: Error {
    case coordinateNotFound
}

extension LocationSearchResult {
    init(searchCompletion: MKLocalSearchCompletion) {
        self = .init(title: searchCompletion.title,
                     subtitle: searchCompletion.subtitle)
    }
}

@MainActor
final class LocalSearchCompleter: NSObject, ObservableObject {
    
    private var searchResultsByID = [LocationSearchResult: MKLocalSearchCompletion]()
    @Published private(set) var results: [LocationSearchResult] = []
    @Published private(set) var errorMessage: String?
    
    private let searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    
    static let london = MKCoordinateRegion(center: .init(latitude: 51.5007282,
                                                         longitude: -0.1246263),
                                                         span: .init(latitudeDelta: 50000,
                                                                     longitudeDelta: 50000))
    
    let searchRegion: MKCoordinateRegion
    
    init(searchRegion: MKCoordinateRegion? = nil) {
        self.searchRegion = searchRegion ?? Self.london
        super.init()
        searchCompleter.delegate = self
    }
    
    func searchForPlaces(matching searchTerm: String) {
        results = []
        searchCompleter.cancel()
        searchCompleter.queryFragment = searchTerm
    }
    
    func location(for searchResult: LocationSearchResult) async throws -> Location {
        let request: MKLocalSearch.Request
        
        if let searchCompletion = searchResultsByID[searchResult] {
            request = MKLocalSearch.Request(completion: searchCompletion)
        } else {
            assertionFailure("MKLocalSearchCompletion missing - querying location by subtitle instead (may be less accurate)")
            request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchResult.title
        }
        request.region = searchRegion
        
        let search = MKLocalSearch(request: request)
        
        let response = try await search.start()
        guard let coordinate = response.mapItems.first?.placemark.coordinate else {
            throw LocalSearchError.coordinateNotFound
        }
        
        return Location(lat: coordinate.latitude, lon: coordinate.longitude)
    }    
}

extension LocalSearchCompleter: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        errorMessage = nil
        searchResultsByID = [:]
        
        completer.results.forEach {
            let locationSearchResult = LocationSearchResult(title: $0.title,
                                                            subtitle: $0.subtitle)
            searchResultsByID[locationSearchResult] = $0
        }
        results = searchResultsByID.keys.sorted { $0.title < $1.title}
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
}
