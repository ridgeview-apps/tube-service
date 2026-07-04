import Foundation

public extension FloatingPoint {

    // Swift Testing workaround until it supports floating point accuracy expectations
    // (i.e. equivalent of XCTAssertEqual(accuracy:) is not currently supported)
    func isApproximatelyEqual(to other: Self, plusOrMinus tolerance: Self) -> Bool {
        precondition(tolerance >= 0, "Tolerance must be non-negative")
        return abs(self - other) <= tolerance
    }
}
