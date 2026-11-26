import Models
import Testing

@testable import PresentationViews

struct JourneyLocationViewStateTests {

    @Test
    func shortNameOfNamedLocationIsItsTitle() {
        let location = namedLocation(title: "Charing Cross", subtitle: "City of Westminster")

        #expect(location.shortName == "Charing Cross")
    }

    @Test
    func shortNameOfNamedLocationWithoutTitleFallsBackToSubtitle() {
        let location = namedLocation(title: "", subtitle: "City of Westminster")

        #expect(location.shortName == "City of Westminster")
    }

    @Test
    func shortNameOfUnresolvedCurrentLocationIsCurrentLocation() {
        let location = JourneyLocation.unknownCurrentLocation

        #expect(location.shortName == String(localized: .journeyPlannerLocationValueCurrentLocation))
    }

    private func namedLocation(title: String, subtitle: String) -> JourneyLocation {
        .namedLocation(
            .init(
                name: .init(title: title, subtitle: subtitle),
                coordinate: .init(lat: 51.5, lon: -0.12),
                isCurrentLocation: false
            )
        )
    }
}
