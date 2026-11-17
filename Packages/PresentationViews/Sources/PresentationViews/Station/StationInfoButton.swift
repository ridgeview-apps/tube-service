import SwiftUI

/// The Station screen's toolbar button that opens the station info, with a dot when its notices need a look.
struct StationInfoButton: View {
    /// Orange while a closure is on today, even once seen; otherwise the accent colour (not the chips' red) marks
    /// unseen notices.
    enum Badge {
        case closureToday
        case unseen

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

    var body: some View {
        Button(action: action) {
            Label {
                Text(.stationInfoTitle)
            } icon: {
                StationInfoIcon(badge: badge)
            }
        }
        .accessibilityValue(badge?.accessibilityValue ?? Text(verbatim: ""))
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
