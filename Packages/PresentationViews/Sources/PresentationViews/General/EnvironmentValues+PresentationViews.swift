import SwiftUI

extension EnvironmentValues {
    /// The current time. Views read this rather than `Date.now` so the app can supply a fixed clock (e.g. UI tests).
    @Entry public var now: @Sendable () -> Date = { .now }

    /// Stops content that changes on a timer, such as the rotating arrivals cell, so the screen stays the same while
    /// UI tests capture it.
    @Entry public var pausesTimedContent = false
}
