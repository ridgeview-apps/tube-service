import Foundation

/// The accessibility identifiers UI tests find elements by. The app and PresentationViews set them and the UI tests
/// query them, so both sides share one spelling.
///
/// Identifiers that vary per row take the model's raw ID as a `String`, so the UI test target never needs model types.
public enum AccessibilityID {

    public enum Tab {
        public static let lineStatus = "tab.lineStatus"
        public static let journeyPlanner = "tab.journeyPlanner"
        public static let arrivals = "tab.arrivals"
        public static let nearby = "tab.nearby"
        public static let maps = "tab.maps"
    }

    public enum LineStatus {
        public static let list = "lineStatus.list"
        public static let filterToday = "lineStatus.filter.today"
        public static let filterTomorrow = "lineStatus.filter.tomorrow"
        public static let filterThisWeekend = "lineStatus.filter.thisWeekend"
        public static let filterFuture = "lineStatus.filter.future"

        /// A line's row, by `TrainLineID` raw value.
        public static func line(_ lineID: String) -> String { "lineStatus.line.\(lineID)" }
    }

    public enum LineStatusDetail {
        public static let content = "lineStatusDetail.content"
    }

    public enum JourneyPlanner {
        public static let form = "journeyPlanner.form"
        /// Every recent journey row shares this; query with `firstMatch` or by index.
        public static let recentJourney = "journeyPlanner.recentJourney"
    }

    public enum JourneyResults {
        public static let content = "journeyResults.content"
        /// A journey's times row, which expands it. Every journey shares this; query with `firstMatch` or by index.
        public static let journey = "journeyResults.journey"
        /// The button that shows a leg's stops. Every leg with stops shares this.
        public static let stopsToggle = "journeyResults.stopsToggle"
    }

    public enum ArrivalsPicker {
        public static let list = "arrivalsPicker.list"

        /// A station row that expands to its line groups, by `Station` ID.
        public static func station(_ stationID: String) -> String { "arrivalsPicker.station.\(stationID)" }
        /// A line group row that opens its arrivals board, by `Station.LineGroup` ID.
        public static func lineGroup(_ lineGroupID: String) -> String { "arrivalsPicker.lineGroup.\(lineGroupID)" }
    }

    public enum ArrivalsBoard {
        public static let content = "arrivalsBoard.content"
    }

    public enum Nearby {
        public static let list = "nearby.list"

        /// A nearby station row, by `Station` ID.
        public static func station(_ stationID: String) -> String { "nearby.station.\(stationID)" }
    }

    public enum Station {
        public static let content = "station.content"
    }

    public enum Maps {
        public static let list = "maps.list"
    }
}
