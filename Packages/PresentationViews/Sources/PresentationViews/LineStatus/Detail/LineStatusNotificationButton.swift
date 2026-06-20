import Models
import SwiftUI

public struct LineStatusNotificationButton: View {

    public enum SubscriptionState: Sendable, Equatable {
        case notSubscribed
        case inactive
        case active
    }

    public enum Action: Sendable {
        case notSubscribedTapped
        case addLine
        case removeLine
    }

    let state: SubscriptionState
    let lineColor: Color
    let onAction: (Action) -> Void

    @State private var showsRemoveConfirmDialog = false
    @State private var showingConfirmation = false

    public var body: some View {
        Button {
            buttonTapped()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .contentTransition(.symbolEffect(.replace))
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(showingConfirmation ? Color.green : lineColor)
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
        .confirmationDialog(
            .lineStatusNotificationsRemoveConfirmTitle,
            isPresented: $showsRemoveConfirmDialog,
            titleVisibility: .visible
        ) {
            Button(.globalCancel, role: .cancel) {}
            Button(.globalRemove, role: .destructive) {
                onAction(.removeLine)
            }
        }
        .sensoryFeedback(.success, trigger: showingConfirmation) { _, newValue in newValue }
        .sensoryFeedback(.warning, trigger: state) { (old: SubscriptionState, new: SubscriptionState) in
            old == .active && new == .inactive
        }
    }

    private var iconName: String {
        switch state {
        case .notSubscribed: "bell"
        case .inactive: showingConfirmation ? "bell.fill" : "bell.badge"
        case .active: "bell.fill"
        }
    }

    private var title: LocalizedStringResource {
        if showingConfirmation { return .lineStatusNotificationsActiveTitle }
        switch state {
        case .notSubscribed: return .lineStatusNotificationsNotSubscribedTitle
        case .inactive: return .lineStatusNotificationsInactiveTitle
        case .active: return .lineStatusNotificationsActiveTitle
        }
    }

    private var subtitle: LocalizedStringResource {
        if showingConfirmation { return .lineStatusNotificationsActiveSubtitle }
        switch state {
        case .notSubscribed: return .lineStatusNotificationsNotSubscribedSubtitle
        case .inactive: return .lineStatusNotificationsInactiveSubtitle
        case .active: return .lineStatusNotificationsActiveSubtitle
        }
    }

    @ViewBuilder
    private var accessory: some View {
        if state == .notSubscribed {
            Image(systemName: "chevron.forward")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        } else if state == .active || showingConfirmation {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(showingConfirmation ? Color.green : lineColor)
        } else {
            Image(systemName: "plus.circle")
                .foregroundStyle(.secondary)
        }
    }

    private func buttonTapped() {
        switch state {
        case .notSubscribed:
            onAction(.notSubscribedTapped)
        case .inactive:
            withAnimation(.snappy(duration: 0.35)) {
                showingConfirmation = true
            }
            onAction(.addLine)
            Task {
                try? await Task.sleep(for: .seconds(1.2))
                withAnimation(.snappy(duration: 0.35)) {
                    showingConfirmation = false
                }
            }
        case .active:
            showsRemoveConfirmDialog = true
        }
    }
}


// MARK: - Previews

#Preview("Not subscribed") {
    LineStatusNotificationButton(state: .notSubscribed, lineColor: .red, onAction: { _ in })
        .padding()
}

#Preview("Inactive") {
    LineStatusNotificationButton(state: .inactive, lineColor: .blue, onAction: { _ in })
        .padding()
}

#Preview("Active") {
    LineStatusNotificationButton(state: .active, lineColor: .blue, onAction: { _ in })
        .padding()
}
