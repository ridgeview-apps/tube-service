import SwiftUI

extension EnvironmentValues {
    /// The current time. Views read this rather than `Date.now` so the app can supply a fixed clock (e.g. UI tests).
    @Entry public var now: @Sendable () -> Date = { .now }
}
