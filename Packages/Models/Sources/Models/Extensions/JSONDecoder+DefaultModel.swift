import Foundation

private extension DateFormatter {
    static let standardT: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
}

private let customDateFormatters: [DateFormatter] = [.standardT]
private let iso8601DateFormatter = ISO8601DateFormatter()

public extension JSONDecoder {
    
    static let defaultModelDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(tflDateDecodingStrategy)
        return decoder
    }()
    
    static func tflDateDecodingStrategy(for decoder: Decoder) throws -> Date {
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
}
