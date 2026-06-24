import Models

extension LocalSearchResultsStore {

    func resolveLocationCoordinates(forForm form: JourneyPlannerForm) async throws -> JourneyPlannerForm {
        async let resolveFrom = resolveLocationCoordinate(for: form.from)
        async let resolveTo = resolveLocationCoordinate(for: form.to)
        async let resolveVia = resolveLocationCoordinate(for: form.via)

        let (resolvedFromValue, resolvedToValue, resolvedViaValue) = try await (resolveFrom, resolveTo, resolveVia)

        var updatedForm = form
        if let resolvedFromValue { updatedForm.from = resolvedFromValue }
        if let resolvedToValue { updatedForm.to = resolvedToValue }
        if let resolvedViaValue { updatedForm.via = resolvedViaValue }

        return updatedForm
    }

    private func resolveLocationCoordinate(for location: JourneyLocation?) async throws -> JourneyLocation? {
        guard let location else { return nil }

        switch location {
        case .station, .nationalRail:
            return location
        case .namedLocation(let value):
            guard !value.isResolved else { return location }

            if value.isCurrentLocation {
                assertionFailure("Current location should already be resolved")
            }

            guard let locationName = value.name else {
                throw JourneyPlannerError.coordinateUnknown
            }
            let resolvedCoordinate = try await locationCoordinate(for: locationName)
            return .namedLocation(
                .init(
                    name: locationName,
                    coordinate: resolvedCoordinate,
                    isCurrentLocation: value.isCurrentLocation
                )
            )
        }
    }
}
