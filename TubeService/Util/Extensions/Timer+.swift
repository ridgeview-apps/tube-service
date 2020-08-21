import Foundation
import Combine

extension Timer {
    
    static func autoconnectedPublisher(every seconds: TimeInterval) -> AnyPublisher<Date, Timer.TimerPublisher.Failure> {
        Timer
            .publish(every: seconds, on: .main, in: .common)
            .autoconnect()
            .eraseToAnyPublisher()
    }
    
}
