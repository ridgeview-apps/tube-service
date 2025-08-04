import Foundation
import Models

// swiftlint:disable identifier_name
public struct JourneyPlannerForm: Hashable, Sendable {
    
    public enum CurrentLocationAccessoryStatus {
        case warning
        case loadingState(LoadingState)
        case omitted
    }
    
    public enum Action: Sendable {
        case tappedLocationField(JourneyPlannerForm.FieldID.LocationID)
        case tappedSubmit
        case tappedRecentJourney(RecentJourneyItem)
        case swipedToDelete(RecentJourneyItem)
    }
    
    struct ValidationResult {
        var errors: [FieldID: [String]]
        
        var hasErrors: Bool { !success }
        
        var success: Bool { errors.values.flatMap { $0 }.isEmpty }
        
        mutating func append(error: String, for fieldID: FieldID) {
            errors[fieldID, default: []].append(error)
        }
        
        mutating func requiredField(_ fieldID: FieldID) {
            append(error: String(localized: .journeyPlannerFormErrorFieldRequired),
                   for: fieldID)
        }
    }
    
    public var from: JourneyLocationPicker.Value? {
        didSet { showInlineErrorsIfNeeded() }
    }
    public var to: JourneyLocationPicker.Value? {
        didSet { showInlineErrorsIfNeeded() }
    }
    public var via: JourneyLocationPicker.Value?
    public var timeSelection: JourneyTimePickerSelection
    
    public private(set) var showsInlineErrors: Bool
    
    public enum ErrorVisibilityState {
        case hidden
        case visible
    }
    
    public init(from: JourneyLocationPicker.Value? = nil,
                to: JourneyLocationPicker.Value? = nil,
                via: JourneyLocationPicker.Value? = nil,
                timeSelection: JourneyTimePickerSelection = .leaveNow(),
                showsInlineErrorsImmediately: Bool = false) {
        self.from = from
        self.to = to
        self.via = via
        self.timeSelection = timeSelection
        self.showsInlineErrors = showsInlineErrorsImmediately
    }
    
    private mutating func showInlineErrorsIfNeeded() {
        // Only start showing errors once required fields (from / to) have been set once
        if from != nil && to != nil {
            showsInlineErrors = true
        }
    }

    public enum FieldID: Hashable, Sendable {
        public enum LocationID: Sendable {
            case from
            case to
            case via
        }
        
        case location(LocationID)
    }
    
    func locationPickerValue(for locationFieldID: FieldID.LocationID) -> JourneyLocationPicker.Value? {
        switch locationFieldID {
        case .from:
            return from
        case .to:
            return to
        case .via:
            return via
        }
    }
    
    var canSubmit: Bool {
        validate().success
    }
    
    func validate() -> ValidationResult {
        var result = ValidationResult(errors: [:])
        
        if from == nil {
            result.requiredField(.location(.from))
        }
        
        if to == nil {
            result.requiredField(.location(.to))
        }
        
        if let from, let to, from == to {
            result.append(error: String(localized: .journeyPlannerFormErrorToFieldInvalid),
                          for: .location(.to))
        }
        
        return result
    }
    
    public static let empty: JourneyPlannerForm = .init()
}
// swiftlint:enable identifier_name
