import Foundation
import MapKit
import Models

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
final class LocalSearchCompleter: NSObject, ObservableObject {
    
    @Published private(set) var results: [LocationName] = []
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
        searchCompleter.resultTypes = [.pointOfInterest, .address]
        searchCompleter.delegate = self
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

extension LocalSearchCompleter: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        errorMessage = nil
        
        results = completer.results
                           .map {
                               LocationName(title: $0.title, subtitle: $0.subtitle)
                            }
                           .removingDuplicates()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
}
