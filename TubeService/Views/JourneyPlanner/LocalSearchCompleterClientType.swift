import Foundation
@preconcurrency import MapKit

protocol LocalSearchCompleterClientType: AnyObject, Sendable {
    var queryFragment: String { get set }
    var resultTypes: MKLocalSearchCompleter.ResultType { get set }
    var results: [MKLocalSearchCompletion] { get }

    func cancel()
    func setDelegate(_ delegate: MKLocalSearchCompleterDelegate)
}

extension MKLocalSearchCompleter: LocalSearchCompleterClientType {
    func setDelegate(_ delegate: MKLocalSearchCompleterDelegate) {
        self.delegate = delegate
    }
}
