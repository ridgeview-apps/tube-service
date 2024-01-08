import Foundation

struct FakeClock {
    var initialTime: Date
    var secondsOffset: TimeInterval = 0
    
    var currentTime: Date {
        initialTime + secondsOffset
    }
    
    mutating func addingSeconds(_ seconds: TimeInterval) {
        secondsOffset += seconds
    }
    
    mutating func addingMinutes(_ minutes: TimeInterval) {
        addingSeconds(minutes * 60)
    }
    
}
