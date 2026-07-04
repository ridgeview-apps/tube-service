import Foundation

public struct InfoPlistConfig {
    public let infoDictionary: [String: Any]?

    public init(infoDictionary: [String: Any]?) {
        self.infoDictionary = infoDictionary
    }

    public subscript(safe key: String) -> String? {
        infoDictionary?[key] as? String
    }

    public subscript(_ key: String) -> String {
        self[safe: key]!
    }

    public subscript(safeURL key: String) -> URL? {
        guard let stringValue = self[safe: key] else {
            return nil
        }
        return URL(string: stringValue)
    }

    public subscript(url key: String) -> URL {
        self[safeURL: key]!
    }
}

public extension Bundle {

    func infoPlistConfig(forKey key: String) -> InfoPlistConfig {
        guard let infoDictionary = infoDictionary?[key] as? [String: Any] else {
            fatalError("Unable to load \(key) key from info.plist file")
        }
        return InfoPlistConfig(infoDictionary: infoDictionary)
    }

    var appVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var appBuildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }

    var appVersionDisplayString: String? {
        switch (appVersion, appBuildNumber) {
        case let (version?, build?):
            "\(version) (\(build))"
        case let (version?, nil):
            version
        case let (nil, build?):
            build
        case (nil, nil):
            nil
        }
    }

    var appName: String? {
        infoDictionary?["CFBundleName"] as? String
            ?? infoDictionary?["CFBundleDisplayName"] as? String
    }
}
