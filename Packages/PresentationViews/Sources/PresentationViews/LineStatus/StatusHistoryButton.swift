import Models
import SwiftUI

// MARK: - StatusHistoryButton

public struct StatusHistoryButton: View {

    public enum Access {
        case locked
        case unlocked
    }

    let access: Access
    let lineColor: Color
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
                    Text(.lineStatusHistoryNavigationTitle)
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

    private var subtitle: LocalizedStringResource {
        switch access {
        case .locked: .lineStatusHistoryEntryLockedSubtitle
        case .unlocked: .lineStatusHistoryEntryUnlockedSubtitle
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
    StatusHistoryButton(access: .locked, lineColor: .red, onTap: {})
        .padding()
}

#Preview("Unlocked") {
    StatusHistoryButton(access: .unlocked, lineColor: .blue, onTap: {})
        .padding()
}
