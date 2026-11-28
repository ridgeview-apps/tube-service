import Foundation
import SQLite3
import Synchronization

public struct BusStopDatabase: Sendable {

    public static let london = BusStopDatabase(connection: Connection(bundledDatabaseNamed: "londonBusStops"))

    private let connection: Connection

    private init(connection: Connection) {
        self.connection = connection
    }

    init(stops: [BusStop]) {
        self.init(connection: Connection(inMemoryDatabaseWith: stops, schemaFromBundledDatabaseNamed: "londonBusStops"))
    }

    /// Reads every stop, for tests that check the bundled database. The app queries only the stops it needs.
    func allStops() throws -> [BusStop] {
        try connection.readStops(where: "TRUE")
    }

    /// The stops with the given IDs, in the same order, skipping any that aren't found.
    public func stops(ids: [BusStop.ID]) -> [BusStop] {
        guard !ids.isEmpty else { return [] }
        let placeholders = Array(repeating: "?", count: ids.count).joined(separator: ", ")
        let stops = connection.stops(where: "id IN (\(placeholders))", ids.map { .text($0) })
        let stopsByID = Dictionary(stops.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        return ids.compactMap { stopsByID[$0] }
    }

    /// The places whose nearest stop is within `radius` of `location`, nearest first.
    public func nearbyPlaces(to location: LocationCoordinate, within radius: Double, limit: Int) -> [NearbyBusPlace] {
        // A place within the radius can have stops beyond it, which must be grouped with it
        let places = stops(within: radius + NearbyBusPlace.maxSpan, of: location).groupedByPlace()
        return Array(places.prefix { $0.distance <= radius }.prefix(limit))
    }

    /// The stop across the road, when the stop's place has just one other stop.
    public func oppositeStop(of stop: BusStop) -> BusStop? {
        let place = stops(within: NearbyBusPlace.maxSpan, of: stop.location)
            .groupedByPlace()
            .first { place in place.stops.contains { $0.stop.id == stop.id } }
        guard let place, place.stops.count == 2 else { return nil }
        return place.stops.first { $0.stop.id != stop.id }?.stop
    }

    private static let minimumMetresPerDegree = 110_574.0

    private func stops(within radius: Double, of location: LocationCoordinate) -> [NearbyBusStop] {
        let latSpan = radius / Self.minimumMetresPerDegree
        let lonSpan = latSpan / cos(location.lat * .pi / 180)
        let candidates = connection.stops(
            where: "lat BETWEEN ? AND ? AND lon BETWEEN ? AND ?",
            [
                .real(location.lat - latSpan),
                .real(location.lat + latSpan),
                .real(location.lon - lonSpan),
                .real(location.lon + lonSpan)
            ]
        )
        return
            candidates
            .map { NearbyBusStop($0, distance: location.distance(to: $0.location)) }
            .filter { $0.distance <= radius }
    }
}

// MARK: - SQLite

private enum Parameter {
    case text(String?)
    case real(Double)
    case integer(Int)
}

private struct SQLiteError: Error, CustomStringConvertible {
    let description: String

    init(_ message: String, in database: OpaquePointer?) {
        description = "\(message): \(database.map { String(cString: sqlite3_errmsg($0)) } ?? "no database")"
    }
}

// A broken bundled database is a build mistake, so errors fail loudly in debug but read as no stops in release.
private final class Connection: Sendable {

    private static let columns =
        "id, name, locality, letter, towards, stop_code, stop_area_id, lat, lon, bearing, is_hail_and_ride, routes"

    private let database: Mutex<OpaquePointer?>

    init(bundledDatabaseNamed name: String) {
        var database: OpaquePointer?
        do {
            database = try Self.openBundledDatabase(named: name)
        } catch {
            assertionFailure("Couldn't open \(name).sqlite: \(error)")
        }
        self.database = Mutex(database)
    }

    init(inMemoryDatabaseWith stops: [BusStop], schemaFromBundledDatabaseNamed name: String) {
        var database: OpaquePointer?
        do {
            let bundled = try Self.openBundledDatabase(named: name)
            defer { sqlite3_close(bundled) }
            let schema = try Self.rows("SELECT sql FROM sqlite_master WHERE sql IS NOT NULL", in: bundled) { row in
                sqlite3_column_text(row, 0).map { String(cString: $0) } ?? ""
            }

            guard sqlite3_open(":memory:", &database) == SQLITE_OK, let database else {
                throw SQLiteError("Couldn't open an in-memory database", in: database)
            }
            for statement in schema {
                _ = try Self.rows(statement, in: database) { _ in () }
            }
            let placeholders = Array(repeating: "?", count: 12).joined(separator: ", ")
            for stop in stops {
                _ = try Self.rows(
                    "INSERT INTO stops (\(Self.columns)) VALUES (\(placeholders))",
                    try Self.parameters(for: stop),
                    in: database
                ) { _ in () }
            }
        } catch {
            assertionFailure("Couldn't build an in-memory copy of \(name).sqlite: \(error)")
        }
        self.database = Mutex(database)
    }

