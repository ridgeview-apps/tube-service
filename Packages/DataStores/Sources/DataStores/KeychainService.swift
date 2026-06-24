import Foundation
import Security

// MARK: - Protocol

public protocol KeychainService: Sendable {
    func read(key: String) -> String?
    @discardableResult func write(key: String, value: String) -> Bool
    func delete(key: String)
}


// MARK: - Security framework implementation

public struct SecurityKeychain: KeychainService {

    private let service: String

    public init(service: String) {
        self.service = service
    }

    public func read(key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
            let data = result as? Data
        else { return nil }
        return String(data: data, encoding: .utf8)
    }

    @discardableResult
    public func write(key: String, value: String) -> Bool {
        let attributes: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecValueData: Data(value.utf8)
        ]
        SecItemDelete(attributes as CFDictionary)
        return SecItemAdd(attributes as CFDictionary, nil) == errSecSuccess
    }

    public func delete(key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
