import Foundation

public struct JourneyResultsCellItem: Identifiable, Hashable, Sendable {
    public var id: String { journeyDiagramID }
    public let journey: Journey
    public let journeyDiagramID: String

    public init(journey: Journey, journeyDiagramID: String) {
        self.journey = journey
        self.journeyDiagramID = journeyDiagramID
    }
}

public enum JourneyPage: Identifiable, Equatable, Sendable {
    case loading(id: String)
    case loaded(id: String, cellItems: [JourneyResultsCellItem])
    case failed(id: String, error: any Error)

    public var id: String {
        switch self {
        case .loading(let id), .loaded(let id, _), .failed(let id, _):
            return id
        }
    }

    public static func == (lhs: JourneyPage, rhs: JourneyPage) -> Bool {
        switch (lhs, rhs) {
        case (.loading(let l), .loading(let r)):
            return l == r
        case (.loaded(let lID, let lItems), .loaded(let rID, let rItems)):
            return lID == rID && lItems == rItems
        case (.failed(let lID, _), .failed(let rID, _)):
            return lID == rID
        default:
            return false
        }
    }

    public var cellItems: [JourneyResultsCellItem]? {
        if case .loaded(_, let items) = self { return items }
        return nil
    }

    public var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }

    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    public var isFailed: Bool {
        if case .failed = self { return true }
        return false
    }
}
