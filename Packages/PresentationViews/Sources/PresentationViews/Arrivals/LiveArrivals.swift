import Foundation
import Shared
import SwiftUI

/// Live boards for a Station or Stop screen.
public struct LiveArrivals {
    public let boardStates: [ArrivalsBoardState]
    public let refreshDate: Date?
    public let loadingState: LoadingState

    public init(boardStates: [ArrivalsBoardState], refreshDate: Date?, loadingState: LoadingState) {
        self.boardStates = boardStates
        self.refreshDate = refreshDate
        self.loadingState = loadingState
    }

    /// The update time, for the navigation bar's subtitle.
    public var lastUpdatedSubtitle: Text {
        guard let refreshDate else { return Text(verbatim: "") }
        return Text(.refreshStatusLastUpdated(Self.timeText(refreshDate)))
    }

    // Just the time: live arrivals are never from another day, so "today" adds nothing
    private static func timeText(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }
}
