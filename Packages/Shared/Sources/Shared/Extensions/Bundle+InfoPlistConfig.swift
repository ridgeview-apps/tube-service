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
    
    func loadInfoPlistConfig(forKey key: String) -> InfoPlistConfig {
        guard let infoDictionary = infoDictionary?[key] as? [String: Any] else {
            fatalError("Unable to load \(key) key from info.plist file")
        }
        return InfoPlistConfig(infoDictionary: infoDictionary)
    }
}
