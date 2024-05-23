import Foundation
import Observation

@Observable
public final class ObservableTimer {
    public private(set) var firedAt: Date?
    public let timeInterval: TimeInterval
    
    private var timer: Timer?
    
    public init(timeInterval: TimeInterval,
                repeats: Bool) {
        self.timeInterval = timeInterval
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.firedAt = .now
        }
    }
    
    public static func repeating(every seconds: TimeInterval) -> ObservableTimer {
        .init(timeInterval: seconds, repeats: true)
    }
}
