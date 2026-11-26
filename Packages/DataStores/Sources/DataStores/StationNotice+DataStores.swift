import Models

extension Sequence where Element == StationNotice {

    /// Closures first, without repeats.
    func prioritised() -> [StationNotice] {
        var notices = [StationNotice]()
        // Sorted before removing duplicates, so a duplicate keeps its highest priority
        for notice in sorted(by: { $0.priority < $1.priority }) where !notices.contains(where: { $0.text == notice.text }) {
            notices.append(notice)
        }
        return notices
    }
}
