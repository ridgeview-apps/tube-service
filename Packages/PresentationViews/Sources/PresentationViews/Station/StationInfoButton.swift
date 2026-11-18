import Shared
import SwiftUI

/// The Station screen's toolbar button that opens the station info.
public struct StationInfoButton: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Label {
                Text(.stationInfoTitle)
            } icon: {
                Image(systemName: "info.circle")
            }
        }
        .accessibilityIdentifier(AccessibilityID.StationArrivals.infoButton)
    }
}
