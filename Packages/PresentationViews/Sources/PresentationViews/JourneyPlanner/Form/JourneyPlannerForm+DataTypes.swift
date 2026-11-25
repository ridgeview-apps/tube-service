import Foundation
import Models

extension JourneyPlannerForm {

    public enum CurrentLocationAccessoryStatus {
        case warning
        case loadingState(LoadingState)
        case omitted
    }

    public enum Action: Sendable {
        case tappedLocationField(JourneyPlannerForm.FieldID.LocationID)
        case tappedSubmit
        case tappedReset
        case tappedRecentJourney(RecentJourneyItem)
        case swipedToDelete(RecentJourneyItem)
        case confirmedClearRecentJourneys
    }

    struct ValidationResult {
        var errors: [FieldID: [String]]

        var hasErrors: Bool { !success }

        var success: Bool { errors.values.flatMap { $0 }.isEmpty }

        mutating func append(error: String, for fieldID: FieldID) {
            errors[fieldID, default: []].append(error)
        }

        mutating func requiredField(_ fieldID: FieldID) {
            append(
                error: String(localized: .journeyPlannerFormErrorFieldRequired),
                for: fieldID
            )
        }
    }

    public enum ErrorVisibilityState {
        case hidden
        case visible
    }

    /// The from/to fields that need the current location while it can't be detected.
    func fieldsMissingCurrentLocation(
        locationStatus: JourneyLocationTitleLabel.AccessoryStatus
    ) -> Set<FieldID.LocationID> {
        guard locationStatus.isFailure else { return [] }
        return Set(
            [FieldID.LocationID.from, .to].filter {
                locationValue(for: $0)?.isCurrentLocation == true
            }
        )
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
            result.append(
                error: String(localized: .journeyPlannerFormErrorToFieldInvalid),
                for: .location(.to)
            )
        }

        return result
    }
}
