import Models
import SwiftUI

public enum LineNotificationsButtonState: Sendable, Equatable {
    case locked
    case permissionDenied
    case notSetUp
    case paused
    case active
}

public struct LineNotificationsButton: View {

    let state: LineNotificationsButtonState
    let lineID: TrainLineID
    let onTap: () -> Void

    public init(state: LineNotificationsButtonState, lineID: TrainLineID, onTap: @escaping () -> Void) {
        self.state = state
        self.lineID = lineID
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .contentTransition(.symbolEffect(.replace))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(iconForegroundColor)
                    .frame(width: 36, height: 36)
                    .background(iconBackgroundColor, in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: accessoryIconName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(accessoryShapeStyle)
                    .accessibilityHidden(true)
            }
            .padding(16)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .cardStyle()
    }

    private var iconForegroundColor: Color {
        switch state {
        case .active: lineID.textColor
        case .permissionDenied, .paused: .white
        default: .secondary
        }
    }

    private var iconBackgroundColor: Color {
        switch state {
        case .active: lineID.backgroundColor
        case .permissionDenied, .paused: .orange
        default: Color(.tertiarySystemFill)
        }
    }

    private var iconName: String {
        switch state {
        case .locked: return "bell"
        case .permissionDenied: return "exclamationmark.triangle.fill"
        case .notSetUp: return "bell.slash"
        case .paused: return "bell.slash.fill"
        case .active: return "bell.badge.fill"
        }
    }

    private var accessoryIconName: String {
        switch state {
        case .locked: return "lock.fill"
        case .permissionDenied: return "arrow.up.forward.app"
        default: return "chevron.forward"
        }
    }

    private var accessoryShapeStyle: AnyShapeStyle {
        switch state {
        case .locked, .permissionDenied: return AnyShapeStyle(.secondary)
        default: return AnyShapeStyle(.tertiary)
        }
    }

    private var title: LocalizedStringResource {
        switch state {
        case .locked: return .notificationsButtonLockedTitle(lineID.longName)
        case .permissionDenied: return .lineStatusNotificationsPermissionDeniedTitle
        case .notSetUp: return .notificationsButtonLineInactiveTitle(lineID.longName)
        case .paused: return .notificationsButtonLinePausedTitle(lineID.longName)
        case .active: return .notificationsButtonLineActiveTitle(lineID.longName)
        }
    }

    private var subtitle: LocalizedStringResource {
        switch state {
        case .locked: return .notificationsButtonLockedSubtitle
        case .permissionDenied: return .lineStatusNotificationsPermissionDeniedSubtitle
        case .notSetUp: return .notificationsButtonLineInactiveSubtitle
        case .paused: return .notificationsButtonLinePausedSubtitle
        case .active: return .notificationsButtonLineActiveSubtitle
        }
    }
}


// MARK: - Previews

#Preview("Locked") {
    LineNotificationsButton(state: .locked, lineID: .victoria, onTap: {})
        .padding()
}

#Preview("Permission denied") {
    LineNotificationsButton(state: .permissionDenied, lineID: .victoria, onTap: {})
        .padding()
}

#Preview("Not set up") {
    LineNotificationsButton(state: .notSetUp, lineID: .victoria, onTap: {})
        .padding()
}

#Preview("Paused") {
    LineNotificationsButton(state: .paused, lineID: .victoria, onTap: {})
        .padding()
}

#Preview("Active") {
    LineNotificationsButton(state: .active, lineID: .victoria, onTap: {})
        .padding()
}
