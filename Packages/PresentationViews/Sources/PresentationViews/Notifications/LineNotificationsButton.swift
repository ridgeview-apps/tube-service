import SwiftUI

public enum LineNotificationsButtonState: Sendable, Equatable {
    case locked
    case permissionDenied
    case notSetUp
    case paused
    case active
}

public struct LineNotificationsButton: View {

    public enum Action: Sendable {
        /// The row itself, or the menu's Edit item, was tapped.
        case tapped
        case setPaused(Bool)
    }

    let state: LineNotificationsButtonState
    let isSaving: Bool
    let onAction: (Action) -> Void

    public init(
        state: LineNotificationsButtonState,
        isSaving: Bool = false,
        onAction: @escaping (Action) -> Void
    ) {
        self.state = state
        self.isSaving = isSaving
        self.onAction = onAction
    }

    /// Only lines with notifications set up can be paused or resumed from the row.
    private var showsActionsMenu: Bool {
        state == .active || state == .paused
    }

    public var body: some View {
        HStack(spacing: 0) {
            Button {
                onAction(.tapped)
            } label: {
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

                    if !showsActionsMenu {
                        Image(systemName: accessoryIconName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(accessoryShapeStyle)
                            .accessibilityHidden(true)
                    }
                }
                .padding(.vertical, 16)
                .padding(.leading, 16)
                .padding(.trailing, showsActionsMenu ? 0 : 16)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)

            if showsActionsMenu {
                actionsMenu
            }
        }
        // Blocks the row as well as the menu: opening the edit sheet mid-save would drop its own save.
        .disabled(isSaving)
        .cardStyle()
    }

    // MARK: - Actions Menu

    private var actionsMenu: some View {
        Menu {
            Button {
                onAction(.setPaused(state == .active))
            } label: {
                if state == .active {
                    Label {
                        Text(.notificationsLineConfigMenuPause)
                    } icon: {
                        Image(systemName: "bell.slash")
                    }
                } else {
                    Label {
                        Text(.notificationsLineConfigMenuResume)
                    } icon: {
                        Image(systemName: "bell")
                    }
                }
            }
            Button {
                onAction(.tapped)
            } label: {
                Label {
                    Text(.notificationsLineConfigMenuEdit)
                } icon: {
                    Image(systemName: "pencil")
                }
            }
        } label: {
            Group {
                if isSaving {
                    ProgressView()
                } else {
                    Label {
                        Text(.notificationsLineConfigMenuLabel)
                    } icon: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .labelStyle(.iconOnly)
                    .font(.title3)
                }
            }
            // Sits where the chevron does on other rows; the tap area extends leftwards and to the card edge.
            .padding(.trailing, 16)
            .frame(minWidth: 60, minHeight: 44, alignment: .trailing)
            .contentShape(.rect)
        }
        .tint(Color.accentColor)
    }

    // MARK: - Appearance

    // Orange flags states needing attention and the accent colour marks
    // notifications as on; the line colour is left to the status header.
    private var iconForegroundColor: Color {
        switch state {
        case .active, .permissionDenied, .paused: .white
        default: .secondary
        }
    }

    private var iconBackgroundColor: Color {
        switch state {
        case .active: .accentColor
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
        case .locked: return .notificationsButtonLockedTitle
        case .permissionDenied: return .lineStatusNotificationsPermissionDeniedTitle
        case .notSetUp: return .notificationsButtonLineInactiveTitle
        case .paused: return .notificationsButtonLinePausedTitle
        case .active: return .notificationsButtonLineActiveTitle
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
    LineNotificationsButton(state: .locked, onAction: { _ in })
        .padding()
}

#Preview("Permission denied") {
    LineNotificationsButton(state: .permissionDenied, onAction: { _ in })
        .padding()
}

#Preview("Not set up") {
    LineNotificationsButton(state: .notSetUp, onAction: { _ in })
        .padding()
}

#Preview("Paused") {
    LineNotificationsButton(state: .paused, onAction: { _ in })
        .padding()
}

#Preview("Active") {
    LineNotificationsButton(state: .active, onAction: { _ in })
        .padding()
}

#Preview("Active, saving") {
    LineNotificationsButton(state: .active, isSaving: true, onAction: { _ in })
        .padding()
}
