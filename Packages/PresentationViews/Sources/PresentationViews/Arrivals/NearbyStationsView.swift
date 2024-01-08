import Shared
import SwiftUI
import Models

public struct NearbyStationsView: View {
    
    public enum Mode: Equatable {
        case setUp
        case permissionDenied
        case permissionGranted(LoadingState, [NearbyStation])
    }
    
    public enum Action {
        case tappedLocationButton
        case tappedRetryButton
    }
    
    let mode: Mode
    let pagedResultsSize: Int
    let onAction: (Action) -> Void
    @Binding var selection: NearbyStation?
    @Binding var currentPageNo: Int
    
    
    // MARK: - Init
    
    public init(mode: Mode,
                onAction: @escaping (Action) -> Void,
                selection: Binding<NearbyStation?>,
                currentPageNo: Binding<Int>,
                pagedResultsSize: Int = 5) {
        self.mode = mode
        self.onAction = onAction
        self._selection = selection
        self._currentPageNo = currentPageNo
        self.pagedResultsSize = pagedResultsSize
    }
    
    
    // MARK: Layout
    
    public var body: some View {
        Group {
            switch mode {
            case .setUp:
                setupView
            case .permissionDenied:
                permissionDeniedView
            case let .permissionGranted(loadingState, _):
                resultsView(with: loadingState)
            }
        }
        .withDefaultMaxWidth()
        .frame(maxHeight: .infinity)
        .background(Color.defaultBackground)
        .accessibilityIdentifier("acc.id.nearby.stations")
    }
    
    private var setupView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("nearby.stations.allow.access.header.title", bundle: .module)
            Button {
                onAction(.tappedLocationButton)
            } label: {
                Label {
                    Text("nearby.stations.allow.access.button.title", bundle: .module)
                } icon: {
                    Image(systemName: "location.fill")
                }
            }
            .buttonStyle(.primary)
            Text("nearby.stations.allow.access.footer.title", bundle: .module)
                .font(.caption)
        }
        .padding(.horizontal)
    }
    
    private var permissionDeniedView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Label {
                Text("nearby.stations.access.denied.message.title", bundle: .module)
            } icon: {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                    .imageScale(.large)
            }
            OpenSettingsButton()
                .buttonStyle(.primary)
        }
        .padding(.horizontal)
    }
    
    private var loadingView: some View {
        HStack {
            ProgressView {
                Text("nearby.stations.loading.title", bundle: .module)
            }
        }
    }
    
    @ViewBuilder private func resultsView(with loadingState: LoadingState) -> some View {
        ScrollViewReader { reader in
            List(selection: $selection) {
                Section {
                    if loadingState == .loaded && visibleStations.isEmpty {
                        emptyResultsView()
                    }
                    if case .failure = loadingState {
                        errorView
                    }
                    ForEach(visibleStations, id: \.station.id) { nearbyStation in
                        NavigationLink(value: nearbyStation) {
                            LineGroupCell(style: .distance(metres: nearbyStation.distance),
                                          lineIDs: nearbyStation.station.sortedLineIDs,
                                          title: nearbyStation.station.name)
                        }
                    }
                } header: {
                    resultsHeaderView(with: loadingState)
                } footer: {
                    showMoreButton
                }
                .lineGroupListRowStyle()
                .onChange(of: currentPageNo) { newValue in
                    withAnimation {
                        reader.scrollTo("showMoreButtonID_\(newValue)")
                    }
                }
            }
            .listStyle(.plain)
            .defaultScrollContentBackgroundColor()
            .accessibilityIdentifier("acc.id.nearby.stations.list")
            .animation(.default, value: currentPageNo)
        }
    }
    
    @ViewBuilder private func resultsHeaderView(with loadingState: LoadingState) -> some View {
        switch loadingState {
        case .loading, .failure:
            RefreshStatusView(loadingState: loadingState, refreshDate: nil)
                .font(.footnote)
                .foregroundStyle(Color.adaptiveMidGrey2)
        case .loaded:
            EmptyView()
        }
    }
    
    private var visibleStations: [NearbyStation] {
        switch mode {
        case .setUp, .permissionDenied:
            return []
        case .permissionGranted(_, let allStations):
            return Array(allStations.prefix(currentPageNo * pagedResultsSize))
        }
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
            onAction(.tappedRetryButton)
        } label: {
            Label {
                Text("refresh.button.title", bundle: .module)
            } icon: {
                Image(systemName: "arrow.clockwise")
            }
        }
        .buttonStyle(.primary)
    }
    
    @ViewBuilder private var showMoreButton: some View {
        if canShowMoreResults {
            Button {
                currentPageNo += 1
            } label: {
                Text("nearby.stations.more.results.button.title", bundle: .module)
            }
            .buttonStyle(.primary)
            .id("showMoreButtonID_\(currentPageNo)")
            
        }

    }
    
    private var canShowMoreResults: Bool {
        guard case let .permissionGranted(.loaded, stations) = mode else {
            return false
        }

        return stations.count > (currentPageNo * pagedResultsSize)
    }
}


// MARK: - Previews

#if DEBUG
private struct WrapperView: View  {
    var mode: NearbyStationsView.Mode
    var onAction: (NearbyStationsView.Action) -> Void = {
        switch $0 {
        case .tappedLocationButton: print("Permissions prompt tapped")
        case .tappedRetryButton: print("Retry button tapped")
        }
    }
    @State var selection: NearbyStation?
    @State var currentPageNo = 1
    var pagedResultsSize: Int = 5
    
    var body: some View {
        NavigationSplitView {
            NearbyStationsView(mode: mode,
                               onAction: onAction,
                               selection: $selection,
                               currentPageNo: $currentPageNo,
                               pagedResultsSize: pagedResultsSize)
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
    WrapperView(mode: .setUp)
}

#Preview("Permission denied") {
    WrapperView(mode: .permissionDenied)
}

#Preview("Error") {
    WrapperView(mode: .permissionGranted(.failure(errorMessage: "Oops something went wrong"), []))
}

#Preview("Loading") {
    WrapperView(mode: .permissionGranted(.loading, []))
}

#Preview("Loaded - stations found") {
    WrapperView(
        mode: .permissionGranted(.loaded, [
            .init(distance: 606.16, station: ModelStubs.woodsideParkStation),
            .init(distance: 1270.45, station: ModelStubs.westFinchleyStation),
            .init(distance: 1387.44, station: ModelStubs.totteridgeAndWhetstoneStation),
            .init(distance: 2216.50, station: ModelStubs.finchleyCentralStation)
        ]),
        pagedResultsSize: 1
    )
}

#Preview("Loaded - zero results") {
    WrapperView(mode: .permissionGranted(.loaded, []))
}

#endif
