import Foundation
import SQLite3

/// `londonBusStops.sql`: the schema, then one `INSERT` per stop sorted by ID, so a PR's diff shows only the stops that changed.
public enum BusStopSQL {

    static let schema = """
        CREATE TABLE stops (
            id TEXT PRIMARY KEY NOT NULL,
            name TEXT NOT NULL,
            locality TEXT,
            letter TEXT,
            towards TEXT,
            stop_code TEXT,
            stop_area_id TEXT,
            lat REAL NOT NULL,
            lon REAL NOT NULL,
            bearing TEXT,
            is_hail_and_ride INTEGER NOT NULL,
            routes TEXT NOT NULL
        );
        CREATE INDEX stops_location ON stops (lat, lon);
        CREATE INDEX stops_stop_code ON stops (stop_code);
        """

    static let columns = "id, name, locality, letter, towards, stop_code, stop_area_id, lat, lon, bearing, is_hail_and_ride, routes"

    public struct ReadFailed: Error, CustomStringConvertible {
        public let description: String
    }

    public static func encode(_ stops: [LondonBusStop]) -> Data {
        let inserts = stops.sorted { $0.id < $1.id }.map(insert)
        let lines = [schema, "BEGIN TRANSACTION;"] + inserts + ["COMMIT;"]
        return Data((lines.joined(separator: "\n") + "\n").utf8)
    }

    /// The stops in an existing file, or `nil` if there isn't one yet.
    public static func read(from url: URL) throws -> [LondonBusStop]? {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try decode(String(contentsOf: url, encoding: .utf8))
    }

    static func decode(_ sql: String) throws -> [LondonBusStop] {
        var database: OpaquePointer?
        guard sqlite3_open(":memory:", &database) == SQLITE_OK, let database else {
            throw ReadFailed(description: "couldn't open an in-memory database")
        }
        defer { sqlite3_close(database) }

        guard sqlite3_exec(database, sql, nil, nil, nil) == SQLITE_OK else {
            throw ReadFailed(description: "londonBusStops.sql doesn't load: \(String(cString: sqlite3_errmsg(database)))")
        }

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(database, "SELECT \(columns) FROM stops ORDER BY id", -1, &statement, nil) == SQLITE_OK else {
            throw ReadFailed(description: "londonBusStops.sql has an unexpected schema: \(String(cString: sqlite3_errmsg(database)))")
        }
        defer { sqlite3_finalize(statement) }

        var stops: [LondonBusStop] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            func text(_ column: Int32) -> String? {
                sqlite3_column_text(statement, column).map { String(cString: $0) }
            }
            let routesJSON = Data((text(11) ?? "[]").utf8)
            stops.append(
                LondonBusStop(
                    id: text(0) ?? "",
                    name: text(1) ?? "",
                    locality: text(2),
                    letter: text(3),
                    towards: text(4),
                    stopCode: text(5),
                    stopAreaID: text(6),
                    lat: sqlite3_column_double(statement, 7),
                    lon: sqlite3_column_double(statement, 8),
                    bearing: text(9),
                    isHailAndRide: sqlite3_column_int(statement, 10) != 0,
                    routes: try JSONDecoder().decode([String].self, from: routesJSON)
                )
            )
        }
        return stops
    }

    private static func insert(_ stop: LondonBusStop) -> String {
        let values = [
            literal(stop.id),
            literal(stop.name),
            literal(stop.locality),
            literal(stop.letter),
            literal(stop.towards),
            literal(stop.stopCode),
            literal(stop.stopAreaID),
            String(stop.lat),
            String(stop.lon),
            literal(stop.bearing),
            stop.isHailAndRide ? "1" : "0",
            literal(routesJSON(stop.routes))
        ]
        return "INSERT INTO stops (\(columns)) VALUES (\(values.joined(separator: ", ")));"
    }

    private static func routesJSON(_ routes: [String]) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        return String(decoding: (try? encoder.encode(routes)) ?? Data("[]".utf8), as: UTF8.self)
    }

    private static func literal(_ text: String?) -> String {
        guard let text else { return "NULL" }
        return "'\(text.replacingOccurrences(of: "'", with: "''"))'"
    }
}
