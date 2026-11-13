import Models
import Shared
import SwiftUI

/// The selected line group's disrupted lines, shown under the chips as a slim version of the line status screen's
/// header card. Other line groups' disruptions show only as badges on their chips.
struct StationLineDisruptionsView: View {
    /// The selected line group's disrupted lines.
    let lines: [Line]
    let selectedLineIDs: [TrainLineID]
    let onTapLine: (Line) -> Void

    var body: some View {
        let sortedLines = lines.sorted { $0.id.name < $1.id.name }
        VStack(spacing: 0) {
            ForEach(sortedLines) { line in
                if line.id != sortedLines.first?.id {
                    Divider()
                        .padding(.leading, 16)
                }
                Button {
                    onTapLine(line)
                } label: {
                    StationLineStatusRow(line: line, showsLineName: selectedLineIDs.count > 1)
                }
                .buttonStyle(.plain)
            }
        }
        .cardStyle()
        .compactCardLineLimit()
    }
}

/// A closure that's on now or starts later today, the one kind of notice that changes how people use the station, so
/// it shows above the chips rather than only behind the toolbar's notices button.
struct StationClosureBanner: View {
    let preview: StationNoticesSummary.ClosurePreview
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Label {
                    Text(text)
                } icon: {
                    Image(systemName: preview.startDate == nil ? "exclamationmark.triangle.fill" : "clock")
                        .foregroundStyle(.orange)
                }
                .font(.subheadline)
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .cardStyle()
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .compactCardLineLimit()
    }

    private var text: String {
        guard let startDate = preview.startDate else { return preview.text }
        return String(localized: .stationNoticesPreviewFrom(startDate.formatted(date: .omitted, time: .shortened), preview.text))
    }
}

private struct CompactCardLineLimit: ViewModifier {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    func body(content: Content) -> some View {
        content
            // A second line at accessibility sizes keeps the rows readable rather than cut off after a word
            .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
            .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

private extension View {
    func compactCardLineLimit() -> some View {
        modifier(CompactCardLineLimit())
    }
}

// MARK: - Line status row

private struct StationLineStatusRow: View {
    let line: Line
    let showsLineName: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 10) {
            Label {
                Text(line.shortStatusText)
            } icon: {
                line.accessoryImageType.image
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(line.isDisrupted ? .adaptiveRed : .primary)

            Spacer(minLength: 8)

            if showsLineName {
                Text(line.id.abbreviatedName(besideOtherLines: true))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(.leading, 16)
        .padding(.trailing, 12)
        .padding(.vertical, 12)
        // A background stretches the bar to the row's full height
        .background(alignment: .leading) {
            Rectangle()
                .fill(line.id.backgroundColor)
                .frame(width: 6)
                .overlay {
                    if needsBarOutline {
                        Rectangle().strokeBorder(.primary.opacity(0.5), lineWidth: 1)
                    }
                }
        }
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }

    /// Northern's black is the one line colour that disappears against the dark card. Outlining every bar would
    /// drown out the other lines' colours.
    private var needsBarOutline: Bool {
        colorScheme == .dark && line.id == .northern
    }
}

// MARK: - Previews

private extension Line {
    static func disrupted(_ id: TrainLineID, _ description: String) -> Line {
        Line(
            id: id,
            lineStatuses: [
                .init(statusSeverity: .minorDelays, statusSeverityDescription: description, reason: nil, disruption: nil)
            ]
        )
    }
}

// 14:00 today, so the evening closure below always starts later today
private let previewNow = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: .now) ?? .now

private let previewNotices = [
    StationNotice(text: "Westbound trains will not stop here until 30 November.", kind: "Part Closure"),
    StationNotice(text: "Mini ramps are available on the Northern and Victoria lines.", kind: "Information")
]

private let previewUpcomingClosure = StationNotice(
    text: "WEMBLEY PARK STATION: Exit only after the event.",
    kind: "Exit Only",
    startDate: Calendar.current.date(bySettingHour: 21, minute: 30, second: 0, of: previewNow),
    endDate: Calendar.current.date(bySettingHour: 22, minute: 40, second: 0, of: previewNow)
)

private func previewSummary(_ notices: [StationNotice]) -> StationNoticesSummary {
    StationNoticesSummary(notices: notices, stationName: "Wembley Park", now: previewNow)
}

#Preview("Cards") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            Text(verbatim: "Current closure")
            if let preview = previewSummary(previewNotices).closurePreview {
                StationClosureBanner(preview: preview, onTap: {})
            }

            Text(verbatim: "Closure later today")
            if let preview = previewSummary([previewUpcomingClosure, previewNotices[1]]).closurePreview {
                StationClosureBanner(preview: preview, onTap: {})
            }

            Text(verbatim: "One disrupted line")
            StationLineDisruptionsView(
                lines: [.disrupted(.northern, "Minor Delays")],
                selectedLineIDs: [.northern],
                onTapLine: { _ in }
            )

            Text(verbatim: "Two of three lines")
            StationLineDisruptionsView(
                lines: [.disrupted(.circle, "Planned Closure"), .disrupted(.metropolitan, "Minor Delays")],
                selectedLineIDs: [.circle, .hammersmithAndCity, .metropolitan],
                onTapLine: { _ in }
            )

            Text(verbatim: "Three lines, all minor delays")
            StationLineDisruptionsView(
                lines: [.disrupted(.circle, "Minor Delays"), .disrupted(.hammersmithAndCity, "Minor Delays"), .disrupted(.metropolitan, "Minor Delays")],
                selectedLineIDs: [.circle, .hammersmithAndCity, .metropolitan],
                onTapLine: { _ in }
            )
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding()
    }
    .background(Color.defaultBackground)
}
