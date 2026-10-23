import SwiftUI

public struct LineStatusHistoryButton: View {

    public enum HistoryState {
        case noDisruption
        case ongoingDisruption(since: Date)
        case resolvedDisruption(at: Date)
        case multipleDisruptions(count: Int, firstAt: Date)
    }

    /// Locked carries no history: disruption data comes from the Tube Service API, which is only requested for
    /// Tube Service Plus subscribers.
    public enum ButtonState {
        case locked
        case unlocked(HistoryState)
    }

    let buttonState: ButtonState
    let onTap: () -> Void

    public var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
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

                accessory
            }
            .padding(16)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .cardStyle()
        .accessibilityHint(accessibilityHint)
    }

    private var historyState: HistoryState {
        switch buttonState {
        case .locked: .noDisruption
        case .unlocked(let historyState): historyState
        }
    }

    // Colour is reserved for attention: any disruption is highlighted in orange.
    private var iconForegroundColor: Color {
        switch historyState {
        case .noDisruption: .secondary
        default: .white
        }
    }

    private var iconBackgroundColor: Color {
        switch historyState {
        case .noDisruption: Color(.tertiarySystemFill)
        default: .orange
        }
    }

    private var title: LocalizedStringResource {
        switch historyState {
        case .noDisruption:
            return .lineStatusHistoryNavigationTitle
        case .ongoingDisruption(let date):
            return .lineStatusHistoryEntryDisruptionSince(
                date.formatted(.dateTime.hour().minute())
            )
        case .resolvedDisruption(let date):
            return .lineStatusHistoryEntryEarlierDisruptionAt(
                date.formatted(.dateTime.hour().minute())
            )
        case .multipleDisruptions(let count, let firstAt):
            return .lineStatusHistoryDisruptionsSince(count, firstAt.formatted(.dateTime.hour().minute()))
        }
    }

    private var subtitle: LocalizedStringResource {
        switch buttonState {
        case .locked: .lineStatusHistoryEntryLockedSubtitle
        case .unlocked(.noDisruption): .lineStatusHistoryEntryUnlockedSubtitle
        case .unlocked: .lineStatusHistoryEntryUnlockedSubtitleWithDisruption
        }
    }

    @ViewBuilder
    private var accessory: some View {
        switch buttonState {
        case .locked:
            Image(systemName: "lock.fill")
                .foregroundStyle(.secondary)
                .accessibilityLabel(.lineStatusHistoryEntryLockedAccessibilityLabel)
        case .unlocked:
            Image(systemName: "chevron.forward")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
    }

    private var accessibilityHint: LocalizedStringResource {
        switch buttonState {
        case .locked: .lineStatusHistoryEntryLockedAccessibilityHint
        case .unlocked: .lineStatusHistoryEntryUnlockedAccessibilityHint
        }
    }
}


// MARK: - Previews

#Preview("Locked") {
    LineStatusHistoryButton(buttonState: .locked, onTap: {})
        .padding()
}

#Preview("Unlocked") {
    LineStatusHistoryButton(buttonState: .unlocked(.noDisruption), onTap: {})
        .padding()
}

#Preview("Unlocked (ongoing disruption)") {
    LineStatusHistoryButton(
        buttonState: .unlocked(.ongoingDisruption(since: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Unlocked (resolved disruption)") {
    LineStatusHistoryButton(
        buttonState: .unlocked(.resolvedDisruption(at: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Unlocked (multiple disruptions)") {
    LineStatusHistoryButton(
        buttonState: .unlocked(.multipleDisruptions(count: 3, firstAt: .now)),
        onTap: {}
    )
    .padding()
}
