import Foundation

public struct JourneyPlannerForm: Hashable, Sendable {

    public enum FieldID: Hashable, Sendable {
        public enum LocationID: Hashable, Sendable {
            case from
            case to
            case via
        }

        case location(LocationID)
    }

    public var from: JourneyLocation? {
        didSet { showInlineErrorsIfNeeded() }
    }
    public var to: JourneyLocation? {
        didSet { showInlineErrorsIfNeeded() }
    }
    public var via: JourneyLocation?
    public var timeSelection: JourneyTimeSelection

    public private(set) var showsInlineErrors: Bool

    public init(
        from: JourneyLocation? = nil,
        to: JourneyLocation? = nil,
        via: JourneyLocation? = nil,
        timeSelection: JourneyTimeSelection = .leaveNow(),
        showsInlineErrorsImmediately: Bool = false
    ) {
        self.from = from
        self.to = to
        self.via = via
        self.timeSelection = timeSelection
        self.showsInlineErrors = showsInlineErrorsImmediately
    }

    private mutating func showInlineErrorsIfNeeded() {
        if from != nil && to != nil {
            showsInlineErrors = true
        }
    }

    public func locationValue(for locationFieldID: FieldID.LocationID) -> JourneyLocation? {
        switch locationFieldID {
        case .from: return from
        case .to: return to
        case .via: return via
        }
    }

    public var canSubmit: Bool {
        guard let from, let to else { return false }
        return from != to
    }

    public mutating func populate(locationFieldID: FieldID.LocationID, with newValue: JourneyLocation?) {
        switch locationFieldID {
        case .from: from = newValue
        case .to: to = newValue
        case .via: via = newValue
        }
    }

    public static let empty: JourneyPlannerForm = .init()
}
