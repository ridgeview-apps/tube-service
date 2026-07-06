import Observation
import SwiftUI

extension View {

    @ViewBuilder
    func iOSAppOnMacSheetEnvironment<T: AnyObject & Observable>(_ object: T) -> some View {
        if ProcessInfo.processInfo.isiOSAppOnMac {
            environment(object)
        } else {
            self
        }
    }
}