    deinit {
        database.withLock { _ = sqlite3_close($0) }
    }

    func stops(where condition: String, _ parameters: [Parameter]) -> [BusStop] {
        do {
            return try readStops(where: condition, parameters)
        } catch {
            assertionFailure("Couldn't read bus stops: \(error)")
            return []
        }
    }

    func readStops(where condition: String, _ parameters: [Parameter] = []) throws -> [BusStop] {
        try database.withLock { database in
            guard let database else { throw SQLiteError("The database isn't open", in: nil) }
            return try Self.rows(
                "SELECT \(Self.columns) FROM stops WHERE \(condition)",
                parameters,
                in: database,
                row: Self.stop(at:)
            )
        }
    }

    private static func openBundledDatabase(named name: String) throws -> OpaquePointer {
        guard let url = Bundle.module.url(forResource: name, withExtension: "sqlite") else {
            throw SQLiteError("Missing \(name).sqlite", in: nil)
        }
        var database: OpaquePointer?
        let flags = SQLITE_OPEN_READONLY | SQLITE_OPEN_URI
        guard sqlite3_open_v2("\(url.absoluteString)?immutable=1", &database, flags, nil) == SQLITE_OK, let database else {
            let error = SQLiteError("Couldn't open \(url.lastPathComponent)", in: database)
            sqlite3_close(database)
            throw error
        }
        return database
    }

    private static func rows<Row>(
        _ sql: String,
        _ parameters: [Parameter] = [],
        in database: OpaquePointer,
        row: (OpaquePointer) throws -> Row
    ) throws -> [Row] {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK, let statement else {
            throw SQLiteError("Couldn't prepare \(sql)", in: database)
        }
        defer { sqlite3_finalize(statement) }

        for (index, parameter) in zip(Int32(1)..., parameters) {
            let result =
                switch parameter {
                case .text(let text?): sqlite3_bind_text(statement, index, text, -1, Self.transient)
                case .text(nil): sqlite3_bind_null(statement, index)
                case .real(let value): sqlite3_bind_double(statement, index, value)
                case .integer(let value): sqlite3_bind_int64(statement, index, Int64(value))
                }
            guard result == SQLITE_OK else { throw SQLiteError("Couldn't bind \(sql)", in: database) }
        }

        var rows: [Row] = []
        var result = sqlite3_step(statement)
        while result == SQLITE_ROW {
            rows.append(try row(statement))
            result = sqlite3_step(statement)
        }
        guard result == SQLITE_DONE else { throw SQLiteError("Couldn't run \(sql)", in: database) }
        return rows
    }

    // SQLITE_TRANSIENT, a macro Swift can't import, which makes SQLite copy the text
    private static var transient: sqlite3_destructor_type { unsafeBitCast(-1, to: sqlite3_destructor_type.self) }

    private static func stop(at row: OpaquePointer) throws -> BusStop {
        func text(_ column: Int32) -> String? {
            sqlite3_column_text(row, column).map { String(cString: $0) }
        }
        guard let id = text(0), let name = text(1), let routesJSON = text(11) else {
            throw SQLiteError("A stop is missing its ID, name or routes", in: nil)
        }
        return BusStop(
            id: id,
            name: name,
            locality: text(2),
            letter: text(3),
            towards: text(4),
            stopCode: text(5),
            stopAreaID: text(6),
            location: LocationCoordinate(lat: sqlite3_column_double(row, 7), lon: sqlite3_column_double(row, 8)),
            bearing: text(9),
            isHailAndRide: sqlite3_column_int(row, 10) != 0,
            routes: try JSONDecoder().decode([String].self, from: Data(routesJSON.utf8))
        )
    }

    private static func parameters(for stop: BusStop) throws -> [Parameter] {
        [
            .text(stop.id),
            .text(stop.name),
            .text(stop.locality),
            .text(stop.letter),
            .text(stop.towards),
            .text(stop.stopCode),
            .text(stop.stopAreaID),
            .real(stop.location.lat),
            .real(stop.location.lon),
            .text(stop.bearing),
            .integer(stop.isHailAndRide ? 1 : 0),
            .text(String(decoding: try JSONEncoder().encode(stop.routes), as: UTF8.self))
        ]
    }
}
