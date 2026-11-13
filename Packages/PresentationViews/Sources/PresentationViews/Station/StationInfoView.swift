import MapKit
import Models
import SwiftUI

/// A station's notices and location, opened from the Station screen's toolbar.
struct StationInfoView: View {
    let station: Station
    let noticeSections: StationNoticeSections

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                // Notices first, as they're what the toolbar badge points to
                if noticeSections.isEmpty {
                    Section {
                        Text(.stationNoticesEmpty)
                            .foregroundStyle(.secondary)
                    } header: {
                        Text(.stationNoticesSectionNotices)
                    }
                } else {
                    section(.stationNoticesSectionClosures, rows: noticeSections.closures)
                    section(.stationNoticesSectionNotices, rows: noticeSections.notices)
                    section(.stationNoticesSectionLater, rows: noticeSections.later)
                }
                locationSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle(station.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(.globalDone) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        // At medium height the sheet is glass by default, and the boards showing through made long notices hard to read
        .presentationBackground(Color.defaultBackground)
    }

    @ViewBuilder
    private func section(_ title: LocalizedStringResource, rows: [StationNoticeSections.Row]) -> some View {
        if !rows.isEmpty {
            Section {
                ForEach(rows) { row in
                    StationNoticeRow(row: row)
                }
            } header: {
                Text(title)
            }
        }
    }

    // MARK: - Location

    private var mapURL: URL? {
        URL(string: "https://maps.apple.com?q=\(station.location.lat),\(station.location.lon)")
    }

    private var directionsURL: URL? {
        URL(string: "https://maps.apple.com?daddr=\(station.location.lat),\(station.location.lon)&dirflg=w")
    }

    private var locationSection: some View {
        Section {
            StationMapView(station: station)
                .frame(height: 200)
                .listRowInsets(EdgeInsets())
            if let mapURL {
                linkRow(url: mapURL, text: .stationLocationShowInMapsButtonTitle)
            }
            if let directionsURL {
                linkRow(url: directionsURL, text: .stationLocationDirectionsButtonTitle)
            }
        } header: {
            Text(.stationLocationSectionHeaderTitle)
        }
    }

    private func linkRow(url: URL, text: LocalizedStringResource) -> some View {
        Link(destination: url) {
            HStack {
                Text(text)
                Spacer()
                Image(systemName: "arrow.up.forward.square")
            }
        }
    }
}

private struct StationMapView: View {
    let station: Station
    @State private var position: MapCameraPosition = .automatic

    private var stationCoordinate: CLLocationCoordinate2D {
        station.location.toCLLocation().coordinate
    }

    var body: some View {
        Map(position: $position) {
            UserAnnotation()
            Marker(coordinate: stationCoordinate) {
                Label(station.name, systemImage: "mappin")
            }
        }
        .mapStyle(.standard(pointsOfInterest: .including([.publicTransport])))
        .task {
            position = .camera(.init(centerCoordinate: stationCoordinate, distance: 1500))
        }
    }
}

private struct StationNoticeRow: View {
    let row: StationNoticeSections.Row

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let caption {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    icon
                    Text(caption)
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)
                }
                .font(.caption.weight(.semibold))
            }
            Text(row.text)
                .font(.subheadline)
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }

    private var icon: some View {
        Image(systemName: row.startTime == nil ? (row.isClosure ? "exclamationmark.triangle.fill" : "info.circle") : "clock")
            .foregroundStyle(row.isClosure ? AnyShapeStyle(.orange) : AnyShapeStyle(.secondary))
            .accessibilityHidden(true)
    }

    private var caption: String? {
        switch (kindLabel, timeLabel) {
        case (let kind?, let time?): String(localized: .stationNoticesCaption(kind, time))
        case (let kind?, nil): kind
        case (nil, let time?): time
        case (nil, nil): nil
        }
    }

    private var kindLabel: String? {
        switch row.kind {
        case .closure: String(localized: .stationNoticesKindClosure)
        case .partClosure: String(localized: .stationNoticesKindPartClosure)
        case .exitOnly: String(localized: .stationNoticesKindExitOnly)
        case .information: String(localized: .stationNoticesKindInformation)
        case .interchange: String(localized: .stationNoticesKindInterchange)
        case .other(let kind): kind
        case nil: nil
        }
    }

    private var timeLabel: String? {
        switch row.startTime {
        case .laterToday(let start, let end?):
            (start..<end).formatted(.interval.hour().minute())
        case .laterToday(let start, nil):
            String(localized: .stationNoticesTimeFrom(start.formatted(date: .omitted, time: .shortened)))
        case .laterDay(let start):
            String(localized: .stationNoticesTimeFrom(start.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))))
        case nil:
            nil
        }
    }
}

// MARK: - Previews

// Wembley Park, which the notices below are about
private let previewStation = Station.allLondonTrains.first { $0.name == "Wembley Park" } ?? Station.allLondonTrains[0]

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
        StationInfoView(
            station: previewStation,
            noticeSections: StationNoticeSections(notices: notices, stationName: previewStation.name, now: now)
        )
    }
}

#Preview("No notices") {
    Color.clear.sheet(isPresented: .constant(true)) {
        StationInfoView(
            station: previewStation,
            noticeSections: StationNoticeSections(notices: [], stationName: previewStation.name, now: .now)
        )
    }
}
