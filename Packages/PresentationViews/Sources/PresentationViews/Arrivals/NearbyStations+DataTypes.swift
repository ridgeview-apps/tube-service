import Models
import SwiftUI


// MARK: - Data types

public struct NearbyStationsResultsSectionState {

    public var nearbyStations: [NearbyStation]
    public let pageSize: Int
    public var currentPageNo: Int
    
    public init(nearbyStations: [NearbyStation],
                pageSize: Int = 5,
                currentPageNo: Int = 1) {
        self.nearbyStations = nearbyStations
        self.pageSize = pageSize
        self.currentPageNo = currentPageNo
    }
    
    public static var empty: Self {
        .init(nearbyStations: [])
    }
    
    public mutating func resetPageNo() {
        currentPageNo = 1
    }
}
