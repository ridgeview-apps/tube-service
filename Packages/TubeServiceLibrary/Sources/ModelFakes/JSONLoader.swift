import Foundation

extension JSONDecoder {
    
    static func decodeModelJSON<D: Decodable>(from data: Data) -> D {
        guard let decodedValue = try? jsonDecoder.decode(D.self, from: data) else {
            fatalError()
        }
        return decodedValue
    }
}

private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}()
