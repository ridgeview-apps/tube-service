private extension String {
    func replacingDepartureStatus(_ oldValue: String, with newValue: String) -> String {
        replacingOccurrences(
            of: "\"departureStatus\": \"\(oldValue)\"",
            with: "\"departureStatus\": \(newValue)"
        )
    }
}

let elizabethLineArrivalsWithUnsupportedDepartureStatusJSON =
    elizabethLineArrivalsJSON.replacingDepartureStatus("Delayed", with: "\"BoardingSoon\"")

let elizabethLineArrivalsWithInvalidDepartureStatusTypeJSON =
    elizabethLineArrivalsJSON.replacingDepartureStatus("Delayed", with: "123")
