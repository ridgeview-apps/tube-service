import Models
import SwiftUI

public enum NotificationsButtonState: Sendable, Equatable {
    case locked
    case notSetUp
    case permissionDenied
    case inactive
    case active
}

public struct NotificationsButton: View {

    public enum Context: Sendable {
        case lineStatus(TrainLineID)
        case settings
    }

    let state: NotificationsButtonState
    let context: Context
    let onTap: () -> Void

    public init(state: NotificationsButtonState, context: Context, onTap: @escaping () -> Void) {
        self.state = state
        self.context = context
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .contentTransition(.symbolEffect(.replace))
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(iconColor)
                    .frame(width: 36)

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

    private var iconColor: Color {
        switch state {
        case .permissionDenied:
            return .orange
        case .locked, .notSetUp, .inactive, .active:
            switch context {
            case .lineStatus(let lineID): return lineID.backgroundColor
            case .settings: return .accentColor
            }
        }
    }

    private var iconName: String {
        switch state {
        case .locked, .notSetUp: return "bell"
        case .permissionDenied: return "exclamationmark.triangle.fill"
        case .inactive: return "bell.slash"
        case .active: return "bell.fill"
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
        case .locked, .notSetUp:
            switch context {
            case .lineStatus(let lineID): return .notificationsButtonLineNotSetUpTitle(lineID.longName)
            case .settings: return .notificationsButtonSettingsNotSetUpTitle
            }
        case .permissionDenied:
            return .lineStatusNotificationsPermissionDeniedTitle
        case .inactive:
            switch context {
            case .lineStatus(let lineID): return .notificationsButtonLineInactiveTitle(lineID.longName)
            case .settings: return .notificationsButtonSettingsNotSetUpTitle
            }
        case .active:
            switch context {
            case .lineStatus(let lineID): return .notificationsButtonLineActiveTitle(lineID.longName)
            case .settings: return .notificationsButtonSettingsActiveTitle
            }
        }
    }

    private var subtitle: LocalizedStringResource {
        switch state {
        case .locked:
            return .notificationsButtonLockedSubtitle
        case .notSetUp:
            switch context {
            case .lineStatus: return .notificationsButtonLineNotSetUpSubtitle
            case .settings: return .notificationsButtonSettingsNotSetUpSubtitle
            }
        case .permissionDenied:
            return .lineStatusNotificationsPermissionDeniedSubtitle
        case .inactive:
            switch context {
            case .lineStatus: return .notificationsButtonLineInactiveSubtitle
            case .settings: return .notificationsButtonSettingsNotSetUpSubtitle
            }
        case .active:
            switch context {
            case .lineStatus: return .notificationsButtonLineActiveSubtitle
            case .settings: return .notificationsButtonSettingsActiveSubtitle
            }
        }
    }
}


// MARK: - Previews

#Preview("Not set up — line") {
    NotificationsButton(
        state: .notSetUp,
        context: .lineStatus(.victoria),
        onTap: {}
    )
    .padding()
}

#Preview("Locked — line") {
    NotificationsButton(
        state: .locked,
        context: .lineStatus(.victoria),
        onTap: {}
    )
    .padding()
}

#Preview("Permission denied — line") {
    NotificationsButton(
        state: .permissionDenied,
        context: .lineStatus(.victoria),
        onTap: {}
    )
    .padding()
}

#Preview("Inactive — line") {
    NotificationsButton(
        state: .inactive,
        context: .lineStatus(.victoria),
        onTap: {}
    )
    .padding()
}

#Preview("Active — line") {
    NotificationsButton(
        state: .active,
        context: .lineStatus(.victoria),
        onTap: {}
    )
    .padding()
}

#Preview("Not set up — settings") {
    NotificationsButton(state: .notSetUp, context: .settings, onTap: {})
        .padding()
}

#Preview("Locked — settings") {
    NotificationsButton(state: .locked, context: .settings, onTap: {})
        .padding()
}

#Preview("Active — settings") {
    NotificationsButton(state: .active, context: .settings, onTap: {})
        .padding()
}

#Preview("Inactive — settings") {
    NotificationsButton(state: .inactive, context: .settings, onTap: {})
        .padding()
}
