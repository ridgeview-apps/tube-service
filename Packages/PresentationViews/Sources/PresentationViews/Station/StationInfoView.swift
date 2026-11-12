import MapKit
import Models
import SwiftUI

/// The lower part of the Station screen: journey planning and location.
struct StationInfoView: View {

    enum Action {
        case planJourneyFromHere
        case planJourneyToHere
    }

    let station: Station
    let onAction: (Action) -> Void

    @State private var isLocationExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            planJourneySection
            locationSection
        }
    }

    // MARK: - Plan a journey

    private var planJourneySection: some View {
        StationSection {
            VStack(spacing: 0) {
                planJourneyButton(.stationPlanJourneyFromHereButtonTitle) { onAction(.planJourneyFromHere) }
                Divider().padding(.leading, 16)
                planJourneyButton(.stationPlanJourneyToHereButtonTitle) { onAction(.planJourneyToHere) }
            }
        } header: {
            Text(.stationPlanJourneySectionHeaderTitle)
        }
    }

    private func planJourneyButton(_ title: LocalizedStringResource, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
            .padding()
        }
        .buttonStyle(.plain)
    }

    // MARK: - Location

    private var mapURL: URL? {
        URL(string: "https://maps.apple.com?q=\(station.location.lat),\(station.location.lon)")
    }

    private var directionsURL: URL? {
        URL(string: "https://maps.apple.com?daddr=\(station.location.lat),\(station.location.lon)&dirflg=w")
    }

    private var locationSection: some View {
        StationSection {
            DisclosureGroup(isExpanded: $isLocationExpanded.animation()) {
                // Built only once expanded, so the map isn't loaded on every visit
                if isLocationExpanded {
                    VStack(spacing: 0) {
                        StationMapView(station: station)
                            .frame(height: 200)
                        if let mapURL {
                            Divider()
                            linkView(url: mapURL, text: .stationLocationShowInMapsButtonTitle)
                        }
                        if let directionsURL {
                            Divider()
                            linkView(url: directionsURL, text: .stationLocationDirectionsButtonTitle)
                        }
                    }
                    .padding(.top, 12)
                }
            } label: {
                Text(.stationLocationSectionHeaderTitle)
                    .foregroundStyle(.primary)
            }
            .padding()
        }
    }

    private func linkView(url: URL, text: LocalizedStringResource) -> some View {
        Link(destination: url) {
            HStack {
                Text(text)
                Spacer()
                Image(systemName: "arrow.up.forward.square")
            }
        }
        .foregroundStyle(.link)
        .padding(.vertical)
    }
}

struct StationMapView: View {
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
        .clipShape(.rect(cornerRadius: 8))
        .task {
            position = .camera(.init(centerCoordinate: stationCoordinate, distance: 1500))
        }
    }
}
