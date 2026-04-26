import Models

extension Sequence where Element == LineStatus {

    func sortedByStatusSeverity() -> [LineStatus] {
        sorted {
            ($0.statusSeveritySortValue < $1.statusSeveritySortValue)
        }
    }
}

extension LineStatus {
    fileprivate var statusSeveritySortValue: Int {
        statusSeverity?.rawValue ?? 999
    }
}
