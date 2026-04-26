import Models

extension Sequence where Element == LineStatus {
    
    func sortedByStatusSeverity() -> [LineStatus] {
        self.sorted {
            ($0.statusSeverity ?? .ignored).rawValue < ($1.statusSeverity ?? .ignored).rawValue
        }
    }
}
