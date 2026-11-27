import Testing

@testable import SeedDataCore

struct SeedDiffTests {

    private let abbeyWood = NationalRailStopPoint(commonName: "Abbey Wood", icsCode: "1001001", lat: 51.49, lon: 0.12, naptanId: "910GABWDXR")
    private let waterloo = NationalRailStopPoint(commonName: "London Waterloo", icsCode: "1000254", lat: 51.50, lon: -0.11, naptanId: "910GWATRLMN")
    private let euston = NationalRailStopPoint(commonName: "London Euston", icsCode: "1000078", lat: 51.53, lon: -0.13, naptanId: "910GEUSTON")

    private func londonStation(
        id: String = "HUBKGX",
        name: String = "King's Cross St. Pancras",
        lineGroups: [LondonStation.LineGroup] = [.init(atcoCode: "940GZZLUKSX", lineIds: ["piccadilly", "victoria"])],
        lat: Double = 51.53
    ) -> LondonStation {
        LondonStation(icsCode: "1000129", id: id, lineGroups: lineGroups, location: .init(lat: lat, lon: -0.12), name: name)
    }

    @Test
    func findsAddedRemovedAndChangedEntries() {
        let movedWaterloo = NationalRailStopPoint(commonName: "London Waterloo", icsCode: "1000254", lat: 51.51, lon: -0.11, naptanId: "910GWATRLMN")

        let diff = SeedDiff(old: [abbeyWood, waterloo], new: [movedWaterloo, euston])

        #expect(diff.added == [euston])
        #expect(diff.removed == [abbeyWood])
        #expect(diff.changed.map(\.new) == [movedWaterloo])
        #expect(!diff.isEmpty)
    }

    @Test
    func isEmptyWhenNothingChanged() {
        let diff = SeedDiff(old: [abbeyWood, waterloo], new: [waterloo, abbeyWood])

        #expect(diff.isEmpty)
    }

    @Test
    func countsEveryEntryAsAddedWithoutACurrentFile() {
        let diff = SeedDiff(old: nil, new: [waterloo, abbeyWood])

        #expect(diff.added == [abbeyWood, waterloo])
        #expect(diff.oldCount == 0)
    }

    @Test
    func reportsANewNaptanIDAtTheSameICSCodeAsAChange() {
        let renumbered = NationalRailStopPoint(commonName: "Abbey Wood", icsCode: "1001001", lat: 51.49, lon: 0.12, naptanId: "910GABWD")

        let diff = SeedDiff(old: [abbeyWood], new: [renumbered])

        #expect(diff.added.isEmpty)
        #expect(diff.removed.isEmpty)
        #expect(diff.changed.map { $0.new.changedFields(from: $0.old) } == [["naptanId: 910GABWDXR → 910GABWD"]])
    }

    @Test
    func describesChangedLondonFields() {
        let old = londonStation()
        let new = londonStation(
            name: "King's Cross",
            lineGroups: [.init(atcoCode: "940GZZLUKSX", lineIds: ["piccadilly"]), .init(atcoCode: "940GZZLUKSX", lineIds: ["victoria"])],
            lat: 51.54
        )

        #expect(
            new.changedFields(from: old) == [
                "name: \"King's Cross St. Pancras\" → \"King's Cross\"",
                "line groups: −940GZZLUKSX (piccadilly, victoria), +940GZZLUKSX (piccadilly), +940GZZLUKSX (victoria)",
                "location"
            ]
        )
    }

    @Test
    func describesReorderedLineGroups() {
        let piccadilly = LondonStation.LineGroup(atcoCode: "940GZZLUKSX", lineIds: ["piccadilly"])
        let thameslink = LondonStation.LineGroup(atcoCode: "910GSTPXBOX", lineIds: ["thameslink"])

        let new = londonStation(lineGroups: [thameslink, piccadilly])

        #expect(new.changedFields(from: londonStation(lineGroups: [piccadilly, thameslink])) == ["line groups reordered"])
    }

    @Test
    func summarisesChangesWithTheirImpactOnSavedData() {
        let renamed = londonStation(name: "King's Cross")
        let bank = londonStation(id: "HUBBAN", name: "Bank")
        let diff = SeedDiff(old: [londonStation(), bank], new: [renamed])

        let markdown = diff.markdown(file: "londonStations.json", issues: [.warning("something odd")])

        #expect(
            markdown == """
                ## londonStations.json

                2 → 1 entries: 0 added, 1 removed, 1 changed.

                ### Removed (affects saved favourites and journeys)

                - Bank (`HUBBAN`)

                ### Changed

                - King's Cross (`HUBKGX`): name: "King's Cross St. Pancras" → "King's Cross"

                ### Issues

                - warning: something odd

                """
        )
    }

    @Test
    func summarisesNoChanges() {
        let markdown = SeedDiff(old: [abbeyWood], new: [abbeyWood]).markdown(file: "nationalRailStations.json", issues: [])

        #expect(markdown == "## nationalRailStations.json\n\nNo changes.\n")
    }

    @Test
    func capsLongLists() {
        let maximum = SeedDiff<NationalRailStopPoint>.maximumListedEntries
        let stopPoints = (0...maximum).map {
            NationalRailStopPoint(commonName: "Station \($0)", icsCode: "\($0)", lat: 51.5, lon: -0.1, naptanId: "910G\($0)")
        }

        let markdown = SeedDiff(old: nil, new: stopPoints).markdown(file: "nationalRailStations.json", issues: [])

        #expect(markdown.split(separator: "\n").filter { $0.hasPrefix("- Station") }.count == maximum)
        #expect(markdown.hasSuffix("- …and 1 more\n"))
    }
}

struct BusStopDiffTests {

    private func stop(
        name: String = "King's Cross Station",
        letter: String? = "D",
        stopCode: String? = "54174",
        isHailAndRide: Bool = false,
        routes: [String] = ["46", "63"]
    ) -> LondonBusStop {
        LondonBusStop(
            id: "490000129D",
            name: name,
            locality: "King's Cross",
            letter: letter,
            towards: "Farringdon",
            stopCode: stopCode,
            stopAreaID: nil,
            lat: 51.53,
            lon: -0.12,
            bearing: "S",
            isHailAndRide: isHailAndRide,
            routes: routes
        )
    }

    @Test
    func namesAStopWithItsLetter() {
        #expect(stop().diffName == "King's Cross Station (D)")
        #expect(stop(letter: nil).diffName == "King's Cross Station")
    }

    @Test
    func describesChangedBusStopFields() {
        let new = stop(name: "King's Cross", letter: nil, stopCode: nil, isHailAndRide: true, routes: ["63", "N63"])

        #expect(
            new.changedFields(from: stop()) == [
                "name: \"King's Cross Station\" → \"King's Cross\"",
                "letter: \"D\" → none",
                "stop code: \"54174\" → none",
                "now hail and ride",
                "routes: −46, +N63"
            ]
        )
    }

    @Test
    func listsTheBreakdownAfterTheIssues() {
        let markdown = SeedDiff(old: [stop()], new: [stop()]).markdown(file: "londonBusStops.sql", issues: [], breakdown: ["1 stops"])

        #expect(markdown == "## londonBusStops.sql\n\nNo changes.\n\n### Breakdown\n\n- 1 stops\n")
    }
}
