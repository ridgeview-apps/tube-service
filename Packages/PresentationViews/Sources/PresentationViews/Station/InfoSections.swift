import MapKit
import Models
import Shared
import SwiftUI

/// The notices part of a Station or Stop info sheet: closures, other notices and later ones, or a row saying why there
/// are none.
struct NoticesSections: View {
    let notices: [StationNotice]?
    let isLoading: Bool
    /// Removed from the start of each notice, which TfL often begins with.
    let placeName: String
    let emptyText: LocalizedStringResource

    @Environment(\.clock) private var clock

    private var noticeSections: StationNoticeSections? {
        notices.map { StationNoticeSections(notices: $0, stationName: placeName, now: clock.now) }
    }

    var body: some View {
        if let noticeSections, !noticeSections.isEmpty {
            section(.stationNoticesSectionClosures, rows: noticeSections.closures)
            section(.stationNoticesSectionNotices, rows: noticeSections.notices)
            section(.stationNoticesSectionLater, rows: noticeSections.later)
        } else {
            Section {
                if noticeSections != nil {
                    Text(emptyText)
                        .foregroundStyle(.secondary)
                } else if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text(.stationNoticesUnavailable)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text(.stationNoticesSectionNotices)
            }
        }
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
}

/// The location part of a Station or Stop info sheet: a map, then links to Maps.
struct LocationSection: View {
    let name: String
    let location: LocationCoordinate

    private var mapURL: URL? {
        URL(string: "https://maps.apple.com?q=\(location.lat),\(location.lon)")
    }

    private var directionsURL: URL? {
        URL(string: "https://maps.apple.com?daddr=\(location.lat),\(location.lon)&dirflg=w")
    }

    var body: some View {
        Section {
            LocationMapView(name: name, location: location)
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

private struct LocationMapView: View {
    let name: String
    let location: LocationCoordinate
    @State private var position: MapCameraPosition = .automatic

    private var coordinate: CLLocationCoordinate2D {
        location.toCLLocation().coordinate
    }

    var body: some View {
        // A draggable map inside a resizable sheet catches swipes meant for the sheet
        Map(position: $position, interactionModes: []) {
            UserAnnotation()
            Marker(coordinate: coordinate) {
                Label(name, systemImage: "mappin")
            }
        }
        .mapStyle(.standard(pointsOfInterest: .including([.publicTransport])))
        .task {
            position = .camera(.init(centerCoordinate: coordinate, distance: 1500))
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
