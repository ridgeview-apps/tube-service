import Models
import Shared
import SwiftUI

/// A quiet line under the chips giving the selected line group's status, which opens the station info. Other line
/// groups' disruptions show only as badges on their chips.
struct StationLineStatusRow: View {
    /// The selected line group's lines, empty if their statuses couldn't be loaded.
    let lines: [Line]
    var isLoading = false
    let onTap: () -> Void

    var body: some View {
        if let title = lines.disruptionSummary {
            statusButton(.disruption, title: title)
        } else if let title = lines.goodServiceSummary {
            statusButton(.goodService, title: title)
        } else if isLoading {
            // Holds the row's space so the boards don't move down once the statuses arrive. The text is hidden, so
            // any line's name will do.
            let placeholderTitle = String(localized: .lineGoodServiceSummary(TrainLineID.northern.nameInSentence))
            statusButton(.goodService, title: placeholderTitle)
                .redacted(reason: .placeholder)
                .disabled(true)
        } else {
            Text(.stationLineStatusUnavailable)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .compactLineLimit()
        }
    }

    private func statusButton(_ imageType: LineStatusAccessoryImageType, title: String) -> some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                imageType.image
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
            Text(verbatim: "One line, good service")
            StationLineStatusRow(lines: [.goodService(.northern)], onTap: {})

            Text(verbatim: "Three lines, good service")
            StationLineStatusRow(
                lines: [.goodService(.circle), .goodService(.hammersmithAndCity), .goodService(.metropolitan)],
                onTap: {}
            )

            Text(verbatim: "One line, disrupted")
            StationLineStatusRow(lines: [.minorDelays(.northern)], onTap: {})

            Text(verbatim: "Three lines, one disrupted")
            StationLineStatusRow(
                lines: [.goodService(.circle), .goodService(.hammersmithAndCity), .minorDelays(.metropolitan)],
                onTap: {}
            )

            Text(verbatim: "Three lines, all minor delays")
            StationLineStatusRow(
                lines: [.minorDelays(.circle), .minorDelays(.hammersmithAndCity), .minorDelays(.metropolitan)],
                onTap: {}
            )

            Text(verbatim: "Three lines, mixed")
            StationLineStatusRow(
                lines: [
                    .withStatus(.circle, .plannedClosure, "Planned Closure"), .goodService(.hammersmithAndCity),
                    .minorDelays(.metropolitan)
                ],
                onTap: {}
            )

            Text(verbatim: "Loading")
            StationLineStatusRow(lines: [], isLoading: true, onTap: {})

            Text(verbatim: "Unavailable")
            StationLineStatusRow(lines: [], onTap: {})
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding()
    }
    .background(Color.defaultBackground)
}
