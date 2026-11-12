import Models
import Shared
import SwiftUI

/// The selected line group's status and the station's notices, each as one compact card or row.
/// Other line groups' disruptions show only as badges on their chips.
struct StationDisruptionsView: View {

    enum Action {
        case tappedLine(Line)
        case tappedNotices
    }

    /// The selected line group's disrupted lines.
    let selectedLineDisruptions: [Line]
    let selectedLineIDs: [TrainLineID]
    let notices: [String]
    var hasClosureNotice = false
    let onAction: (Action) -> Void

    var isEmpty: Bool {
        selectedLineDisruptions.isEmpty && notices.isEmpty
    }

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !selectedLineDisruptions.isEmpty {
                StationLineStatusCard(
                    lines: selectedLineDisruptions,
                    lineGroupLineIDs: selectedLineIDs,
                    onTapLine: { onAction(.tappedLine($0)) }
                )
            }
            if let notice = notices.first {
                Button {
                    onAction(.tappedNotices)
                } label: {
                    NoticesRow(firstNotice: notice, noticeCount: notices.count, isClosure: hasClosureNotice)
                }
                .buttonStyle(.plain)
            }
        }
        // A second line at accessibility sizes keeps the rows readable rather than cut off after a word
        .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
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
                        StatusRow(text: summary.text, isDisrupted: line.isDisrupted, barLineIDs: [line.id])
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
    var accessory = Accessory.opensDetails

    var body: some View {
        HStack(spacing: 10) {
            Label {
                Text(text)
            } icon: {
                (isDisrupted ? LineStatusAccessoryImageType.disruption : .goodService).image
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isDisrupted ? .adaptiveRed : .primary)

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

// MARK: - Notices

/// Matches the line status card's rows, but with no colour bar and regular weight, so line disruptions stand out more.
private struct NoticesRow: View {
    let firstNotice: String
    let noticeCount: Int
    /// Closures sort first, so the notice shown is the closure.
    let isClosure: Bool

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(.stationNoticesTitle)
                    .foregroundStyle(.primary)
                // Only closures change how people use the station, so only they earn a preview line
                if isClosure {
                    Text(firstNotice)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 8)
            CountBadge(count: noticeCount, isHighlighted: isClosure)
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .font(.subheadline)
        // Starts where the line status card's content starts, after its colour bar
        .padding(.leading, 16)
        .padding(.trailing, 12)
        .padding(.vertical, 10)
        .cardStyle()
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }
}

private struct CountBadge: View {
    let count: Int
    let isHighlighted: Bool

    var body: some View {
        Text(count, format: .number)
            .font(.caption.weight(.semibold).monospacedDigit())
            .foregroundStyle(isHighlighted ? AnyShapeStyle(.white) : AnyShapeStyle(.secondary))
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(
                Capsule().fill(isHighlighted ? AnyShapeStyle(.orange) : AnyShapeStyle(.quaternary))
            )
    }
}

// MARK: - Notices sheet

/// Every notice in full, opened from the notices row.
struct StationNoticesView: View {
    let stationName: String
    let notices: [String]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(notices, id: \.self) { notice in
                Label {
                    Text(notice)
                } icon: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(stationName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(.globalDone) { dismiss() }
                }
            }
        }
    }
}

// MARK: - Previews

private extension Line {
    static func disrupted(_ id: TrainLineID, _ description: String) -> Line {
        Line(
            id: id,
            lineStatuses: [
                .init(statusSeverity: .minorDelays, statusSeverityDescription: description, reason: "", disruption: nil)
            ]
        )
    }
}

// Already without TfL's station name prefix, which `StationView` removes
private let previewNotices = [
    "Westbound trains will not stop here until 30 November.",
    "Mini ramps are available on the Northern and Victoria lines."
]

#Preview("Line status card") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            Text(verbatim: "Disruptions only: one line")
            StationDisruptionsView(
                selectedLineDisruptions: [.disrupted(.northern, "Minor Delays")],
                selectedLineIDs: [.northern],
                notices: previewNotices,
                hasClosureNotice: true,
                onAction: { _ in }
            )

            Text(verbatim: "Disruptions only: two of three lines")
            StationDisruptionsView(
                selectedLineDisruptions: [.disrupted(.circle, "Planned Closure"), .disrupted(.metropolitan, "Minor Delays")],
                selectedLineIDs: [.circle, .hammersmithAndCity, .metropolitan],
                notices: previewNotices,
                onAction: { _ in }
            )

            Text(verbatim: "Disruptions only: three lines, all minor delays")
            StationLineStatusCard(
                lines: [.disrupted(.circle, "Minor Delays"), .disrupted(.hammersmithAndCity, "Minor Delays"), .disrupted(.metropolitan, "Minor Delays")],
                lineGroupLineIDs: [.circle, .hammersmithAndCity, .metropolitan],
                onTapLine: { _ in }
            )
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding()
    }
    .background(Color.defaultBackground)
}

#Preview("Notices sheet") {
    StationNoticesView(stationName: "King's Cross & St Pancras International", notices: previewNotices)
}
