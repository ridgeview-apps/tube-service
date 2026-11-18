import Models

/// A station's line statuses and notices, shown in its info sheet.
public struct StationInfo {
    /// The status of every line at the station.
    public let lines: [Line]
    /// True until the line statuses first arrive or fail to load.
    public let isLoadingLines: Bool
    /// Closures first, and none that have ended; nil until they first arrive.
    public let notices: [StationNotice]?
    /// True until the notices first arrive or fail to load.
    public let isLoadingNotices: Bool

    public init(lines: [Line], isLoadingLines: Bool = false, notices: [StationNotice]?, isLoadingNotices: Bool = false) {
        self.lines = lines
        self.isLoadingLines = isLoadingLines
        self.notices = notices
        self.isLoadingNotices = isLoadingNotices
    }
}
