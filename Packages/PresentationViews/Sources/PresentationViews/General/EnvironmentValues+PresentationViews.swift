import Shared
import SwiftUI

extension EnvironmentValues {
    /// The app's clock. Views read `clock.now` rather than `Date.now`, so the app can fix the time (e.g. for UI tests).
    @Entry public var clock: AppClock = .live

    /// Stops animations that repeat indefinitely, such as the rotating arrivals cell and the pulsing Live symbol, so the
    /// screen settles while UI tests capture it.
    @Entry public var pausesRepeatingAnimations = false
}
