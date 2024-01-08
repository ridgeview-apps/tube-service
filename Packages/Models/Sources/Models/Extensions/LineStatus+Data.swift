import Foundation

public extension LineStatus {
    
    var isDisrupted: Bool {
        self.statusSeverity != .goodService
    }
}
