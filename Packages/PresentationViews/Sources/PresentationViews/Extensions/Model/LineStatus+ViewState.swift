import Models

extension Sequence where Element == LineStatus {
    
    func sortedByStatusSeverity() -> [LineStatus] {
        self.sorted {
            ($0.statusSeverity).rawValue < ($1.statusSeverity).rawValue
        }
    }
}
