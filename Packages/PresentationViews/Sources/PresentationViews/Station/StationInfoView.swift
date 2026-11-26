import Models
import Shared
import SwiftUI

/// A station's line statuses, notices and location, opened from the Station screen's toolbar or line status row.
public struct StationInfoView: View {
    let station: Station
    let info: StationInfo
    let onTapLine: (Line) -> Void

    public init(station: Station, info: StationInfo, onTapLine: @escaping (Line) -> Void) {
        self.station = station
        self.info = info
        self.onTapLine = onTapLine
    }

    public var body: some View {
        List {
            linesSection
            NoticesSections(
                notices: info.notices,
                isLoading: info.isLoadingNotices,
                placeName: station.name,
                emptyText: .stationNoticesEmpty
            )
            LocationSection(name: station.name, location: station.location)
        }
        .listStyle(.insetGrouped)
        .accessibilityIdentifier(AccessibilityID.StationInfo.list)
    }

    // MARK: - Lines

    private var linesSection: some View {
        Section {
            if !info.lines.isEmpty {
                ForEach(info.lines.sortedByStatusSeverity()) { line in
                    Button {
                        onTapLine(line)
                    } label: {
                        LineStatusCell(style: .singleLine(line, isFavourite: false), showsAccessory: true)
                            .frame(minHeight: 56)
                            .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier(AccessibilityID.StationInfo.line(line.id.rawValue))
                    .listRowInsets(EdgeInsets())
                }
            } else if info.isLoadingLines {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Text(.stationLineStatusUnavailable)
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text(.stationLineStatusSectionHeaderTitle)
        }
    }
}

// MARK: - Previews

// Wembley Park, which the notices below are about
private let previewStation = Station.allLondonTrains.first { $0.name == "Wembley Park" } ?? Station.allLondonTrains[0]

private let previewLines = [
    Line(
        id: .metropolitan,
        lineStatuses: [
            .init(statusSeverity: .minorDelays, statusSeverityDescription: "Minor Delays", reason: nil, disruption: nil)
        ]
    ),
    Line(id: .jubilee, lineStatuses: [.goodService])
]

#Preview("Station info") {
    // 14:00 today, so the exit only notice starts later today
    let now = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: .now) ?? .now
    let notices = [
        StationNotice(text: "WEMBLEY PARK STATION: Westbound trains will not stop here until 30 November.", kind: "Part Closure"),
        StationNotice(text: "Wembley Park: No Step Free Access - Step free access is not available to the Jubilee line.", kind: "Information"),
        StationNotice(text: "Step-free interchange between the Jubilee and Metropolitan lines.", kind: "Interchange Message"),
        StationNotice(
            text: "WEMBLEY PARK STATION: Thursday, between 2130 and 2240, the station will be exit only after the event.",
            kind: "Exit Only",
            startDate: Calendar.current.date(bySettingHour: 21, minute: 30, second: 0, of: now),
            endDate: Calendar.current.date(bySettingHour: 22, minute: 40, second: 0, of: now)
        ),
        StationNotice(
            text: "The lifts to platforms 5 and 6 will be closed for maintenance.",
            kind: "Information",
            startDate: Calendar.current.date(byAdding: .day, value: 7, to: now)
        )
    ]
    Color.clear.sheet(isPresented: .constant(true)) {
        NavigationStack {
            StationInfoView(station: previewStation, info: .init(lines: previewLines, notices: notices), onTapLine: { _ in })
        }
        .environment(\.clock, .fixed(at: now))
    }
}

#Preview("No notices") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NavigationStack {
            StationInfoView(station: previewStation, info: .init(lines: previewLines, notices: []), onTapLine: { _ in })
        }
    }
}

#Preview("Loading") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NavigationStack {
            StationInfoView(
                station: previewStation,
                info: .init(lines: [], isLoadingLines: true, notices: nil, isLoadingNotices: true),
                onTapLine: { _ in }
            )
        }
    }
}

#Preview("Unavailable") {
    Color.clear.sheet(isPresented: .constant(true)) {
        NavigationStack {
            StationInfoView(station: previewStation, info: .init(lines: [], notices: nil), onTapLine: { _ in })
        }
    }
}
