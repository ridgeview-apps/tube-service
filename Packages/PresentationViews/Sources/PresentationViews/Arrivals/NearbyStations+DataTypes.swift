import Models
import SwiftUI


// MARK: - Data types

public struct NearbyStationsResultsSectionState {

    public var loadingState: LoadingState
    public var nearbyStations: [NearbyStation]
    public let headerTitle: LocalizedStringKey?
    public let pageSize: Int
    public var currentPageNo: Int
    
    public init(loadingState: LoadingState,
                nearbyStations: [NearbyStation],
                headerTitle: LocalizedStringKey? = nil,
                pageSize: Int = 5,
                currentPageNo: Int = 1) {
        self.loadingState = loadingState
        self.nearbyStations = nearbyStations
        self.headerTitle = headerTitle
        self.pageSize = pageSize
        self.currentPageNo = currentPageNo
    }
    
    public static var empty: Self {
        .init(loadingState: .loaded, nearbyStations: [])
    }
    
    public mutating func resetPageNo() {
        currentPageNo = 1
    }
}
