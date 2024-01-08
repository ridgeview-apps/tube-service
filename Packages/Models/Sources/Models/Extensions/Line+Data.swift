import Foundation

public extension Line {
    var isDisrupted: Bool {
        (lineStatuses ?? []).contains { $0.isDisrupted }
    }
}
