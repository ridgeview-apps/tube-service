import Foundation

// MARK: - ProcessInfo
extension ProcessInfo {
    static var isRunningUnitTests: Bool {
        ProcessInfo.processInfo.arguments.contains("-unit-tests")
    }
    
    static var isRunningUITests: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui-tests")
    }
}
