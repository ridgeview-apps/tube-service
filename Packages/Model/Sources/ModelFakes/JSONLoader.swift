import Foundation

enum JSONLoader {
    
    static func loadJSON<D: Decodable>(from fileName: String) -> D {
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decodedValue = try? JSONDecoder().decode(D.self, from: data) else {
                fatalError()
        }
        
        return decodedValue
    }
}
