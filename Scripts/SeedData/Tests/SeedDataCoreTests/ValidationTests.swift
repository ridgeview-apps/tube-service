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
        let issues = Validation.validate([NationalRailStopPoint](), currentCount: nil, allowShrink: false)

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

    // MARK: - London

    /// One station per known line, so only the check under test fails.
    private let londonStations = KnownLines.ids.map { lineID in
        LondonStation(
            icsCode: "ics-\(lineID)",
            id: "id-\(lineID)",
            lineGroups: [LondonStation.LineGroup(atcoCode: "940G\(lineID.replacingOccurrences(of: "-", with: ""))", lineIds: [lineID])],
            location: LondonStation.Location(lat: 51.5, lon: -0.1),
            name: lineID
        )
    }

    @Test
    func passesValidLondonStations() {
        #expect(Validation.validate(londonStations, currentCount: londonStations.count, allowShrink: false).isEmpty)
    }

    @Test
    func failsWhenAKnownLineHasNoStation() {
        let stations = londonStations.filter { !$0.lineGroups.flatMap(\.lineIds).contains("tram") }

        #expect(Validation.validate(stations, currentCount: nil, allowShrink: false) == [.error("londonStations.json has no stations for: tram")])
    }

    @Test
    func failsOnAtcoCodesWithHyphens() {
        let station = LondonStation(
            icsCode: "1",
            id: "HUBX",
            lineGroups: [LondonStation.LineGroup(atcoCode: "940G-X", lineIds: ["central"])],
            location: LondonStation.Location(lat: 51.5, lon: -0.1),
            name: "X"
        )

        #expect(
            Validation.validate(londonStations + [station], currentCount: nil, allowShrink: false) == [
                .error("londonStations.json has ATCO codes containing \"-\": 940G-X")
            ]
        )
    }

    @Test
    func failsOnAtcoCodesSharedByTwoStations() {
        let station = LondonStation(
            icsCode: "1",
            id: "HUBX",
            lineGroups: [LondonStation.LineGroup(atcoCode: "940Gcentral", lineIds: ["central"])],
            location: LondonStation.Location(lat: 51.5, lon: -0.1),
            name: "X"
        )

        #expect(
            Validation.validate(londonStations + [station], currentCount: nil, allowShrink: false) == [
                .error("londonStations.json has ATCO codes shared by more than one station: 940Gcentral")
            ]
        )
    }

    @Test
    func warnsOnStationsWithTheSameName() {
        let station = LondonStation(
            icsCode: "1",
            id: "HUBX",
            lineGroups: [LondonStation.LineGroup(atcoCode: "940GX", lineIds: ["central"])],
            location: LondonStation.Location(lat: 51.5, lon: -0.1),
            name: "central"
        )

        #expect(
            Validation.validate(londonStations + [station], currentCount: nil, allowShrink: false) == [
                .warning("londonStations.json has stations with the same name: central")
            ]
        )
    }

    @Test
    func warnsOnLinesTheAppDoesntKnow() {
        #expect(
            Validation.unknownLines(["central", "purple"]) == [
                .warning("TfL has a line the app doesn't know: purple. Add it to TrainLineID and KnownLines.ids")
            ]
        )
    }
}
