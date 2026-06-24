import Shared
import SwiftUI
import Models

public struct LocatedStationsView: View {

    public enum Action: Sendable {
        case tappedRefresh
        case tappedStation(Station)
    }

    let locationUIStatus: LocationUIStatus
    let onAction: (Action) -> Void

    @Binding var sectionState: LocatedStationsResultsSectionState

    // MARK: - Init

    public init(
        locationUIStatus: LocationUIStatus,
        onAction: @escaping (Action) -> Void,
        sectionState: Binding<LocatedStationsResultsSectionState>
    ) {
        self.locationUIStatus = locationUIStatus
        self.onAction = onAction
        self._sectionState = sectionState
    }


    // MARK: Layout

    public var body: some View {
        locatedStationsListView
            .locationUIStatus(locationUIStatus)
            .defaultMaxWidthWithFullBackground()
            .frame(maxHeight: .infinity)
            .background(Color.defaultBackground)
            .accessibilityIdentifier("acc.id.nearby.stations")
    }

    @ViewBuilder private var locatedStationsListView: some View {
        ScrollViewReader { reader in
            List {
                resultsSectionView
                    .onChange(of: sectionState.currentPageNo) { _, newValue in
                        withAnimation {
                            reader.scrollTo("showMoreButtonID_\(newValue)")
                        }
                    }
                showMoreResultsButton
            }
            .listSectionSpacing(0)
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
                    zeroResultsView
                case .loaded, .loading:
                    populatedResultsView
                case .failure:
                    errorView
                }
            }
        } header: {
            resultsHeaderView
        }
        .lineGroupListRowStyle()
    }


    @ViewBuilder private var resultsHeaderView: some View {
        if let loadingState = locationUIStatus.loadingState {
            LoadingStatusView(loadingState: loadingState)
                .defaultLoadingStatusStyle()
        }
    }

    private var visibleStations: [LocatedStation] {
        let currentPageNo = sectionState.currentPageNo
        let pageSize = sectionState.pageSize

        return Array(sectionState.stations.prefix(currentPageNo * pageSize))
    }

    private var zeroResultsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(.nearbyStationsNoResults)
            refreshButton
        }
    }

    @ViewBuilder
    private var populatedResultsView: some View {
        ForEach(visibleStations, id: \.station.id) { locatedStation in
            Button {
                onAction(.tappedStation(locatedStation.station))
            } label: {
                StationLineGroupCell(
                    style: .distance(metres: locatedStation.distance),
                    station: locatedStation.station
                )
                .frame(minHeight: 52)
            }
            .buttonStyle(.plain)
        }
    }

    private var errorView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(.nearbyStationsLoadFailureTitle)
                .font(.headline)
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

    @ViewBuilder private var showMoreResultsButton: some View {
        if canShowMoreResults {
            Section {
                HStack {
                    Spacer()
                    PagerButton(
                        style: .down,
                        title: .nearbyStationsMoreResultsButtonTitle
                    ) {
                        sectionState.currentPageNo += 1
                    }
                    Spacer()
                }
                .id("showMoreButtonID_\(sectionState.currentPageNo)")
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
        }
    }

    private var canShowMoreResults: Bool {
        let currentPageNo = sectionState.currentPageNo
        let pageSize = sectionState.pageSize

        return sectionState.stations.count > (currentPageNo * pageSize)
    }
}

// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    var locationUIStyle: LocationUIStatus.Style
    var onAction: (LocatedStationsView.Action) -> Void = { print($0) }
    @State var currentPageNo = 1
    @State var sectionState: LocatedStationsResultsSectionState = .init(stations: [])
    var pagedResultsSize: Int = 5

    var locationUIStatus: LocationUIStatus {
        .init(style: locationUIStyle) {
            print("Location allowed")
        }
    }

    var body: some View {
        NavigationStack {
            LocatedStationsView(
                locationUIStatus: locationUIStatus,
                onAction: onAction,
                sectionState: $sectionState
            )
            .navigationTitle("Nearby stations")
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
    Previewer(
        locationUIStyle: .locationAllowed(.loading),
        sectionState: .init(stations: [])
    )
}

#Preview("Loaded - stations found") {
    Previewer(
        locationUIStyle: .locationAllowed(.loaded),
        sectionState: .init(
            stations: [
                ModelStubs.locatedStationWoodsidePark,
                ModelStubs.locatedStationWestFinchley,
                ModelStubs.locatedStationTotteridgeAndWhetstone,
                ModelStubs.locatedStationFinchleyCentral
            ],
            pageSize: 2
        ),
        pagedResultsSize: 1
    )
}

#Preview("Error") {
    Previewer(
        locationUIStyle: .locationAllowed(.failure(errorMessage: "Oops something went wrong")),
        sectionState: .init(stations: [])
    )
}


#Preview("Loaded - zero results") {
    Previewer(
        locationUIStyle: .locationAllowed(.loaded),
        sectionState: .init(stations: [])
    )
}
