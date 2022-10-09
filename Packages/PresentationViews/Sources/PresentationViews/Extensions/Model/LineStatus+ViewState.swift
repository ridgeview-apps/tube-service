import Models

extension Sequence where Element == LineStatus {
    
    func sortedByStatusSeverity() -> [LineStatus] {
        self.sorted {
            ($0.statusSeverity ?? .undefined).rawValue < ($1.statusSeverity ?? .undefined).rawValue
        }
    }
}

extension LineStatus {
    
    var isDisrupted: Bool {
        self.statusSeverity != .goodService
    }
}
