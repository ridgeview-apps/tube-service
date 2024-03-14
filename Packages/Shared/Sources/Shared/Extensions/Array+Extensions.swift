import Foundation


public extension Array where Element: Hashable {
    
    // See: https://stackoverflow.com/questions/25738817/removing-duplicate-elements-from-an-array-in-swift
    // Convenient way of removing duplicates from an array (AND preserve the order)
    func removingDuplicates() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
