import Models
import SwiftUI

public struct LineStatusHistoryButton: View {

    public enum HistoryState {
        case ongoingDisruption(since: Date)
        case resolvedDisruption(at: Date)
        case multipleDisruptions(count: Int, firstAt: Date)
    }

    public enum ButtonState {
        case locked(HistoryState?)
        case unlocked(HistoryState?)
    }

    let buttonState: ButtonState
    let onTap: () -> Void

    public var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.tint)
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

                accessory
            }
            .padding(16)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .cardStyle()
        .accessibilityHint(accessibilityHint)
    }

    private var historyState: HistoryState? {
        switch buttonState {
        case .locked(let h), .unlocked(let h): return h
        }
    }

    private var title: LocalizedStringResource {
        switch historyState {
        case .none:
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
        case .locked(let h):
            h != nil
                ? .lineStatusHistoryEntryLockedSubtitleWithDisruption
                : .lineStatusHistoryEntryLockedSubtitle
        case .unlocked(let h):
            h != nil
                ? .lineStatusHistoryEntryUnlockedSubtitleWithDisruption
                : .lineStatusHistoryEntryUnlockedSubtitle
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
    LineStatusHistoryButton(buttonState: .locked(nil), onTap: {})
        .padding()
}

#Preview("Locked (ongoing disruption)") {
    LineStatusHistoryButton(
        buttonState: .locked(.ongoingDisruption(since: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Locked (resolved disruption)") {
    LineStatusHistoryButton(
        buttonState: .locked(.resolvedDisruption(at: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Locked (multiple disruptions)") {
    LineStatusHistoryButton(
        buttonState: .locked(.multipleDisruptions(count: 3, firstAt: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Unlocked") {
    LineStatusHistoryButton(buttonState: .unlocked(nil), onTap: {})
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
