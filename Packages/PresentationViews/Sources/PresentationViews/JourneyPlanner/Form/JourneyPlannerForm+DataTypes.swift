import Foundation
import Models

// swiftlint:disable identifier_name
public struct JourneyPlannerForm: Hashable {
    
    public enum CurrentLocationAccessoryStatus {
        case warning
        case loadingState(LoadingState)
        case omitted
    }
    
    public enum Action {
        case tapLocationField(JourneyPlannerForm.FieldID.LocationID)
        case submit
        case selectRecentJourney(RecentJourneyItem)
        case deleteRecentJourney(RecentJourneyItem)
    }
    
    private struct ValidationResult: Equatable {
        let errorFields: [FieldID]
        var isValid: Bool { errorFields.isEmpty }
    }
    
    public var from: JourneyLocationPicker.Value?
    public var to: JourneyLocationPicker.Value?
    public var via: JourneyLocationPicker.Value?
    public var timeSelection: JourneyTimePickerSelection
    
    public init(from: JourneyLocationPicker.Value? = nil,
                to: JourneyLocationPicker.Value? = nil,
                via: JourneyLocationPicker.Value? = nil,
                timeSelection: JourneyTimePickerSelection = .leaveNow()) {
        self.from = from
        self.to = to
        self.via = via
        self.timeSelection = timeSelection
    }

    public enum FieldID: Hashable {
        public enum LocationID {
            case from
            case to
            case via
        }
        
        case location(LocationID)
    }
    
    public mutating func reset() {
        from = nil
        to = nil
        via = nil
        timeSelection = .leaveNow()
    }
    
    public var hasChanges: Bool {
        isFieldPopulated(.location(.from))
            || isFieldPopulated(.location(.to))
            || isFieldPopulated(.location(.via))
            || timeSelection.option != .leaveNow
    }
    
    public func hasErrors(for fieldID: FieldID) -> Bool {
        validate().errorFields.contains(fieldID)
    }
    
    public func isFieldValid(_ fieldID: FieldID) -> Bool {
        !hasErrors(for: fieldID)
    }
    
    public func isFieldPopulated(_ fieldID: FieldID) -> Bool {
        switch fieldID {
        case let .location(fieldID):
            return locationPickerValue(for: fieldID) != nil
        }
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

    var isValid: Bool {
        validate().isValid
    }
        
    private func validate() -> ValidationResult {
        var errorFields = Set<FieldID>()
        if from == nil {
            errorFields.insert(.location(.from))
        }
        if to == nil {
            errorFields.insert(.location(.to))
        }
        if from == to {
            errorFields.insert(.location(.from))
            errorFields.insert(.location(.to))
        }
        return .init(errorFields: Array(errorFields))
    }
    
    public static let empty: JourneyPlannerForm = .init()
}
// swiftlint:enable identifier_name
