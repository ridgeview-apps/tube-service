import Foundation

func loadJSON(named name: String) -> String {
    guard
        let url = Bundle.module.url(forResource: name, withExtension: "json"),
        let content = try? String(contentsOf: url, encoding: .utf8)
    else {
        fatalError("Missing JSON resource: \(name).json")
    }
    return content
}
