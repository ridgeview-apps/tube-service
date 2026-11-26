import Shared
import SwiftUI

/// The Station or Stop screen's toolbar button that opens its info sheet.
public struct StationInfoButton: View {
    let title: LocalizedStringResource
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.init(title: .stationInfoTitle, action: action)
    }

    public init(title: LocalizedStringResource, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Label {
                Text(title)
            } icon: {
                Image(systemName: "info.circle")
            }
        }
        .accessibilityIdentifier(AccessibilityID.StationArrivals.infoButton)
    }
}
