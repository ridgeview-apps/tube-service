public struct DisruptedPoint: Codable, Identifiable, Hashable {
    public var id: String? { atcoCode }
    
    public let atcoCode: String?
    public let description: String?
    public let appearance: DisruptionCategory?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.atcoCode = try container.decodeIfPresent(String.self, forKey: .atcoCode)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        do {
            self.appearance = try container.decodeIfPresent(DisruptionCategory.self, forKey: .appearance)
        } catch {
            self.appearance = .undefined
        }

    }
}
