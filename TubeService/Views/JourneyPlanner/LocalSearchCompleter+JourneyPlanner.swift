import DataStores
import PresentationViews

extension LocalSearchResultsStore {

    func resolveLocationCoordinates(forForm form: JourneyPlannerForm) async throws -> JourneyPlannerForm {

        async let resolveFrom = resolveLocationCoordinate(for: form.from)
        async let resolveTo = resolveLocationCoordinate(for: form.to)
        async let resolveVia = resolveLocationCoordinate(for: form.via)

        let (resolvedFromValue, resolvedToValue, resolvedViaValue) = try await (resolveFrom, resolveTo, resolveVia)

        var updatedForm = form
        if let resolvedFromValue {
            updatedForm.from = resolvedFromValue
        }
        if let resolvedToValue {
            updatedForm.to = resolvedToValue
        }
        if let resolvedViaValue {
            updatedForm.via = resolvedViaValue
        }

        return updatedForm
    }

    private func resolveLocationCoordinate(for pickerValue: JourneyLocationPicker.Value?) async throws -> JourneyLocationPicker.Value? {
        guard let pickerValue else {
            return nil
        }

        switch pickerValue {
        case .station, .nationalRail:
            return pickerValue
        case .namedLocation(let value):
            guard !value.isResolved else {
                return pickerValue
            }

            if value.isCurrentLocation {
                assertionFailure("Current location should already be resolved")
            }

            guard let locationName = value.name else {
                throw JourneyPlannerError.coordinateUnknown
            }
            let resolvedCoordinate = try await locationCoordinate(for: locationName)
            return .namedLocation(.init(name: locationName,
                                        coordinate: resolvedCoordinate,
                                        isCurrentLocation: value.isCurrentLocation))
        }
    }
}
