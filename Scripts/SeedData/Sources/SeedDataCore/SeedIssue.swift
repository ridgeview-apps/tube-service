public struct SeedIssue: Equatable, Sendable, CustomStringConvertible {

    public enum Severity: Sendable {
        /// Stops the run before anything is written.
        case error
        case warning
    }

    public let severity: Severity
    public let message: String

    public static func error(_ message: String) -> SeedIssue {
        SeedIssue(severity: .error, message: message)
    }

    public static func warning(_ message: String) -> SeedIssue {
        SeedIssue(severity: .warning, message: message)
    }

    public var description: String {
        switch severity {
        case .error: "error: \(message)"
        case .warning: "warning: \(message)"
        }
    }
}
