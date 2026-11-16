import Testing

@testable import SeedDataCore

struct ValidationTests {

    private let abbeyWood = NationalRailStopPoint(commonName: "Abbey Wood", icsCode: "1001001", lat: 51.49, lon: 0.12, naptanId: "910GABWDXR")
    private let waterloo = NationalRailStopPoint(commonName: "London Waterloo", icsCode: "1000254", lat: 51.50, lon: -0.11, naptanId: "910GWATRLMN")

    @Test
    func passesValidStopPoints() {
        #expect(Validation.validate([abbeyWood, waterloo], currentCount: 2, allowShrink: false).isEmpty)
    }

    @Test
    func failsWhenEmpty() {
        let issues = Validation.validate([], currentCount: nil, allowShrink: false)

        #expect(issues == [.error("nationalRailStations.json has no entries")])
    }

    @Test
    func failsOnDuplicateIDs() {
        let duplicate = NationalRailStopPoint(commonName: "Abbey Wood", icsCode: "1001001", lat: 51.49, lon: 0.12, naptanId: "910GABWDXR")

        let issues = Validation.validate([abbeyWood, duplicate], currentCount: nil, allowShrink: false)

        #expect(
            issues == [
                .error("nationalRailStations.json has duplicate naptanIds: 910GABWDXR"),
                .error("nationalRailStations.json has duplicate icsCodes: 1001001")
            ]
        )
    }

    @Test
    func failsOnCoordinatesOutsideTheUK() {
        let nullIsland = NationalRailStopPoint(commonName: "Null Island", icsCode: "0", lat: 0, lon: 0, naptanId: "910GNULL")

        let issues = Validation.validate([abbeyWood, nullIsland], currentCount: nil, allowShrink: false)

        #expect(issues == [.error("nationalRailStations.json has coordinates outside the UK: Null Island")])
    }

    @Test
    func failsWhenShrunkByMoreThanFivePercent() {
        #expect(Validation.notShrunk(newCount: 95, currentCount: 100, allowShrink: false, file: "f").isEmpty)
        #expect(
            Validation.notShrunk(newCount: 94, currentCount: 100, allowShrink: false, file: "f") == [
                .error("f would shrink from 100 to 94 entries (pass --allow-shrink if that's expected)")
            ]
        )
    }

    @Test
    func warnsInsteadWhenShrinkIsAllowed() {
        #expect(Validation.notShrunk(newCount: 50, currentCount: 100, allowShrink: true, file: "f") == [.warning("f would shrink from 100 to 50 entries")])
    }
}
