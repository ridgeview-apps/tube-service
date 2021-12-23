import Foundation

// MARK: - NSError
public extension NSError {
    
    enum FakeType {
        case unexpectedError
        case noInternet
    }
    
    static func fake(ofType fakeType: FakeType) -> NSError {
        
        switch fakeType {
        case .unexpectedError:
            return .fake(message: "An unexpected error occurred")
        case .noInternet:
            return .fake(message: "No internet connection")
        }
    }
    
    static func fake(domain: String = "com.fake.error",
                     code: Int = -123,
                     message: String) -> NSError {
        NSError(domain: domain,
                code: code,
                userInfo: [NSLocalizedDescriptionKey: message])
    }
}
