import Models
import Shared
import SwiftUI

/// A quiet line under the chips saying the selected line group isn't running normally, which opens the station info.
/// Nothing shows for a good service, as that's the norm. Other line groups' disruptions show only as badges on their
/// chips.
struct StationLineDisruptionRow: View {
    /// The selected line group's lines, empty if their statuses couldn't be loaded.
    let lines: [Line]
    var isLoading = false
    let onTap: () -> Void

    var body: some View {
        if let title = lines.disruptionSummary {
            Button(action: onTap) {
                HStack(spacing: 6) {
                    LineStatusAccessoryImageType.disruption.image
                    Text(title)
                        .foregroundStyle(.primary)
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                    Spacer(minLength: 0)
                }
                .font(.subheadline)
                .compactLineLimit()
                .contentShape(.rect)
                .accessibilityElement(children: .combine)
            }
            .buttonStyle(.plain)
        } else if lines.isEmpty && !isLoading {
            Text(.stationLineStatusUnavailable)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .compactLineLimit()
        }
    }
}

private struct CompactLineLimit: ViewModifier {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    func body(content: Content) -> some View {
        content
            // A second line at accessibility sizes keeps the text readable rather than cut off after a word
            .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
            .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

private extension View {
    func compactLineLimit() -> some View {
        modifier(CompactLineLimit())
    }
}

// MARK: - Previews

private extension Line {
    static func withStatus(_ id: TrainLineID, _ severity: LineStatusSeverity, _ description: String) -> Line {
        Line(
            id: id,
            lineStatuses: [
                .init(statusSeverity: severity, statusSeverityDescription: description, reason: nil, disruption: nil)
            ]
        )
    }

    static func goodService(_ id: TrainLineID) -> Line {
        withStatus(id, .goodService, "Good Service")
    }

    static func minorDelays(_ id: TrainLineID) -> Line {
        withStatus(id, .minorDelays, "Minor Delays")
    }
}

#Preview("Rows") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            Text(verbatim: "One line, good service (nothing shown)")
            StationLineDisruptionRow(lines: [.goodService(.northern)], onTap: {})

            Text(verbatim: "One line, disrupted")
            StationLineDisruptionRow(lines: [.minorDelays(.northern)], onTap: {})

            Text(verbatim: "Three lines, one disrupted")
            StationLineDisruptionRow(
                lines: [.goodService(.circle), .goodService(.hammersmithAndCity), .minorDelays(.metropolitan)],
                onTap: {}
            )

            Text(verbatim: "Three lines, all minor delays")
            StationLineDisruptionRow(
                lines: [.minorDelays(.circle), .minorDelays(.hammersmithAndCity), .minorDelays(.metropolitan)],
                onTap: {}
            )

            Text(verbatim: "Three lines, mixed")
            StationLineDisruptionRow(
                lines: [
                    .withStatus(.circle, .plannedClosure, "Planned Closure"), .goodService(.hammersmithAndCity),
                    .minorDelays(.metropolitan)
                ],
                onTap: {}
            )

            Text(verbatim: "Loading (nothing shown)")
            StationLineDisruptionRow(lines: [], isLoading: true, onTap: {})

            Text(verbatim: "Unavailable")
            StationLineDisruptionRow(lines: [], onTap: {})
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding()
    }
    .background(Color.defaultBackground)
}
