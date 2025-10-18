import Shared
import SwiftUI
import Models

public struct NearbyStationsView: View {
    
    public enum Action: Sendable {
        case tappedRefresh
    }
    
    let locationUIStatus: LocationUIStatus
    let onAction: (Action) -> Void
    
    @Binding var sectionState: NearbyStationsResultsSectionState
    @Binding var selection: NearbyStation?
    
    // MARK: - Init
    
    public init(locationUIStatus: LocationUIStatus,
                onAction: @escaping (Action) -> Void,
                sectionState: Binding<NearbyStationsResultsSectionState>,
                selection: Binding<NearbyStation?>) {
        self.locationUIStatus = locationUIStatus
        self.onAction = onAction
        self._sectionState = sectionState
        self._selection = selection
    }
    
    
    // MARK: Layout
    
    public var body: some View {
        nearbyStationsListView
            .locationUIStatus(locationUIStatus)
            .withDefaultMaxWidth()
            .frame(maxHeight: .infinity)
            .background(Color.defaultBackground)
            .accessibilityIdentifier("acc.id.nearby.stations")
    }
    
    @ViewBuilder private var nearbyStationsListView: some View {
        ScrollViewReader { reader in
            List(selection: $selection) {
                Group {
                    resultsSectionView
                        .onChange(of: sectionState.currentPageNo) { _, newValue in
                            withAnimation {
                                reader.scrollTo("showMoreButtonID_\(newValue)")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .defaultScrollContentBackgroundColor()
            .accessibilityIdentifier("acc.id.nearby.stations.list")
            .animation(.default, value: sectionState.currentPageNo)
        }
    }
    
    @ViewBuilder private var resultsSectionView: some View {
        Section {
            if let loadingState = locationUIStatus.loadingState {
                switch loadingState {
                case .loaded where visibleStations.isEmpty:
                    zeroResultsView()
                case .loaded, .loading:
                    ForEach(visibleStations, id: \.station.id) { nearbyStation in
                        NavigationLink(value: nearbyStation) {
                            StationLineGroupCell(
                                style: .distance(metres: nearbyStation.distance),
                                station: nearbyStation.station
                            )
                        }
                    }
                case .failure:
                    errorView
                }
            }
        } header: {
            resultsHeaderView
        } footer: {
            resultsFooterView
        }
        .lineGroupListRowStyle()
    }
    
    @ViewBuilder private var resultsHeaderView: some View {
        if let loadingState = locationUIStatus.loadingState, loadingState != .loaded {
            RefreshStatusView(loadingState: loadingState, refreshDate: nil)
                .font(.footnote)
                .foregroundStyle(Color.adaptiveMidGrey2)
        }
    }
    
    private var visibleStations: [NearbyStation] {
        let currentPageNo = sectionState.currentPageNo
        let pageSize = sectionState.pageSize
        
        return Array(sectionState.nearbyStations.prefix(currentPageNo * pageSize))
    }
    
    private func zeroResultsView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(.nearbyStationsNoResults)
            refreshButton
        }
    }
    
    private var errorView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(.nearbyStationsLoadFailureTitle)
            refreshButton
        }
    }
    
    private var refreshButton: some View {
        Button {
            onAction(.tappedRefresh)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.clockwise")
                Text(.refreshButtonTitle)
            }
        }
        .buttonStyle(.primary)
    }
    
    @ViewBuilder private var resultsFooterView: some View {
        if canShowMoreResults {
            Button {
                sectionState.currentPageNo += 1
            } label: {
                Text(.nearbyStationsMoreResultsButtonTitle)
            }
            .buttonStyle(.primary)
            .id("showMoreButtonID_\(sectionState.currentPageNo)")
            
        }
    }
    
    private var canShowMoreResults: Bool {
        let currentPageNo = sectionState.currentPageNo
        let pageSize = sectionState.pageSize
        
        return sectionState.nearbyStations.count > (currentPageNo * pageSize)
    }
}

// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    var locationUIStyle: LocationUIStatus.Style
    var onAction: (NearbyStationsView.Action) -> Void = { print($0) }
    @State var selection: NearbyStation?
    @State var currentPageNo = 1
    @State var sectionState: NearbyStationsResultsSectionState = .init(nearbyStations: [])
    var pagedResultsSize: Int = 5
    
    var locationUIStatus: LocationUIStatus {
        .init(style: locationUIStyle) {
            print("Location allowed")
        }
    }
    
    var body: some View {
        NavigationSplitView {
            NearbyStationsView(locationUIStatus: locationUIStatus,
                               onAction: onAction,
                               sectionState: $sectionState,
                               selection: $selection)
              .navigationTitle("Nearby stations")
        } detail: {
            if let selection {
                Text("\(String(describing: selection)) selected")
            } else {
                Text("No value selected")
            }
        }
    }
}


#Preview("Setup") {
    Previewer(locationUIStyle: .setUp(showsHeader: true))
}

#Preview("Permission denied") {
    Previewer(locationUIStyle: .openSettingsToAllowLocation)
}

#Preview("Loading") {
    Previewer(locationUIStyle: .locationAllowed(.loading),
              sectionState: .init(nearbyStations: []))
}

#Preview("Loaded - stations found") {
    Previewer(
        locationUIStyle: .locationAllowed(.loaded),
        sectionState: .init(
            nearbyStations: [
                .init(distance: 606.16, station: ModelStubs.woodsideParkStation),
                .init(distance: 1270.45, station: ModelStubs.westFinchleyStation),
                .init(distance: 1387.44, station: ModelStubs.totteridgeAndWhetstoneStation),
                .init(distance: 2216.50, station: ModelStubs.finchleyCentralStation)
            ],
            pageSize: 2
        ),
        pagedResultsSize: 1
    )
}

#Preview("Error") {
    Previewer(locationUIStyle: .locationAllowed(.failure(errorMessage: "Oops something went wrong")),
              sectionState: .init(nearbyStations: []))
}


#Preview("Loaded - zero results") {
    Previewer(locationUIStyle: .locationAllowed(.loaded),
              sectionState: .init(nearbyStations: []))
}
