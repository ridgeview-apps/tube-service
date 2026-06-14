import SwiftUI
import Models
import MapKit

public struct StationView: View {

    public enum Selection: Hashable {
        case lineStatusDetail(Line)
        case arrivalsBoards(stationName: String, Station.LineGroup)
    }

    public let station: Station
    public let loadingState: LoadingState
    public let statusCells: [LineStatusCell.Style]
    public let earlierDisruptedLineIDs: Set<TrainLineID>
    public let disruptionMessages: [String]

    public init(
        station: Station,
        loadingState: LoadingState,
        statusCells: [LineStatusCell.Style],
        earlierDisruptedLineIDs: Set<TrainLineID>,
        disruptionMessages: [String]
    ) {
        self.station = station
        self.loadingState = loadingState
        self.statusCells = statusCells
        self.earlierDisruptedLineIDs = earlierDisruptedLineIDs
        self.disruptionMessages = disruptionMessages
    }

    private var mapURL: URL? {
        URL(string: "https://maps.apple.com?q=\(station.location.lat),\(station.location.lon)")
    }

    private var directionsURL: URL? {
        URL(string: "https://maps.apple.com?daddr=\(station.location.lat),\(station.location.lon)&dirflg=w")
    }

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                locationSection
                disruptionsSection
                lineStatusSection
                liveArrivalsSection
            }
            .padding(.vertical, 16)
        }
        .withDefaultMaxWidth()
        .background(Color.defaultBackground)
        .withHardScrollEdgeEffectStyle()
    }


    // MARK: - Section container

    private func section<Content: View, Header: View>(
        cardBackground: Bool = true,
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            header()
                .secondarySectionHeaderStyle()
                .padding(.horizontal, 32)
            Group {
                if cardBackground {
                    content()
                        .cardStyle()
                } else {
                    content()
                }
            }
            .padding(.horizontal, 16)
        }
    }


    // MARK: - Location section

    private var locationSection: some View {
        section {
            VStack(spacing: 0) {
                StationMapView(station: station)
                    .frame(height: 200)
                if let mapURL {
                    Divider()
                    linkView(
                        url: mapURL,
                        text: .stationLocationShowInMapsButtonTitle
                    )
                }
                if let directionsURL {
                    Divider()
                    linkView(
                        url: directionsURL,
                        text: .stationLocationDirectionsButtonTitle
                    )
                }
            }
        } header: {
            Text(.stationLocationSectionHeaderTitle)
        }
    }

    private func linkView(
        url: URL,
        text: LocalizedStringResource
    ) -> some View {
        Link(destination: url) {
            HStack {
                Text(text)
                Spacer()
                Image(systemName: "arrow.up.forward.square")
            }
        }
        .foregroundStyle(.link)
        .padding()
    }


    // MARK: - Disruption section

    @ViewBuilder private var disruptionsSection: some View {
        if !disruptionMessages.isEmpty {
            section {
                DisruptionsCell(disruptionMessages: disruptionMessages)
                    .frame(minHeight: 52)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
            } header: {
                Text(.stationDisruptionsSectionHeaderTitle)
            }
        }
    }


    // MARK: - Status section

    private var lineStatusSection: some View {
        section(cardBackground: false) {
            VStack(spacing: 8) {
                ForEach(statusCells, id: \.self) { cellStyle in
                    if case let .singleLine(line) = cellStyle {
                        NavigationLink(value: Selection.lineStatusDetail(line)) {
                            LineStatusCell(
                                style: cellStyle,
                                showsAccessory: true,
                                historyIndicator: line.historyIndicator(
                                    earlierDisruptedLineIDs: earlierDisruptedLineIDs
                                )
                            )
                            .frame(minHeight: 52)
                        }
                        .buttonStyle(.plain)
                        .cardStyle()
                    }
                }
            }
        } header: {
            statusSectionHeader
        }
    }

    private var statusSectionHeader: some View {
        HStack(spacing: 8) {
            Text(.stationStatusSectionHeaderTitle)
            Spacer()
            LoadingStatusView(loadingState: loadingState)
                .defaultLoadingStatusStyle()
        }
    }


    // MARK: - Live Arrivals section

    private var liveArrivalsSection: some View {
        let lineGroups = station.lineGroups.sortedByName()
        return section {
            VStack(spacing: 0) {
                ForEach(Array(lineGroups.enumerated()), id: \.element.id) { index, lineGroup in
                    NavigationLink(value: Selection.arrivalsBoards(stationName: station.name, lineGroup)) {
                        HStack(spacing: 8) {
                            LineGroupCell(
                                style: .plain,
                                lineIDs: lineGroup.lineIds.sortedByName(),
                                title: lineGroup.name
                            )
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .frame(minHeight: 52)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(.plain)
                    if index < lineGroups.count - 1 {
                        Divider().padding(.leading, 16)
                    }
                }
            }
        } header: {
            Text(.stationArrivalsSectionHeaderTitle)
        }
    }
}

// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    @State var selection: StationView.Selection?
    var loadingState: LoadingState = .loaded
    var statusCells: [LineStatusCell.Style] =
        [
            .singleLine(.init(id: .circle, lineStatuses: [.goodService])),
            .singleLine(.init(id: .hammersmithAndCity, lineStatuses: [.goodService])),
            .singleLine(.init(id: .metropolitan, lineStatuses: [.goodService])),
            .singleLine(.init(id: .northern, lineStatuses: [.goodService])),
            .singleLine(.init(id: .piccadilly, lineStatuses: [.goodService])),
            .singleLine(.init(id: .victoria, lineStatuses: [.goodService]))
        ]
    var earlierDisruptedLineIDs: Set<TrainLineID> = []
    var disruptionMessages: [String] = []

    var body: some View {
        NavigationStack {
            StationView(
                station: ModelStubs.kingsCrossStation,
                loadingState: loadingState,
                statusCells: statusCells,
                earlierDisruptedLineIDs: earlierDisruptedLineIDs,
                disruptionMessages: disruptionMessages
            )
            .navigationTitle("Station preview")
            .navigationDestination(for: StationView.Selection.self) { selection in
                Text("Selected \(String(describing: selection))")
            }
        }
    }
}

#Preview("Loaded state - normal") {
    WrapperView()
}

#Preview("Loaded state - disrupted") {
    WrapperView(disruptionMessages: [
        "The escalator to platform 5 is closed",
        "The lifts are bust"
    ])
}

#Preview("Loaded state - earlier disruption") {
    WrapperView(earlierDisruptedLineIDs: [.circle])
}


#Preview("Loading state") {
    WrapperView(loadingState: .loading)
}

#Preview("Failure state") {
    WrapperView(loadingState: .failure(errorMessage: "Loading failure"))
}


struct StationMapView: View {
    let station: Station
    @State private var position: MapCameraPosition = .automatic

    private var stationCoordinate: CLLocationCoordinate2D {
        station.location.toCLLocation().coordinate
    }

    var body: some View {
        Map(
            position: $position
        ) {
            UserAnnotation()
            Marker(coordinate: stationCoordinate) {
                Label(station.name, systemImage: "mappin")
            }
        }
        .mapStyle(.standard(pointsOfInterest: .including([.publicTransport])))
        .task {
            position = .camera(
                .init(
                    centerCoordinate: stationCoordinate,
                    distance: 1500
                )
            )
        }
    }
}
