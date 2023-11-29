import Foundation

// MARK: - ProcessInfo
extension ProcessInfo {
    
    static var isRunningUITests: Bool {
        ProcessInfo.processInfo.arguments.contains("UITests")
    }
}
