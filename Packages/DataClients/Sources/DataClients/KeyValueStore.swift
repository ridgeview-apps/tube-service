import Foundation

public struct KeyValueStore {
    public typealias Key = String
    public typealias Value = Any
    public struct KeyValuePair {
        let key: Key
        let value: Value?
    }
    public let get: (Key) -> Value?
    public let set: (KeyValuePair) -> Void
}

// MARK: - Real instance
public extension KeyValueStore {
    
    private static let standardDefaults = UserDefaults.standard
    static let real = KeyValueStore(
        get: { key -> Any? in
            standardDefaults.object(forKey: key)
        },
        set: { pair in
            standardDefaults.set(pair.value, forKey: pair.key)
        }
    )
}

// MARK: - Fake instance
#if DEBUG
public extension KeyValueStore {
    
    private static var inMemoryStorage =  [String: Any]()
    static let fake = KeyValueStore(
        get: { key -> Any? in
            inMemoryStorage[key]
        },
        set: { pair in
            inMemoryStorage[pair.key] = pair.value
        }
    )
}
#endif
