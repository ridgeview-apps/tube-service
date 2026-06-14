public struct LossyDecodableArray<T: Decodable>: Decodable {
    public let elements: [T]

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements = [T]()
        while !container.isAtEnd {
            let failable = try container.decode(FailableDecodable<T>.self)
            if let value = failable.value {
                elements.append(value)
            }
        }
        self.elements = elements
    }
}

extension LossyDecodableArray: Sendable where T: Sendable {}

private struct FailableDecodable<T: Decodable>: Decodable {
    let value: T?

    init(from decoder: Decoder) throws {
        value = try? T(from: decoder)
    }
}
