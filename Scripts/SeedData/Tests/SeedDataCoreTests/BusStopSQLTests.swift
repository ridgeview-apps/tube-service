import Foundation
import Testing

@testable import SeedDataCore

struct BusStopSQLTests {

    private let kingsCross = LondonBusStop(
        id: "490000129D",
        name: "King's Cross Station",
        locality: "King's Cross",
        letter: "D",
        towards: "Farringdon or Holborn Circus",
        stopCode: "54174",
        stopAreaID: nil,
        lat: 51.53045,
        lon: -0.12328,
        bearing: "S",
        isHailAndRide: false,
        routes: ["46", "63", "N63"]
    )
    private let longlandDrive = LondonBusStop(
        id: "490009313Z",
        name: "Longland Drive",
        locality: "Totteridge",
        letter: nil,
        towards: nil,
        stopCode: "95534",
        stopAreaID: "490G00009313",
        lat: 51.62669,
        lon: -0.17531,
        bearing: "S",
        isHailAndRide: true,
        routes: ["251"]
    )

    @Test
    func writesOneInsertPerStopSortedByIDAfterTheSchema() {
        let sql = String(decoding: BusStopSQL.encode([longlandDrive, kingsCross]), as: UTF8.self)
        let lines = sql.split(separator: "\n").map(String.init)

        #expect(sql.hasPrefix(BusStopSQL.schema + "\nBEGIN TRANSACTION;\n"))
        #expect(
            lines.suffix(3) == [
                "INSERT INTO stops (\(BusStopSQL.columns)) VALUES ('490000129D', 'King''s Cross Station', 'King''s Cross', 'D', 'Farringdon or Holborn Circus', '54174', NULL, 51.53045, -0.12328, 'S', 0, '[\"46\",\"63\",\"N63\"]');",
                "INSERT INTO stops (\(BusStopSQL.columns)) VALUES ('490009313Z', 'Longland Drive', 'Totteridge', NULL, NULL, '95534', '490G00009313', 51.62669, -0.17531, 'S', 1, '[\"251\"]');",
                "COMMIT;"
            ]
        )
    }

    @Test
    func readsBackWhatItWrites() throws {
        let sql = String(decoding: BusStopSQL.encode([longlandDrive, kingsCross]), as: UTF8.self)

        #expect(try BusStopSQL.decode(sql) == [kingsCross, longlandDrive])
    }

    @Test
    func readsNothingWhenTheFileIsMissing() throws {
        let missingURL = URL(filePath: NSTemporaryDirectory()).appending(path: UUID().uuidString)

        #expect(try BusStopSQL.read(from: missingURL) == nil)
    }

    @Test
    func failsOnAFileThatDoesNotLoad() {
        #expect(throws: BusStopSQL.ReadFailed.self) {
            try BusStopSQL.decode("INSERT INTO stops VALUES (")
        }
    }
}
