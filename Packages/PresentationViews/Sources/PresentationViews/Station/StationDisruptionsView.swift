import Models
import Shared
import SwiftUI

/// The selected line group's disrupted lines, shown under the chips. Other line groups' disruptions show only as
/// badges on their chips.
struct StationLineDisruptionsView: View {
    /// The selected line group's disrupted lines.
    let lines: [Line]
    let selectedLineIDs: [TrainLineID]
    let onTapLine: (Line) -> Void

    var body: some View {
        StationLineStatusCard(lines: lines, lineGroupLineIDs: selectedLineIDs, onTapLine: onTapLine)
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

// MARK: - Line status card

/// A slim version of the line status screen's header card. One disrupted line opens directly; several start as
/// one summary row that expands into a row per line.
struct StationLineStatusCard: View {
    let lines: [Line]
    let lineGroupLineIDs: [TrainLineID]
    let onTapLine: (Line) -> Void

    @State private var isExpanded = false

    var body: some View {
        if let summary = LineDisruptionSummary(disruptedLines: lines, lineGroupLineIDs: lineGroupLineIDs) {
            VStack(spacing: 0) {
                if lines.count == 1, let line = lines.first {
                    Button {
                        onTapLine(line)
                    } label: {
                        StatusRow(
                            text: summary.text,
                            isDisrupted: line.isDisrupted,
                            barLineIDs: [line.id],
                            detail: line.disruptionReason
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    summaryButton(summary)
                    if isExpanded {
                        lineRows
                    }
                }
            }
            .cardStyle()
            .onChange(of: lineGroupLineIDs) { isExpanded = false }
        }
    }

    private func summaryButton(_ summary: LineDisruptionSummary) -> some View {
        Button {
            withAnimation(.snappy) { isExpanded.toggle() }
        } label: {
            StatusRow(
                text: summary.text,
                isDisrupted: lines.contains(where: \.isDisrupted),
                // Once expanded, each line's row shows its own colour
                barLineIDs: isExpanded ? [] : lines.map(\.id).sortedByName(),
                accessory: .disclosure(isExpanded: isExpanded)
            )
        }
        .buttonStyle(.plain)
        .accessibilityValue(
            isExpanded
                ? .lineStatusSectionGoodServiceAccessibilityExpanded
                : .lineStatusSectionGoodServiceAccessibilityCollapsed
        )
    }

    private var lineRows: some View {
        ForEach(lines.sorted { $0.id.name < $1.id.name }) { line in
            Divider()
                .padding(.leading, 16)
            Button {
                onTapLine(line)
            } label: {
                StatusRow(
                    text: line.shortStatusText,
                    isDisrupted: line.isDisrupted,
                    barLineIDs: [line.id],
                    lineName: line.id.abbreviatedName(besideOtherLines: true)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

private struct StatusRow: View {
    enum Accessory {
        case opensDetails
        case disclosure(isExpanded: Bool)
    }

    let text: String
    let isDisrupted: Bool
    let barLineIDs: [TrainLineID]
    var lineName: String?
    /// A line of context under the status, e.g. the disruption's reason.
    var detail: String?
    var accessory = Accessory.opensDetails

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        HStack(spacing: 10) {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(text)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(isDisrupted ? .adaptiveRed : .primary)
                    if let detail {
                        Text(detail)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                    }
                }
            } icon: {
                (isDisrupted ? LineStatusAccessoryImageType.disruption : .goodService).image
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isDisrupted ? .adaptiveRed : .primary)
            }

            Spacer(minLength: 8)

            if let lineName {
                Text(lineName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            accessoryImage
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(.leading, 16)
        .padding(.trailing, 12)
        .padding(.vertical, 10)
        // A background stretches the bar to the row's full height
        .background(alignment: .leading) {
            VStack(spacing: 0) {
                ForEach(barLineIDs, id: \.self) { lineID in
                    Rectangle().fill(lineID.backgroundColor)
                }
            }
            .frame(width: 6)
            // Like the chips' colour bars, so dark lines (e.g. Northern) stay visible in dark mode
            .overlay {
                if !barLineIDs.isEmpty {
                    Rectangle().strokeBorder(.primary.opacity(0.5), lineWidth: 1)
                }
            }
        }
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder private var accessoryImage: some View {
        switch accessory {
        case .opensDetails:
            Image(systemName: "chevron.right")
        case .disclosure(let isExpanded):
            Image(systemName: "chevron.down")
                .rotationEffect(isExpanded ? .degrees(180) : .zero)
        }
    }
}

// MARK: - Previews

private extension Line {
    static func disrupted(_ id: TrainLineID, _ description: String, reason: String = "") -> Line {
        Line(
            id: id,
            lineStatuses: [
                .init(statusSeverity: .minorDelays, statusSeverityDescription: description, reason: reason, disruption: nil)
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
                lines: [
                    .disrupted(
                        .northern,
                        "Minor Delays",
                        reason: "Northern Line: Minor delays between Kennington and Morden due to an earlier signal failure at Tooting Broadway."
                    )
                ],
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
