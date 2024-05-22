import Shared
import SwiftUI
import Models

public struct NearbyStationsView: View {
    
    public enum Action {
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
                resultsSectionView
                    .onChange(of: sectionState.currentPageNo) { _, newValue in
                        withAnimation {
                            reader.scrollTo("showMoreButtonID_\(newValue)")
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
            if sectionState.loadingState == .loaded && visibleStations.isEmpty {
                emptyResultsView()
            }
            if case .failure = sectionState.loadingState {
                errorView
            }
            ForEach(visibleStations, id: \.station.id) { nearbyStation in
                NavigationLink(value: nearbyStation) {
                    StationLineGroupCell(
                        style: .distance(metres: nearbyStation.distance),
                        station: nearbyStation.station
                    )
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
        switch sectionState.loadingState {
        case .loading, .failure:
            VStack {
                if let headerTitle = sectionState.headerTitle {
                    Text(headerTitle)
                }
                RefreshStatusView(loadingState: sectionState.loadingState, refreshDate: nil)
                    .font(.footnote)
                    .foregroundStyle(Color.adaptiveMidGrey2)
            }
        case .loaded:
            EmptyView()
        }
    }
    
    private var visibleStations: [NearbyStation] {
        let currentPageNo = sectionState.currentPageNo
        let pageSize = sectionState.pageSize
        
        return Array(sectionState.nearbyStations.prefix(currentPageNo * pageSize))
    }
    
    private func emptyResultsView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("nearby.stations.no.results", bundle: .module)
            refreshButton
        }
    }
    
    private var errorView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("nearby.stations.load.failure.title", bundle: .module)
            refreshButton
        }
    }
    
    private var refreshButton: some View {
        Button {
            onAction(.tappedRefresh)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.clockwise")
                Text("refresh.button.title", bundle: .module)
            }
        }
        .buttonStyle(.primary)
    }
    
    @ViewBuilder private var resultsFooterView: some View {
        if canShowMoreResults {
            Button {
                sectionState.currentPageNo += 1
            } label: {
                Text("nearby.stations.more.results.button.title", bundle: .module)
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
    @State var sectionState: NearbyStationsResultsSectionState = .init(loadingState: .loaded, nearbyStations: [])
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
    Previewer(locationUIStyle: .locationAllowed,
              sectionState: .init(loadingState: .loading,
                                  nearbyStations: []))
}

#Preview("Loaded - stations found") {
    Previewer(
        locationUIStyle: .locationAllowed,
        sectionState: .init(
            loadingState: .loaded,
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
    Previewer(locationUIStyle: .locationAllowed,
              sectionState: .init(loadingState: .failure(errorMessage: "Oops something went wrong"),
                                  nearbyStations: []))
}


#Preview("Loaded - zero results") {
    Previewer(locationUIStyle: .locationAllowed,
              sectionState: .init(loadingState: .loaded,
                                  nearbyStations: []))
}
