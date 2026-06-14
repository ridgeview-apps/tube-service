import Foundation
import Testing

@testable import Models

struct LossyDecodableArrayTests {

    private enum Fruit: String, Codable {
        case apple
        case banana
        case cherry
    }

    @Test
    func decodesAllValidElements() throws {
        let json = #"["apple", "banana", "cherry"]"#
        let result = try decode(json)
        #expect(result == [.apple, .banana, .cherry])
    }

    @Test
    func dropsUnknownElements() throws {
        let json = #"["apple", "unknown", "cherry"]"#
        let result = try decode(json)
        #expect(result == [.apple, .cherry])
    }

    @Test
    func dropsAllElementsWhenAllUnknown() throws {
        let json = #"["unknown1", "unknown2"]"#
        let result = try decode(json)
        #expect(result.isEmpty)
    }

    @Test
    func decodesEmptyArray() throws {
        let json = "[]"
        let result = try decode(json)
        #expect(result.isEmpty)
    }

    @Test
    func preservesOrderOfValidElements() throws {
        let json = #"["cherry", "unknown", "apple", "unknown2", "banana"]"#
        let result = try decode(json)
        #expect(result == [.cherry, .apple, .banana])
    }
}

private extension LossyDecodableArrayTests {

    private func decode(_ json: String) throws -> [Fruit] {
        let data = Data(json.utf8)
        return try JSONDecoder().decode(LossyDecodableArray<Fruit>.self, from: data).elements
    }
}
