import Foundation
import Shared

private extension DateFormatter {
    static let standardT: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // TfL returns unzoned timestamps as London local time; pin the formatter
        // so parsing doesn't depend on the host's current timezone (e.g. UTC on CI).
        dateFormatter.timeZone = .london
        return dateFormatter
    }()

    static let dateOnly: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
}

private let customDateFormatters: [DateFormatter] = [.standardT]
private let tubeServiceDateFormatters: [DateFormatter] = [.dateOnly]
nonisolated(unsafe) private let iso8601DateFormatter = ISO8601DateFormatter()

public extension JSONDecoder {

    static let defaultModelDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(tflDateDecodingStrategy)
        return decoder
    }()

    static let tubeServiceModelDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(tubeServiceDateDecodingStrategy)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    @Sendable static func tflDateDecodingStrategy(for decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        // 1. Try to decode it as an ISO8601 date
        if let iso8601Date = iso8601DateFormatter.date(from: dateString) {
            return iso8601Date
        }

        // 2. Try all other date formats
        for formatter in customDateFormatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
    }

    @Sendable static func tubeServiceDateDecodingStrategy(for decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        if let iso8601Date = iso8601DateFormatter.date(from: dateString) {
            return iso8601Date
        }

        for formatter in tubeServiceDateFormatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
    }
}
