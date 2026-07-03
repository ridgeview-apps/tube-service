import Models
import SwiftUI

public enum LineNotificationsButtonState: Sendable, Equatable {
    case locked
    case notSetUp
    case permissionDenied
    case inactive
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
        case .permissionDenied: return .orange
        case .locked, .notSetUp, .inactive, .active: return lineID.backgroundColor
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
        case .locked, .notSetUp: return .notificationsButtonLineNotSetUpTitle(lineID.longName)
        case .permissionDenied: return .lineStatusNotificationsPermissionDeniedTitle
        case .inactive: return .notificationsButtonLineInactiveTitle(lineID.longName)
        case .active: return .notificationsButtonLineActiveTitle(lineID.longName)
        }
    }

    private var subtitle: LocalizedStringResource {
        switch state {
        case .locked: return .notificationsButtonLockedSubtitle
        case .notSetUp: return .notificationsButtonLineNotSetUpSubtitle
        case .permissionDenied: return .lineStatusNotificationsPermissionDeniedSubtitle
        case .inactive: return .notificationsButtonLineInactiveSubtitle
        case .active: return .notificationsButtonLineActiveSubtitle
        }
    }
}


// MARK: - Previews

#Preview("Not set up") {
    LineNotificationsButton(state: .notSetUp, lineID: .victoria, onTap: {})
        .padding()
}

#Preview("Locked") {
    LineNotificationsButton(state: .locked, lineID: .victoria, onTap: {})
        .padding()
}

#Preview("Permission denied") {
    LineNotificationsButton(state: .permissionDenied, lineID: .victoria, onTap: {})
        .padding()
}

#Preview("Inactive") {
    LineNotificationsButton(state: .inactive, lineID: .victoria, onTap: {})
        .padding()
}

#Preview("Active") {
    LineNotificationsButton(state: .active, lineID: .victoria, onTap: {})
        .padding()
}
