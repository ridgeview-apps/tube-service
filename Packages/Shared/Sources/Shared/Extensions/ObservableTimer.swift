import Foundation
import Observation

@MainActor
@Observable
public final class ObservableTimer {
    public private(set) var firedAt: Date?
    public let timeInterval: TimeInterval

    private var timer: Timer?

    public init(
        timeInterval: TimeInterval,
        repeats: Bool
    ) {
        self.timeInterval = timeInterval
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.firedAt = .now
            }
        }
    }

    isolated deinit {
        timer?.invalidate()
    }

    public func invalidate() {
        timer?.invalidate()
    }

    public static func repeating(every seconds: TimeInterval) -> ObservableTimer {
        .init(timeInterval: seconds, repeats: true)
    }
}
