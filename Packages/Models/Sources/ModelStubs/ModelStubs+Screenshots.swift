import Foundation
import Models

public extension ModelStubs {

    /// TfL responses for App Store screenshots, all dated around 08:41 on Friday 12 June 2026 in London (the UI tests'
    /// fixed clock): a few disruptions today, weekend closures on 13–14 June, King's Cross and Abbey Wood arrivals,
    /// and journeys from King's Cross to Waterloo.
    ///
    /// These are copies, kept apart from the unit tests' stubs so that changing a test never changes a screenshot.
    /// They were made by moving every timestamp in a real response by the same amount, which keeps relative timings
    /// (a train due in 3 minutes is still due in 3 minutes). Line statuses moved by whole weeks so weekend closures
    /// stay on a weekend. TfL's "no date" placeholders (0001-01-01T00:00:00) were left alone. Journey planner times are
    /// London local time without a "Z"; the rest are UTC.
    enum Screenshots {
        public static let lineStatusesToday: [Line] = load("lineStatusesToday")
        public static let lineStatusesFuture: [Line] = load("lineStatusesFuture")
        /// Every tube line at King's Cross St. Pancras (940GZZLUKSX).
        public static let kingsCrossArrivals: [ArrivalPrediction] = load("kingsCrossArrivals")
        /// Elizabeth line at Abbey Wood (910GABWDXR).
        public static let abbeyWoodDepartures: [ArrivalDeparture] = load("abbeyWoodDepartures")
        public static let disruptedStations: [DisruptedPoint] = load("disruptedStations")
        public static let journeyResults: JourneyResults = load("journeyResultsKingsXToWaterlooNow")

        // Resources are flattened into one bundle, so the prefix keeps these apart from the unit tests' files.
        private static func load<D: Decodable>(_ name: String) -> D {
            decodedValue(for: loadJSON(named: "Screenshots-\(name)"))
        }
    }
}
