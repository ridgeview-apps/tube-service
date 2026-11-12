import Foundation

public struct DisruptedPoint: Codable, Identifiable, Hashable, Sendable {
    public var id: String? { atcoCode }

    public let atcoCode: String?
    public let description: String?
    public let appearance: DisruptionCategory?
    /// TfL's free-text kind of notice, e.g. "Part Closure", "Exit Only" or "Information".
    public let type: String?
    public let fromDate: Date?
    public let toDate: Date?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.atcoCode = try? container.decodeIfPresent(String.self, forKey: .atcoCode)
        self.description = try? container.decodeIfPresent(String.self, forKey: .description)
        self.appearance = try? container.decodeIfPresent(DisruptionCategory.self, forKey: .appearance)
        self.type = try? container.decodeIfPresent(String.self, forKey: .type)
        self.fromDate = try? container.decodeIfPresent(Date.self, forKey: .fromDate)
        self.toDate = try? container.decodeIfPresent(Date.self, forKey: .toDate)
    }
}
