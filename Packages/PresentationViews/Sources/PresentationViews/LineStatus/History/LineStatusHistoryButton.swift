import Models
import SwiftUI

public struct LineStatusHistoryButton: View {

    public enum Access {
        case locked
        case unlocked
    }

    public enum HistoryState {
        case ongoingDisruption(since: Date)
        case resolvedDisruption(at: Date)
        case multipleDisruptions(count: Int, firstAt: Date)
    }

    let access: Access
    let lineColor: Color
    let historyState: HistoryState?
    let onTap: () -> Void

    public var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
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
        .accessibilityHint(accessibilityHint)
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
        switch access {
        case .locked:
            historyState != nil
                ? .lineStatusHistoryEntryLockedSubtitleWithDisruption
                : .lineStatusHistoryEntryLockedSubtitle
        case .unlocked:
            historyState != nil
                ? .lineStatusHistoryEntryUnlockedSubtitleWithDisruption
                : .lineStatusHistoryEntryUnlockedSubtitle
        }
    }

    @ViewBuilder
    private var accessory: some View {
        switch access {
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
        switch access {
        case .locked: .lineStatusHistoryEntryLockedAccessibilityHint
        case .unlocked: .lineStatusHistoryEntryUnlockedAccessibilityHint
        }
    }
}


// MARK: - Previews

#Preview("Locked") {
    LineStatusHistoryButton(access: .locked, lineColor: .red, historyState: nil, onTap: {})
        .padding()
}

#Preview("Locked (ongoing disruption)") {
    LineStatusHistoryButton(access: .locked, lineColor: .red, historyState: .ongoingDisruption(since: .now), onTap: {})
        .padding()
}

#Preview("Locked (resolved disruption)") {
    LineStatusHistoryButton(access: .locked, lineColor: .red, historyState: .resolvedDisruption(at: .now), onTap: {})
        .padding()
}

#Preview("Locked (multiple disruptions)") {
    LineStatusHistoryButton(access: .locked, lineColor: .red, historyState: .multipleDisruptions(count: 3, firstAt: .now), onTap: {})
        .padding()
}

#Preview("Unlocked") {
    LineStatusHistoryButton(access: .unlocked, lineColor: .blue, historyState: nil, onTap: {})
        .padding()
}

#Preview("Unlocked (ongoing disruption)") {
    LineStatusHistoryButton(access: .unlocked, lineColor: .blue, historyState: .ongoingDisruption(since: .now), onTap: {})
        .padding()
}

#Preview("Unlocked (resolved disruption)") {
    LineStatusHistoryButton(access: .unlocked, lineColor: .blue, historyState: .resolvedDisruption(at: .now), onTap: {})
        .padding()
}

#Preview("Unlocked (multiple disruptions)") {
    LineStatusHistoryButton(access: .unlocked, lineColor: .blue, historyState: .multipleDisruptions(count: 3, firstAt: .now), onTap: {})
        .padding()
}
