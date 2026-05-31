import Foundation
@preconcurrency import MapKit
import Models

#if DEBUG

public final class StubLocalSearchCompleterClient: LocalSearchCompleterClientType, @unchecked Sendable {
    public init() {}

    public var queryFragment: String = ""
    public var resultTypes: MKLocalSearchCompleter.ResultType = []
    public var searchResults: [LocationName] = []

    public func cancel() {}
    public func setDelegate(_ delegate: MKLocalSearchCompleterDelegate) {}
}

#endif
