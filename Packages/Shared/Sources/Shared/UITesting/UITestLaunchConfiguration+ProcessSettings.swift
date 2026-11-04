import Foundation
import UIKit

public extension UITestLaunchConfiguration {

    /// Applies the settings that affect the whole app process. Call once at launch, before any views appear.
    @MainActor
    func applyProcessSettings() {
        // The launch environment also sets `TZ`; setting the default time zone here doesn't rely on Foundation
        // picking that up.
        if let timeZone = TimeZone(identifier: timeZoneIdentifier) {
            NSTimeZone.default = timeZone
        }
        if disablesAnimations {
            UIView.setAnimationsEnabled(false)
        }
    }
}
