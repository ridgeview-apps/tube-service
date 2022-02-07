import Foundation

struct InfoPlistValues {
    
    private let bundle: Bundle
    private let key: String?
    
    init(bundle: Bundle,
         key: String? = nil) {
        self.bundle = bundle
        self.key = key
    }
    
    private var infoDictionary: [String: Any]? {
        if let key = key {
            return bundle.infoDictionary?[key] as? [String: Any]
        } else {
            return bundle.infoDictionary
        }
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

extension Bundle {
    
    func infoPlistValues(forKey key: String? = nil) -> InfoPlistValues {
        .init(bundle: self, key: key)
    }
}
