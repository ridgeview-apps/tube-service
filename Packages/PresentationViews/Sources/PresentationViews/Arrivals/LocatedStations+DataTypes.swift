import Models
import SwiftUI


// MARK: - Data types

public struct LocatedStationsResultsSectionState: Sendable {

    public var stations: [LocatedStation]
    public let pageSize: Int
    public var currentPageNo: Int

    public init(
        stations: [LocatedStation],
        pageSize: Int = 5,
        currentPageNo: Int = 1
    ) {
        self.stations = stations
        self.pageSize = pageSize
        self.currentPageNo = currentPageNo
    }

    public static let empty = LocatedStationsResultsSectionState(stations: [])
}
