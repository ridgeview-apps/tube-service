import Models
import Shared
import SwiftUI

/// The selected line group's line statuses, shown under the chips as a slim version of the line status screen's
/// header card. Always shown, so the boards below don't move as the chip changes. Other line groups' disruptions show
/// only as badges on their chips.
struct StationLineStatusCard: View {
    /// The selected line group's lines, empty if their statuses couldn't be loaded.
    let lines: [Line]
    let onTapLine: (Line) -> Void

    var body: some View {
        let groups = lines.groupedByStatus()
        // Once lines differ, each row names its lines, as the bar colours alone don't say which line is which
        let showsLineNames = groups.count > 1
        VStack(spacing: 0) {
            if groups.isEmpty {
                unavailableRow
            }
            ForEach(groups) { group in
                if group.id != groups.first?.id {
                    Divider()
                        .padding(.leading, 16)
                }
                StationLineStatusGroupRow(group: group, showsLineNames: showsLineNames, onTapLine: onTapLine)
            }
        }
        .cardStyle()
        .compactCardLineLimit()
    }

    private var unavailableRow: some View {
        Text(.stationLineStatusUnavailable)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
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

// MARK: - Status group row

/// One line opens straight away. Several lines expand in place into a row per line, each opening its line.
private struct StationLineStatusGroupRow: View {
    let group: LineStatusGroup
    let showsLineNames: Bool
    let onTapLine: (Line) -> Void

    @State private var isExpanded = false

    var body: some View {
        if let line = group.lines.first, group.lines.count == 1 {
            Button {
                onTapLine(line)
            } label: {
                StationLineStatusRowLabel(group: group, showsLineNames: showsLineNames, accessory: .opensLine)
            }
            .buttonStyle(.plain)
        } else {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(group.lines) { line in
                    Button {
                        onTapLine(line)
                    } label: {
                        StationLineRow(line: line)
                    }
                    .buttonStyle(.plain)
                }
            } label: {
                StationLineStatusRowLabel(
                    group: group,
                    showsLineNames: showsLineNames,
                    accessory: .expands(isExpanded: isExpanded)
                )
            }
            .disclosureGroupStyle(.stationLineStatus)
        }
    }
}

/// The whole row toggles, and the chevron is drawn by the row label so it lines up with the other rows' chevrons.
private struct StationLineStatusDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            Button {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            } label: {
                configuration.label
            }
            .buttonStyle(.plain)
            .accessibilityValue(Text(configuration.isExpanded ? .stationLineStatusGroupAccessibilityExpanded : .stationLineStatusGroupAccessibilityCollapsed))
            if configuration.isExpanded {
                configuration.content
            }
        }
    }
}

private extension DisclosureGroupStyle where Self == StationLineStatusDisclosureStyle {
    static var stationLineStatus: Self { .init() }
}

/// A line within an expanded group, which opens that line. Indented to the status text, with the chips' colour bar
/// rather than a leading bar, so it reads as part of the group above.
private struct StationLineRow: View {
    let line: Line

    /// The row's inset plus the status icon and its spacing, so the bar lines up with the status text
    @ScaledMetric(relativeTo: .subheadline) private var indent: CGFloat = 44

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 10) {
                LineColourBar(lineIDs: [line.id])
                Text(line.id.name)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .padding(.trailing, 12)
            .padding(.vertical, 12)
        }
        .padding(.leading, indent)
        .contentShape(.rect)
    }
}

/// A line's colour in a row's leading bar. Northern's black is the one line colour that disappears against the dark
/// card, and outlining every segment would drown out the other lines' colours.
private struct LineBarSegment: View {
    let lineID: TrainLineID

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Rectangle()
            .fill(lineID.backgroundColor)
            .overlay {
                if colorScheme == .dark, lineID == .northern {
                    Rectangle().strokeBorder(.primary.opacity(0.5), lineWidth: 1)
                }
            }
    }
}

private struct StationLineStatusRowLabel: View {
    let group: LineStatusGroup
    let showsLineNames: Bool
    let accessory: Accessory

    enum Accessory {
        case opensLine
        case expands(isExpanded: Bool)
    }

    var body: some View {
        HStack(spacing: 10) {
            Label {
                Text(group.statusText)
            } icon: {
                (group.isDisrupted ? LineStatusAccessoryImageType.disruption : .goodService).image
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(group.isDisrupted ? .adaptiveRed : .primary)

            Spacer(minLength: 8)

            if showsLineNames {
                Text(lineNames)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            accessoryImage
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(.leading, 16)
        .padding(.trailing, 12)
        .padding(.vertical, 12)
        // A background stretches the bar to the row's full height
        .background(alignment: .leading) {
            VStack(spacing: 0) {
                ForEach(group.lines) { line in
                    LineBarSegment(lineID: line.id)
                }
            }
            .frame(width: 6)
        }
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }

    private var lineNames: String {
        group.lines
            .map { $0.id.abbreviatedName(besideOtherLines: true) }
            .formatted(.list(type: .and, width: .narrow))
    }

    @ViewBuilder private var accessoryImage: some View {
        switch accessory {
        case .opensLine:
            Image(systemName: "chevron.right")
        case .expands(let isExpanded):
            Image(systemName: "chevron.down")
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
        }
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

#Preview("Cards") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            Text(verbatim: "One line, good service")
            StationLineStatusCard(lines: [.goodService(.northern)], onTapLine: { _ in })

            Text(verbatim: "One line, disrupted")
            StationLineStatusCard(lines: [.minorDelays(.northern)], onTapLine: { _ in })

            Text(verbatim: "Three lines, all good service")
            StationLineStatusCard(
                lines: [.goodService(.circle), .goodService(.hammersmithAndCity), .goodService(.metropolitan)],
                onTapLine: { _ in }
            )

            Text(verbatim: "Three lines, all minor delays")
            StationLineStatusCard(
                lines: [.minorDelays(.circle), .minorDelays(.hammersmithAndCity), .minorDelays(.metropolitan)],
                onTapLine: { _ in }
            )

            Text(verbatim: "Three lines, mixed")
            StationLineStatusCard(
                lines: [
                    .withStatus(.circle, .plannedClosure, "Planned Closure"), .goodService(.hammersmithAndCity),
                    .minorDelays(.metropolitan)
                ],
                onTapLine: { _ in }
            )

            Text(verbatim: "Unavailable")
            StationLineStatusCard(lines: [], onTapLine: { _ in })
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding()
    }
    .background(Color.defaultBackground)
}
