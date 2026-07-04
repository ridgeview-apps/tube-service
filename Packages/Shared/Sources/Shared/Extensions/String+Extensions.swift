import Foundation

public extension String {

    mutating func trim() {
        self = self.trimmed()
    }

    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
