import Foundation

// MARK: - ProcessInfo
extension ProcessInfo {
    
    static var isRunningUITests: Bool {
        #if DEBUG
            return ProcessInfo.processInfo.arguments.contains("UITests")
        #else
            return false
        #endif
    }
}
