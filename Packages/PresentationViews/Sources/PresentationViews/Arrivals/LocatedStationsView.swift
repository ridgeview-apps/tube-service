import Shared
import SwiftUI
import Models

public struct LocatedStationsView: View {

    public enum Action: Sendable {
        case tappedRefresh
        case tappedStation(Station)
    }

    let locationAccess: LocationAccess
    let onAction: (Action) -> Void

    @Binding var sectionState: LocatedStationsResultsSectionState

    // MARK: - Init

    public init(
        locationAccess: LocationAccess,
        onAction: @escaping (Action) -> Void,
        sectionState: Binding<LocatedStationsResultsSectionState>
    ) {
        self.locationAccess = locationAccess
        self.onAction = onAction
        self._sectionState = sectionState
    }


    // MARK: Layout

    public var body: some View {
        locatedStationsListView
            .defaultMaxWidthWithFullBackground()
            .frame(maxHeight: .infinity)
            .background(Color.defaultBackground)
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
            .accessibilityIdentifier(AccessibilityID.Nearby.list)
            .animation(.default, value: sectionState.currentPageNo)
        }
    }

    @ViewBuilder private var resultsSectionView: some View {
        Section {
            switch locationAccess.state {
            case .notAsked:
                allowLocationRow
            case .denied:
                locationOffRow
            case .allowed(.loaded) where visibleStations.isEmpty:
                zeroResultsView
            case .allowed(.loaded), .allowed(.loading):
                populatedResultsView
            case .allowed(.failure):
                errorView
            }
        } header: {
            resultsHeaderView
        }
        .lineGroupListRowStyle()
    }


    @ViewBuilder private var resultsHeaderView: some View {
        if let loadingState = locationAccess.loadingState {
            LoadingStatusView(loadingState: loadingState)
                .defaultLoadingStatusStyle()
        }
    }

    private var visibleStations: [LocatedStation] {
        let currentPageNo = sectionState.currentPageNo
        let pageSize = sectionState.pageSize

        return Array(sectionState.stations.prefix(currentPageNo * pageSize))
    }

    private var allowLocationRow: some View {
        Button {
            locationAccess.onRequestPermissions()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "location.fill")
                VStack(alignment: .leading, spacing: 2) {
                    Text(.locationAccessNearbyAllowTitle)
                    Text(.locationAccessNearbyAllowSubtitle)
                        .font(.footnote)
                        // A hierarchical style would be tinted by the button
                        .foregroundStyle(Color.secondary)
                }
            }
            .frame(minHeight: 52)
        }
    }

    private var locationOffRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "location.slash")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(.locationAccessNearbyOffTitle)
                Text(.locationAccessNearbyOffSubtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            OpenSettingsButton()
        }
        .frame(minHeight: 52)
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
            .accessibilityIdentifier(AccessibilityID.Nearby.station(locatedStation.station.id))
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
    var locationAccessState: LocationAccess.State
    var onAction: (LocatedStationsView.Action) -> Void = { print($0) }
    @State var currentPageNo = 1
    @State var sectionState: LocatedStationsResultsSectionState = .init(stations: [])
    var pagedResultsSize: Int = 5

    var locationAccess: LocationAccess {
        .init(state: locationAccessState) {
            print("Permissions requested")
        }
    }

    var body: some View {
        NavigationStack {
            LocatedStationsView(
                locationAccess: locationAccess,
                onAction: onAction,
                sectionState: $sectionState
            )
            .navigationTitle("Nearby stations")
        }
    }
}


#Preview("Setup") {
    Previewer(locationAccessState: .notAsked)
}

#Preview("Permission denied") {
    Previewer(locationAccessState: .denied)
}

#Preview("Loading") {
    Previewer(
        locationAccessState: .allowed(.loading),
        sectionState: .init(stations: [])
    )
}

#Preview("Loaded - stations found") {
    Previewer(
        locationAccessState: .allowed(.loaded),
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
        locationAccessState: .allowed(.failure(errorMessage: "Oops something went wrong")),
        sectionState: .init(stations: [])
    )
}


#Preview("Loaded - zero results") {
    Previewer(
        locationAccessState: .allowed(.loaded),
        sectionState: .init(stations: [])
    )
}
