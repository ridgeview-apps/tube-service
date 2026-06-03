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
    public let disruptionMessages: [String]
    
    public init(station: Station,
                loadingState: LoadingState,
                statusCells: [LineStatusCell.Style],
                disruptionMessages: [String]) {
        self.station = station
        self.loadingState = loadingState
        self.statusCells = statusCells
        self.disruptionMessages = disruptionMessages
    }
    
    private var mapURL: URL? {
        URL(string: "https://maps.apple.com?q=\(station.location.lat),\(station.location.lon)")
    }
    
    private var directionsURL: URL? {
        URL(string: "https://maps.apple.com?daddr=\(station.location.lat),\(station.location.lon)&dirflg=w")
    }
    
    public var body: some View {
        List {
            Group {
                locationSection
                disruptionsSection
                lineStatusSection
                liveArrivalsSection
            }
            .lineGroupListRowStyle()
        }
        .environment(\.defaultMinListRowHeight, 0)
        .defaultMaxWidthWithFullBackground()
        .background(Color.defaultBackground)
        .withHardScrollEdgeEffectStyle()
    }
    
    
    // MARK: - Location section
    
    private var locationSection: some View {
        Section {
            Group {
                StationMapView(station: station)
                    .frame(height: 200)
                if let mapURL {
                    linkView(
                        url: mapURL,
                        text: .stationLocationShowInMapsButtonTitle
                    )
                }
                if let directionsURL {
                    linkView(
                        url: directionsURL,
                        text: .stationLocationDirectionsButtonTitle
                    )
                }
            }
            .listRowInsets(.zero)
        } header: {
            Text(.stationLocationSectionHeaderTitle)
                .secondarySectionHeaderStyle()
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
            Section {
                DisruptionsCell(disruptionMessages: disruptionMessages)
                    .frame(minHeight: 52)
            } header: {
                Text(.stationDisruptionsSectionHeaderTitle)
                    .secondarySectionHeaderStyle()
            }
        }
    }
    

    // MARK: - Status section
    
    private var lineStatusSection: some View {
        Section {
            ForEach(statusCells, id: \.self) { cellStyle in
                if case let .singleLine(line) = cellStyle {
                    LineStatusCell(style: cellStyle, showsAccessory: true)
                        .frame(minHeight: 60)
                        .overlay {
                            NavigationLink(value: Selection.lineStatusDetail(line)) {
                                EmptyView()
                            }.opacity(0)
                        }
                        .cardStyle(borderColor: Color.defaultCellBackground)
                        .padding(.top, cellStyle == statusCells.first ? 12 : 4)
                        .padding(.horizontal, 16)
                        .padding(.bottom, cellStyle == statusCells.last ? 12 : 4)
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(.zero)
            .listRowBackground(Color(uiColor: .secondarySystemBackground))
        } header: {
            statusSectionHeader
                .secondarySectionHeaderStyle()
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
    
    @ViewBuilder private var liveArrivalsSection: some View {
        Section {
            ForEach(station.lineGroups.sortedByName()) { lineGroup in
                NavigationLink(value: Selection.arrivalsBoards(stationName: station.name, lineGroup)) {
                    LineGroupCell(style: .plain,
                                  lineIDs: lineGroup.lineIds.sortedByName(),
                                  title: lineGroup.name)
                    .frame(minHeight: 52)
                }
            }
        } header: {
            Text(.stationArrivalsSectionHeaderTitle)
                .secondarySectionHeaderStyle()
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
    var disruptionMessages: [String] = []
    
    var body: some View {
        NavigationStack {
            StationView(station: ModelStubs.kingsCrossStation,
                        loadingState: loadingState,
                        statusCells: statusCells,
                        disruptionMessages: disruptionMessages)
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
    WrapperView(disruptionMessages: ["The escalator to platform 5 is closed",
                                     "The lifts are bust"])
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
            position = .camera(.init(centerCoordinate: stationCoordinate,
                                     distance: 1500))
        }
    }
}
