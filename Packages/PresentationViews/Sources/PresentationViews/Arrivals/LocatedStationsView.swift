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

    private var resultsSectionView: some View {
        LocatedStationsSection(
            locationAccess: locationAccess,
            rows: visibleStations.map(StopRow.init),
            onAction: onAction
        )
    }

    private var visibleStations: [LocatedStation] {
        let currentPageNo = sectionState.currentPageNo
        let pageSize = sectionState.pageSize

        return Array(sectionState.stations.prefix(currentPageNo * pageSize))
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
