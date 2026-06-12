import Foundation

func loadJSON(named name: String, subdirectory: String) -> String {
    guard
        let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: subdirectory),
        let content = try? String(contentsOf: url, encoding: .utf8)
    else {
        fatalError("Missing JSON resource: \(subdirectory)/\(name).json")
    }
    return content
}
