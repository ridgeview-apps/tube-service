import Foundation

public struct LineStatus: Codable, Hashable {
    public let statusSeverity: LineStatusSeverity?
    public let statusSeverityDescription: String?
    public let reason: String?
    public let disruption: Disruption?
    
    public init(
        statusSeverity: LineStatusSeverity?,
        statusSeverityDescription: String?,
        reason: String?,
        disruption: Disruption?
    ) {
        self.statusSeverity = statusSeverity
        self.statusSeverityDescription = statusSeverityDescription
        self.reason = reason
        self.disruption = disruption
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.statusSeverity = try container.decodeIfPresent(LineStatusSeverity.self, forKey: .statusSeverity)
        } catch {
            self.statusSeverity = .undefined
        }
        self.statusSeverityDescription = try container.decodeIfPresent(String.self, forKey: .statusSeverityDescription)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.disruption = try container.decodeIfPresent(Disruption.self, forKey: .disruption)
    }
}

extension LineStatus: Identifiable {
    public var id: String {
        "\(statusSeverity ?? .undefined)-\(statusSeverityDescription ?? "")-\(reason ?? "")-\(disruption?.description ?? "")"
    }
}

public enum LineStatusSeverity: Int, Codable {
    
    case specialService = 0
    case closed = 1
    case suspended = 2
    case partSuspended = 3
    case plannedClosure = 4
    case partClosure = 5
    case severeDelays = 6
    case reducedService = 7
    case busService = 8
    case minorDelays = 9
    case goodService = 10
    case partClosed = 11
    case exitOnly = 12
    case noStepFreeAccess = 13
    case changeOfFrequency = 14
    case diverted = 15
    case notRunning = 16
    case issuesReported = 17
    case noIssues = 18
    case information = 19
    case serviceClosed = 20
    case undefined = 999
}

public struct Disruption: Codable, Hashable {
    public let category: DisruptionCategory?
    public let description: String?
    public let additionalInfo: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.category = try container.decodeIfPresent(DisruptionCategory.self, forKey: .category)
        } catch {
            self.category = .undefined
        }
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.additionalInfo = try container.decodeIfPresent(String.self, forKey: .additionalInfo)
    }
}

public enum DisruptionCategory: String, Codable {
    case undefined = "Undefined"
    case realTime = "RealTime"
    case plannedWork = "PlannedWork"
    case information = "Information"
    case event = "Event"
    case crowding = "Crowding"
    case statusAlert = "StatusAlert"
}
