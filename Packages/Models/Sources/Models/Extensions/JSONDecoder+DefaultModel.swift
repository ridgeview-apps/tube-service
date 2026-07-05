import Foundation
import Shared

private extension DateFormatter {
    static let tflLocalDateTime: DateFormatter = {
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

private let tflDateFormatters: [DateFormatter] = [.tflLocalDateTime]

nonisolated(unsafe) private let iso8601WithFractionalSeconds: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
}()

public extension JSONDecoder {

    static let tflModelDecoder: JSONDecoder = {
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
        try decodeDate(from: decoder, using: tflDateFormatters)
    }

    @Sendable static func tubeServiceDateDecodingStrategy(for decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        if let date = iso8601WithFractionalSeconds.date(from: dateString) {
            return date
        }

        if let date = try? Date(dateString, strategy: .iso8601) {
            return date
        }

        if let date = DateFormatter.dateOnly.date(from: dateString) {
            return date
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Cannot decode date string \(dateString)"
        )
    }
}

private extension JSONDecoder {

    @Sendable static func decodeDate(from decoder: Decoder, using formatters: [DateFormatter]) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        if let date = try? Date(dateString, strategy: .iso8601) {
            return date
        }

        for formatter in formatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Cannot decode date string \(dateString)"
        )
    }
}
