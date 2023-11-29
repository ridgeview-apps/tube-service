import Foundation

private class BundlePin {}

public extension Bundle {
    static func loadJSONFile(named filename: String) -> Data {
        let url = Bundle(for: BundlePin.self).url(forResource: filename, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static func loadStopPoints(from jsonFile: String) -> [StopPoint] {
        let data = loadJSONFile(named: jsonFile)
        return try! JSONDecoder().decode([StopPoint].self, from: data)
    }
}

private let prettyPrintedEncoder: JSONEncoder = {
    var encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    return encoder
}()

public extension JSONEncoder {
    static func prettyPrintedValue<E: Encodable>(for encodable: E) -> String {
        do {
            let encodedData = try prettyPrintedEncoder.encode(encodable)
            guard let jsonString = String(data: encodedData, encoding: .utf8) else {
                return "<String encoding failure>"
            }
            return jsonString
        } catch {
            return "JSON Encoding error \(error.localizedDescription)"
        }
    }
}

public extension String {
    
    var isBlank: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
