import Foundation

/// The accessibility identifiers UI tests find elements by. The app and PresentationViews set them and the UI tests
/// query them, so both sides share one spelling.
///
/// Identifiers that vary per row take the model's raw ID as a `String`, so the UI test target never needs model types.
public enum AccessibilityID {

    /// On iPhone, the tab bar's buttons only get these once the selected tab first changes (seen on iOS 27), so UI
    /// tests find iPhone tabs by position. The iPad sidebar has them from launch.
    public enum Tab {
        public static let lineStatus = "tab.lineStatus"
        public static let journeyPlanner = "tab.journeyPlanner"
        public static let arrivals = "tab.arrivals"
        public static let nearby = "tab.nearby"
        public static let maps = "tab.maps"
    }

    public enum FavouritesButton {
        /// The add/remove favourite button, by `FavouritesButton.Style` raw value (`small` or `large`).
        public static func button(_ style: String) -> String { "favouritesButton.\(style)" }
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
        public static let fromField = "journeyPlanner.fromField"
        public static let toField = "journeyPlanner.toField"
        public static let planMyJourneyButton = "journeyPlanner.planMyJourneyButton"
        /// Every recent journey row shares this; query with `firstMatch` or by index.
        public static let recentJourney = "journeyPlanner.recentJourney"
    }
    public enum JourneyLocationPicker {
        public static let list = "journeyLocationPicker.list"
        public static let searchField = "journeyLocationPicker.searchField"
        /// Every search result row shares this; query with `firstMatch` or by index. Suggestions don't have it, so a
        /// test can wait for the results to replace them.
        public static let searchResult = "journeyLocationPicker.searchResult"
    }

    public enum JourneyResults {
        public static let content = "journeyResults.content"
        /// A journey's card, which expands when tapped. Every journey shares this; query with `firstMatch` or by index.
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
