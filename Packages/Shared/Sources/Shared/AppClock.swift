import Foundation

/// The app's clock: the real time, or a fixed time so UI tests always show the same screens.
///
/// A value rather than a `() -> Date` closure so SwiftUI can compare it when it's in the environment. Closures can't be
/// compared, so every environment update would re-evaluate the views that read one.
public struct AppClock: Sendable {

    private let fixedDate: Date?

    public static let live = AppClock(fixedDate: nil)

    public static func fixed(at date: Date) -> AppClock {
        AppClock(fixedDate: date)
    }

    /// The current time, or the fixed time.
    public var now: Date {
        fixedDate ?? .now
    }
}
