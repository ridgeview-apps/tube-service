import Foundation

struct StringLocalizer {
    typealias LocalizedStringKey = String
    typealias LocalizedStringvalue = String
    let localized: (LocalizedStringKey) -> LocalizedStringvalue    
}

// MARK: - Real instance
extension StringLocalizer {
    
    static let real = StringLocalizer { key in NSLocalizedString(key, comment: "") }
    
}

// MARK: - Fake instance
#if DEBUG
extension StringLocalizer {
    
    static let fake: Self = StringLocalizer { key in key }
}
#endif
