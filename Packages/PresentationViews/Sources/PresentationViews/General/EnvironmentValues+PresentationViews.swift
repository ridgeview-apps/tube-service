import Shared
import SwiftUI

extension EnvironmentValues {
    /// The app's clock. Views read `clock.now` rather than `Date.now`, so the app can fix the time (e.g. for UI tests).
    @Entry public var clock: AppClock = .live

    /// Stops content that changes on a timer, such as the rotating arrivals cell, so the screen stays the same while
    /// UI tests capture it.
    @Entry public var pausesTimedContent = false
}
