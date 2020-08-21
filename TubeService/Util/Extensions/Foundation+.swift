import Foundation

// MARK: - TimeInterval
extension TimeInterval {
    
    static func seconds(_ seconds: Int) -> TimeInterval {
        TimeInterval(seconds)
    }
    
    static func minutes(_ minutes: Int) -> TimeInterval {
        TimeInterval(minutes * 60)
    }
    
    static func hours(_ hours: Int) -> TimeInterval {
        TimeInterval(hours * 60 * 60)
    }
}

// MARK: - Int
extension Int {
    
    var seconds: TimeInterval {
        TimeInterval.seconds(self)
    }
    
    var minutes: TimeInterval {
        TimeInterval.minutes(self)
    }
    
    var hours: TimeInterval {
        TimeInterval.hours(self)
    }
}

// MARK: - Double
extension Double {
    var intValue: Int {
        Int(self)
    }
}

// MARK: - String
extension String {
    
    mutating func trim() {
        self = self.trimmed()
    }
    
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - ProcessInfo
extension ProcessInfo {
    
    static var launchMode: AppLaunchMode {
        #if DEBUG
            if let launchModeString = self.processInfo.environment["APP_LAUNCH_MODE"],
               let launchMode = AppLaunchMode(rawValue: launchModeString) {
                return launchMode
            }
        #endif
        
        return .normal
    }
}
