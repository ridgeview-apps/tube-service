import Models
import Shared
import SwiftUI

/// A quiet line under the chips saying the selected line group isn't running normally, which opens every line's
/// status. Nothing shows for a good service, as that's the norm. Other line groups' disruptions show only as badges on
/// their chips.
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

// MARK: - Line status sheet

/// Every line in the selected line group, as the Line Status tab shows them, each opening its line.
struct StationLineStatusSheet: View {
    let lines: [Line]
    let onTapLine: (Line) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(lines.sortedByStatusSeverity()) { line in
                        Button {
                            onTapLine(line)
                        } label: {
                            LineStatusCell(style: .singleLine(line, isFavourite: false), showsAccessory: true)
                                .frame(minHeight: 56)
                                .cardStyle()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle(Text(.stationLineStatusSheetTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(.globalDone) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        // Matches the station info sheet: glass at medium height lets the boards show through the rows
        .presentationBackground(Color.defaultBackground)
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

#Preview("Sheet") {
    StationLineStatusSheet(
        lines: [
            .withStatus(.circle, .plannedClosure, "Planned Closure"), .goodService(.hammersmithAndCity),
            .minorDelays(.metropolitan)
        ],
        onTapLine: { _ in }
    )
}
