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

    let lineID: TrainLineID
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

    private var iconForegroundColor: Color {
        switch buttonState {
        case .locked:
            .secondary
        case .unlocked(let historyState):
            historyState != nil ? .white : lineID.textColor
        }
    }

    private var iconBackgroundColor: Color {
        switch buttonState {
        case .locked:
            Color(.tertiarySystemFill)
        case .unlocked(let historyState):
            historyState != nil ? .orange : lineID.backgroundColor
        }
    }

    private var historyState: HistoryState? {
        switch buttonState {
        case .locked(let historyState), .unlocked(let historyState): return historyState
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
        case .locked(let historyState):
            historyState != nil
                ? .lineStatusHistoryEntryLockedSubtitleWithDisruption
                : .lineStatusHistoryEntryLockedSubtitle
        case .unlocked(let historyState):
            historyState != nil
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
    LineStatusHistoryButton(lineID: .victoria, buttonState: .locked(nil), onTap: {})
        .padding()
}

#Preview("Locked (ongoing disruption)") {
    LineStatusHistoryButton(
        lineID: .victoria,
        buttonState: .locked(.ongoingDisruption(since: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Locked (resolved disruption)") {
    LineStatusHistoryButton(
        lineID: .victoria,
        buttonState: .locked(.resolvedDisruption(at: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Locked (multiple disruptions)") {
    LineStatusHistoryButton(
        lineID: .victoria,
        buttonState: .locked(.multipleDisruptions(count: 3, firstAt: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Unlocked") {
    LineStatusHistoryButton(lineID: .victoria, buttonState: .unlocked(nil), onTap: {})
        .padding()
}

#Preview("Unlocked (ongoing disruption)") {
    LineStatusHistoryButton(
        lineID: .victoria,
        buttonState: .unlocked(.ongoingDisruption(since: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Unlocked (resolved disruption)") {
    LineStatusHistoryButton(
        lineID: .victoria,
        buttonState: .unlocked(.resolvedDisruption(at: .now)),
        onTap: {}
    )
    .padding()
}

#Preview("Unlocked (multiple disruptions)") {
    LineStatusHistoryButton(
        lineID: .victoria,
        buttonState: .unlocked(.multipleDisruptions(count: 3, firstAt: .now)),
        onTap: {}
    )
    .padding()
}
