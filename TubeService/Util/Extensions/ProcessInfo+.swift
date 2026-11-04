import Foundation
import Shared

// MARK: - ProcessInfo
extension ProcessInfo {
    static var isRunningUnitTests: Bool {
        ProcessInfo.processInfo.arguments.contains("-unit-tests")
    }

    static var isRunningUITests: Bool {
        ProcessInfo.processInfo.environment[TubeUITestLaunchConfiguration.environmentKey] != nil
    }
}
