import Foundation

public extension FloatingPoint {
    
    // Swift Testing workaround until it supports floating point accuracy expectations
    // (i.e. equivalent of XCTAssertEqual(accuracy:) is not currently supported)
    func isApproximatelyEqual(to other: Self, plusOrMinus tolerance: Self) -> Bool {
        let max = other + tolerance
        let min = other - tolerance
        return (min...max).contains(self)
    }
}
