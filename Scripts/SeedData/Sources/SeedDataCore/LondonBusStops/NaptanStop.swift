/// The fields the seed takes from DfT's NaPTAN export, which TfL's bulk stop data lacks.
public struct NaptanStop: Equatable, Sendable {
    public let atcoCode: String
    public let naptanCode: String?
    public let localityName: String?
    public let bearing: String?
    public let isHailAndRide: Bool

    public init(atcoCode: String, naptanCode: String?, localityName: String?, bearing: String?, isHailAndRide: Bool) {
        self.atcoCode = atcoCode
        self.naptanCode = naptanCode
        self.localityName = localityName
        self.bearing = bearing
        self.isHailAndRide = isHailAndRide
    }

    public struct MissingColumns: Error, CustomStringConvertible {
        public let columns: [String]

        public var description: String { "the NaPTAN CSV has no \(columns.joined(separator: ", ")) column" }
    }

    /// Reads the CSV that `naptan.api.dft.gov.uk/v1/access-nodes?dataFormat=csv` returns.
    public static func parse(csv: String) throws -> [NaptanStop] {
        var records = CSV.records(in: csv)
        guard !records.isEmpty else { return [] }

        let header = records.removeFirst()
        let requiredColumns = ["ATCOCode", "NaptanCode", "LocalityName", "Bearing", "BusStopType"]
        let missingColumns = requiredColumns.filter { !header.contains($0) }
        guard missingColumns.isEmpty else { throw MissingColumns(columns: missingColumns) }

        let indexes = Dictionary(header.enumerated().map { ($1, $0) }, uniquingKeysWith: { first, _ in first })
        return records.compactMap { record in
            func value(_ column: String) -> String? {
                guard let index = indexes[column], index < record.count, !record[index].isEmpty else { return nil }
                return record[index]
            }
            guard let atcoCode = value("ATCOCode") else { return nil }
            return NaptanStop(
                atcoCode: atcoCode,
                naptanCode: value("NaptanCode"),
                localityName: value("LocalityName"),
                bearing: value("Bearing"),
                isHailAndRide: value("BusStopType") == "HAR"
            )
        }
    }
}

enum CSV {

    /// RFC 4180 records: quoted fields may hold commas, line breaks and doubled quotes.
    static func records(in text: String) -> [[String]] {
        var records: [[String]] = []
        var record: [String] = []
        var field = ""
        var isQuoted = false
        var characters = text.drop { $0 == "\u{FEFF}" }.makeIterator()
        var pending: Character?

        while let character = pending ?? characters.next() {
            pending = nil
            if isQuoted {
                if character == "\"" {
                    let next = characters.next()
                    if next == "\"" {
                        field.append("\"")
                    } else {
                        isQuoted = false
                        pending = next
                    }
                } else {
                    field.append(character)
                }
                continue
            }
            switch character {
            case "\"":
                isQuoted = true
            case ",":
                record.append(field)
                field = ""
            case "\n", "\r\n", "\r":
                record.append(field)
                records.append(record)
                record = []
                field = ""
            default:
                field.append(character)
            }
        }
        if !field.isEmpty || !record.isEmpty {
            record.append(field)
            records.append(record)
        }
        return records
    }
}
