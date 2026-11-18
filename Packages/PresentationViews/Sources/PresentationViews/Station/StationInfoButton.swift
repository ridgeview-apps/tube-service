import Shared
import SwiftUI

/// The Station screen's toolbar button that opens the station info, with a dot when its notices need a look.
public struct StationInfoButton: View {
    /// Orange while a closure is on today, even once seen; otherwise the accent colour (not the chips' red) marks
    /// unseen notices.
    public enum Badge {
        case closureToday
        case unseen

        /// `nil` when no notice needs a look.
        public init?(info: StationInfo, stationName: String, now: Date) {
            let noticeSections = StationNoticeSections(notices: info.notices, stationName: stationName, now: now)
            if noticeSections.hasClosureToday {
                self = .closureToday
            } else if info.hasUnseenNotices {
                self = .unseen
            } else {
                return nil
            }
        }

        var style: AnyShapeStyle {
            switch self {
            case .closureToday: AnyShapeStyle(.orange)
            case .unseen: AnyShapeStyle(.tint)
            }
        }

        var accessibilityValue: Text {
            switch self {
            case .closureToday: Text(.stationNoticesClosureAccessibilityValue)
            case .unseen: Text(.stationNoticesUnseenAccessibilityValue)
            }
        }
    }

    let badge: Badge?
    let action: () -> Void

    public init(badge: Badge?, action: @escaping () -> Void) {
        self.badge = badge
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Label {
                Text(.stationInfoTitle)
            } icon: {
                StationInfoIcon(badge: badge)
            }
        }
        .accessibilityValue(badge?.accessibilityValue ?? Text(verbatim: ""))
        .accessibilityIdentifier(AccessibilityID.StationArrivals.infoButton)
    }
}

private struct StationInfoIcon: View {
    let badge: StationInfoButton.Badge?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if let badge {
            Image(systemName: "info.circle.badge")
                .symbolRenderingMode(.palette)
                // The toolbar fixes palette colours when it takes the image, so even adaptive colours stay
                // light-mode; picking from the colour scheme redraws it on each change
                .foregroundStyle(badge.style, colorScheme == .dark ? Color.white : Color.black)
        } else {
            Image(systemName: "info.circle")
        }
    }
}
