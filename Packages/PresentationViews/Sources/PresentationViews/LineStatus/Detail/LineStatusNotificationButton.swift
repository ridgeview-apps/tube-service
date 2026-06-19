import Models
import SwiftUI

public struct LineStatusNotificationButton: View {

    public enum State: Sendable {
        case notSubscribed
        case inactive
        case active
    }

    let state: State
    let lineColor: Color
    let onTap: () -> Void

    public var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(lineColor)
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

                Spacer(minLength: 8)

                accessory
            }
            .padding(16)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .cardStyle()
    }

    private var iconName: String {
        switch state {
        case .notSubscribed: "bell"
        case .inactive: "bell.badge"
        case .active: "bell.fill"
        }
    }

    private var title: LocalizedStringResource {
        switch state {
        case .notSubscribed: .lineStatusNotificationsNotSubscribedTitle
        case .inactive: .lineStatusNotificationsInactiveTitle
        case .active: .lineStatusNotificationsActiveTitle
        }
    }

    private var subtitle: LocalizedStringResource {
        switch state {
        case .notSubscribed: .lineStatusNotificationsNotSubscribedSubtitle
        case .inactive: .lineStatusNotificationsInactiveSubtitle
        case .active: .lineStatusNotificationsActiveSubtitle
        }
    }

    @ViewBuilder
    private var accessory: some View {
        switch state {
        case .notSubscribed:
            Image(systemName: "chevron.forward")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        case .inactive:
            Image(systemName: "plus.circle")
                .foregroundStyle(.secondary)
        case .active:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(lineColor)
        }
    }
}


// MARK: - Previews

#Preview("Not subscribed") {
    LineStatusNotificationButton(state: .notSubscribed, lineColor: .red, onTap: {})
        .padding()
}

#Preview("Inactive") {
    LineStatusNotificationButton(state: .inactive, lineColor: .blue, onTap: {})
        .padding()
}

#Preview("Active") {
    LineStatusNotificationButton(state: .active, lineColor: .blue, onTap: {})
        .padding()
}
