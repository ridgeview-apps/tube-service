import Models

/// A station's line statuses and notices, shown on its arrivals screen and in its info sheet.
public struct StationInfo {
    /// The status of every line at the station.
    public let lines: [Line]
    /// Closures first, and none that have ended.
    public let notices: [StationNotice]
    /// True until the line statuses first arrive or fail to load.
    public let isLoadingLines: Bool
    /// Whether any notice hasn't been opened yet, which puts a dot on the notices button.
    public let hasUnseenNotices: Bool

    public init(lines: [Line], notices: [StationNotice], isLoadingLines: Bool = false, hasUnseenNotices: Bool = false) {
        self.lines = lines
        self.notices = notices
        self.isLoadingLines = isLoadingLines
        self.hasUnseenNotices = hasUnseenNotices
    }
}
