import Testing

@testable import SeedDataCore

struct NaptanStopTests {

    @Test
    func readsTheColumnsTheSeedNeeds() throws {
        let csv = [
            "\u{FEFF}ATCOCode,NaptanCode,CommonName,LocalityName,Bearing,BusStopType",
            "490000129D,54174,\"King's Cross St. Pancras, Stop D\",King's Cross,S,MKD",
            "490009313Z,95534,Longland Drive,Totteridge,S,HAR",
            "490002346HN,,\"Aldrington Road \"\"North\"\"\",Streatham Park,,HAR",
            ""
        ]
        .joined(separator: "\r\n")

        let stops = try NaptanStop.parse(csv: csv)

        #expect(
            stops == [
                NaptanStop(atcoCode: "490000129D", naptanCode: "54174", localityName: "King's Cross", bearing: "S", isHailAndRide: false),
                NaptanStop(atcoCode: "490009313Z", naptanCode: "95534", localityName: "Totteridge", bearing: "S", isHailAndRide: true),
                NaptanStop(atcoCode: "490002346HN", naptanCode: nil, localityName: "Streatham Park", bearing: nil, isHailAndRide: true)
            ]
        )
    }

    @Test
    func failsWhenAColumnIsMissing() {
        #expect(throws: NaptanStop.MissingColumns.self) {
            try NaptanStop.parse(csv: "ATCOCode,NaptanCode\n490000129D,54174\n")
        }
    }

    @Test
    func splitsQuotedFieldsHoldingCommasQuotesAndLineBreaks() {
        let records = CSV.records(in: "a,\"b, c\",\"say \"\"hi\"\"\",\"two\nlines\"\nlast,row")

        #expect(records == [["a", "b, c", "say \"hi\"", "two\nlines"], ["last", "row"]])
    }
}
