import Foundation

extension JSONDecoder {
    
    static func decodeModelJSON<D: Decodable>(from data: Data) -> D {
        guard let decodedValue = try? JSONDecoder().decode(D.self, from: data) else {
            fatalError()
        }
        return decodedValue
    }
}
