import Foundation

public extension JSONDecoder {
    
    static let defaultModelDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
