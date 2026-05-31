import Foundation
@preconcurrency import MapKit
import Models

public protocol LocalSearchCompleterClientType: AnyObject, Sendable {
    var queryFragment: String { get set }
    var resultTypes: MKLocalSearchCompleter.ResultType { get set }
    var searchResults: [LocationName] { get }

    func cancel()
    func setDelegate(_ delegate: MKLocalSearchCompleterDelegate)
}

extension MKLocalSearchCompleter: LocalSearchCompleterClientType {
    public var searchResults: [LocationName] {
        results.map { .init(title: $0.title, subtitle: $0.subtitle) }
    }

    public func setDelegate(_ delegate: MKLocalSearchCompleterDelegate) {
        self.delegate = delegate
    }
}
