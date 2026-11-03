import Foundation

public extension UserDefaults {

    /// A suite that's emptied every time it's requested, so each UI test launch starts from the same state rather
    /// than whatever the previous run left behind.
    static func emptiedUITestSuite(named name: String) -> UserDefaults {
        guard let defaults = UserDefaults(suiteName: name) else {
            preconditionFailure("Can't create a UserDefaults suite named \(name)")
        }
        defaults.removePersistentDomain(forName: name)
        return defaults
    }
}
