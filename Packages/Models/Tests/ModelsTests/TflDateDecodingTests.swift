import Foundation
import Testing

@testable import Models

struct TflDateDecodingTests {

    @Test
    func unzonedTimeInWinterIsLondonGMT() throws {
        #expect(try decodeDate("2024-01-15T09:30:00") == iso8601("2024-01-15T09:30:00Z"))
    }

    @Test
    func unzonedTimeInSummerIsLondonBST() throws {
        #expect(try decodeDate("2026-05-29T14:40:00") == iso8601("2026-05-29T13:40:00Z"))
    }

    @Test
    func zonedTimeIsUsedAsIs() throws {
        #expect(try decodeDate("2026-05-29T14:40:00Z") == iso8601("2026-05-29T14:40:00Z"))
    }

    @Test
    func unparseableDateThrows() {
        #expect(throws: DecodingError.self) {
            try decodeDate("next Tuesday")
        }
    }
}

// MARK: - Private helpers

private extension TflDateDecodingTests {

    func decodeDate(_ string: String) throws -> Date {
        try JSONDecoder.tflModelDecoder.decode(Date.self, from: Data("\"\(string)\"".utf8))
    }

    func iso8601(_ string: String) -> Date {
        try! Date(string, strategy: .iso8601)
    }
}
