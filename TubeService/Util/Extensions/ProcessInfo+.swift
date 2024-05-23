import Foundation

// MARK: - ProcessInfo
extension ProcessInfo {
    
    static var isRunningUITests: Bool {
        return ProcessInfo.processInfo.arguments.contains("UITests")
    }
}
