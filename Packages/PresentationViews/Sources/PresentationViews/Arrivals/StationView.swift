import SwiftUI
import Models
import MapKit

public struct StationView: View {
    
    public enum Selection: Hashable {
        case line(Line)
        case lineGroup(Station.LineGroup)
    }
    
    public let station: Station
    public let loadingState: LoadingState
    public let statusCells: [LineStatusCell.Style]
    public let disruptionMessages: [String]
    @Binding var selection: Selection?
    
    public init(station: Station,
                loadingState: LoadingState,
                statusCells: [LineStatusCell.Style],
                disruptionMessages: [String],
                selection: Binding<Selection?>) {
        self.station = station
        self.loadingState = loadingState
        self.statusCells = statusCells
        self.disruptionMessages = disruptionMessages
        self._selection = selection
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
            .listRowBackground(Color.defaultCellBackground)
            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            
        }
        .listStyle(.plain)
        .defaultScrollContentBackgroundColor()
        .withDefaultMaxWidth()
        .background(Color.defaultBackground)
        .withHardScrollEdgeEffectStyle()
    }
    
    
    // MARK: - Location section
    
    private var locationSection: some View {
        Section {
            StationMapView(station: station)
                .frame(height: 200)
            if let mapURL {
                Link(destination: mapURL) {
                    Text(.stationLocationShowInMapsButtonTitle)
                }
                .foregroundStyle(.link)
                .padding(.horizontal)
            }
            if let directionsURL {
                Link(destination: directionsURL) {
                    Text(.stationLocationDirectionsButtonTitle)
                }
                .foregroundStyle(.link)
                .padding(.horizontal)
            }
        } header: {
            Text(.stationLocationSectionHeaderTitle)
                .sectionHeaderStyle()

            
        }
        .listRowInsets(.zero)
    }
    
    
    // MARK: - Disruption section
    
    @ViewBuilder private var disruptionsSection: some View {
        if !disruptionMessages.isEmpty {
            Section {
                DisruptionsCell(disruptionMessages: disruptionMessages)
            } header: {
                Text(.stationDisruptionsSectionHeaderTitle)
            }
        }
    }
    

    // MARK: - Status section
    
    private var lineStatusSection: some View {
        Section {
            ForEach(statusCells, id: \.self) { cellStyle in
                if case let .singleLine(line, _) = cellStyle {
                    LineStatusCell(style: cellStyle, showsAccessory: true)
                        .cardStyle(cornerRadius: 8)
                        .frame(minHeight: 52)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .overlay {
                            NavigationLink(value: Selection.line(line)) {
                                EmptyView()
                            }.opacity(0)
                        }
                }
            }
        } header: {
            statusSectionHeader
                .sectionHeaderStyle()
        }
        .listRowInsets(.zero)
        .listRowBackground(Color.defaultBackground)
        .listRowSeparator(.hidden)
    }
    
    private var statusSectionHeader: some View {
        HStack(spacing: 8) {
            Text(.stationStatusSectionHeaderTitle)
            Spacer()
            RefreshStatusView(loadingState: loadingState, refreshDate: nil)
                .font(.footnote)
                .foregroundStyle(Color.adaptiveMidGrey2)
        }
    }
    
    
    // MARK: - Live Arrivals section
    
    @ViewBuilder private var liveArrivalsSection: some View {
        Section {
            ForEach(station.lineGroups.sortedByName()) { lineGroup in
                NavigationLink(value: Selection.lineGroup(lineGroup)) {
                    LineGroupCell(style: .plain,
                                  lineIDs: lineGroup.lineIds.sortedByName(),
                                  title: lineGroup.name)
                    .frame(minHeight: 44)
                }
            }
        } header: {
            Text(.stationArrivalsSectionHeaderTitle)
                .sectionHeaderStyle()
        }
        

    }
}

private extension View {
    func sectionHeaderStyle() -> some View {
        self
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .listRowInsets(.zero)
            .background(Color.defaultBackground)
    }
}

// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    @State var selection: StationView.Selection?
    var loadingState: LoadingState = .loaded
    var statusCells: [LineStatusCell.Style] =
        [
            .singleLine(.init(id: .circle, lineStatuses: [.goodService]), showFavouriteImage: false),
            .singleLine(.init(id: .hammersmithAndCity, lineStatuses: [.goodService]), showFavouriteImage: false),
            .singleLine(.init(id: .metropolitan, lineStatuses: [.goodService]), showFavouriteImage: false),
            .singleLine(.init(id: .northern, lineStatuses: [.goodService]), showFavouriteImage: false),
            .singleLine(.init(id: .piccadilly, lineStatuses: [.goodService]), showFavouriteImage: false),
            .singleLine(.init(id: .victoria, lineStatuses: [.goodService]), showFavouriteImage: false)
        ]
    var disruptionMessages: [String] = []
    
    var body: some View {
        NavigationStack {
            StationView(station: ModelStubs.kingsCrossStation,
                        loadingState: loadingState,
                        statusCells: statusCells,
                        disruptionMessages: disruptionMessages,
                        selection: $selection)
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
