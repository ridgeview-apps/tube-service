import Foundation
import Models

// swiftlint:disable identifier_name
public struct JourneyPlannerForm: Equatable {
    
    public enum Action {
        case select(JourneyPlannerForm.FieldID)
        case clear(JourneyPlannerForm.FieldID)
        case submit
    }
    
    public enum TimeOption: Equatable {
        case leaveNow
        case leaveAt(Date)
        case arriveBy(Date)
    }
    
    public enum ModeOption: Equatable {
        case all
        case specific([ModeID])
    }
    
    struct ValidationResult: Equatable {
        let errorFields: [FieldID]
        var isValid: Bool { errorFields.isEmpty }
    }
    
    public var from: JourneyLocationPicker.Value?
    public var to: JourneyLocationPicker.Value?
    public var timeOption: TimeOption = .leaveNow
    public var modeOption: ModeOption = .all

    public enum FieldID {
        case from, to, timeOption
    }
    
    func validate() -> ValidationResult {
        var errorFields = Set<FieldID>()
        if from == nil {
            errorFields.insert(.from)
        }
        if to == nil {
            errorFields.insert(.to)
        }
        if from == to {
            errorFields.insert(.to)
        }
        return .init(errorFields: Array(errorFields))
    }
    
    public mutating func swapLocations() {
        let oldFrom = self.from
        let oldTo = self.to
        from = oldTo
        to = oldFrom        
    }

    var isValid: Bool {
        validate().isValid
    }
    
    public static let `default` = Self()
}
// swiftlint:enable identifier_name
