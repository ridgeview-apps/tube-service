import Models
import Shared
import SwiftUI

public struct JourneyLocationPickerView: View {

    public let sections: [JourneyLocationPicker.SectionState]
    public let locationAccess: LocationAccess
    public let onAction: (JourneyLocationPicker.Action) -> Void

    @Binding public var searchTerm: String
    @FocusState private var showKeyboard

    public init(
        searchTerm: Binding<String>,
        sections: [JourneyLocationPicker.SectionState],
        locationAccess: LocationAccess,
        onAction: @escaping (JourneyLocationPicker.Action) -> Void
    ) {
        self._searchTerm = searchTerm
        self.sections = sections
        self.locationAccess = locationAccess
        self.onAction = onAction
    }

    public var body: some View {
        VStack {
            searchTextFieldSection
            List {
                ForEach(sections) { sectionState in
                    pickerValuesSection(with: sectionState)
                }
            }
            .accessibilityIdentifier(AccessibilityID.JourneyLocationPicker.list)
            .defaultScrollContentBackgroundColor()
            .onChange(of: searchTerm, debounceTime: .milliseconds(300)) { newValue in
                onAction(.searchTermChanged(newValue))
            }

        }
        .onAppear {
            showKeyboard = true
        }
    }

    private var searchTextFieldSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField(text: $searchTerm) {
                Text(.journeyPlannerLocationPickerPlaceholderText)
            }
            .clearButton(text: $searchTerm)
            .focused($showKeyboard)
            .autocorrectionDisabled()
            .accessibilityIdentifier(AccessibilityID.JourneyLocationPicker.searchField)
        }
        .padding(10)
        .background(Color(.tertiarySystemFill), in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }


    @ViewBuilder
    private func pickerValuesSection(with sectionState: JourneyLocationPicker.SectionState) -> some View {
        if !sectionState.values.isEmpty {
            Section {
                ForEach(sectionState.values, id: \.self) { value in
                    selectableRow(for: value)
                        .accessibilityIdentifier(
                            AccessibilityID.JourneyLocationPicker.searchResult,
                            isEnabled: sectionState.isSearchResults
                        )
                }
            } header: {
                HStack(spacing: 4) {
                    Image(systemName: sectionState.sectionIcon)
                    Text(sectionState.sectionTitle)
                }
                .secondarySectionHeaderStyle()
            }
            .lineGroupListRowStyle()
        }
    }

    @ViewBuilder
    private func selectableRow(for value: JourneyLocationPicker.Value) -> some View {
        if value.isCurrentLocation, locationAccess.state == .denied {
            HStack {
                rowLabel(forValue: value)
                Spacer()
                OpenSettingsButton()
            }
        } else {
            Button {
                if value.isCurrentLocation, locationAccess.state == .notAsked {
                    locationAccess.onRequestPermissions()
                } else {
                    onAction(.valueSelected(value))
                }
            } label: {
                rowLabel(forValue: value)
            }
        }
    }

    private func rowLabel(forValue value: JourneyLocationPicker.Value) -> some View {
        HStack(alignment: .top, spacing: 4) {
            switch value {
            case .station(let station):
                StationLineGroupCell(station: station)
            case .nationalRail(let stopPoint):
                HStack(spacing: 8) {
                    Image("national-rail", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .padding(2)
                        .frame(width: 40)
                        .foregroundStyle(Color.nationalRail)
                    Text(stopPoint.sanitizedName ?? "")
                }
            case .namedLocation(let location):
                if location.isCurrentLocation {
                    Text(Image(systemName: "location.fill"))
                        .imageScale(.small)
                    VStack(alignment: .leading) {
                        Text(.journeyPlannerLocationValueCurrentLocation)
                        currentLocationSubtitle(for: location)
                    }
                } else {
                    if let name = location.name {
                        VStack(alignment: .leading) {
                            Text(name.title)
                            if !name.subtitle.isEmpty {
                                Text(name.subtitle)
                                    .font(.footnote)
                            }
                        }
                    }
                }
            }
        }
        .foregroundStyle(.foreground)
    }

    @ViewBuilder
    private func currentLocationSubtitle(for location: JourneyLocationPicker.NamedLocationValue) -> some View {
        switch locationAccess.state {
        case .notAsked:
            Text(.locationAccessAllowSubtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
        case .denied:
            Text(.locationAccessOffSubtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
        case .allowed:
            if let locationTitle = location.name?.formattedSingleLineTitle, !locationTitle.isEmpty {
                Text(locationTitle)
                    .font(.footnote)
            }
        }
    }
}

private extension JourneyLocationPicker.SectionState {

    var isSearchResults: Bool {
        if case .searchResults = sectionID { true } else { false }
    }

    var sectionIcon: String {
        switch sectionID {
        case .suggestions:
            "sparkles"
        case .nearbyStations:
            "location"
        case .searchResults:
            "magnifyingglass"
        }
    }

    var sectionTitle: LocalizedStringResource {
        switch sectionID {
        case .suggestions:
            .journeyLocationPickerSuggestionsSectionTitle
        case .nearbyStations:
            .journeyLocationPickerNearbyStationsSectionTitle
        case let .searchResults(count):
            .journeyLocationSearchResultsCount(count)
        }
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    @State var searchTerm: String = ""
    var sections: [JourneyLocationPicker.SectionState]
    var locationAccess: LocationAccess = .init(state: .allowed(.loaded)) {
        print("Permissions requested")
    }

    var body: some View {
        JourneyLocationPickerView(
            searchTerm: $searchTerm,
            sections: sections,
            locationAccess: locationAccess
        ) {
            print("Action \($0)")
        }
    }
}

#Preview("Suggestions") {
    Previewer(
        sections: [
            .init(
                sectionID: .suggestions,
                values: [
                    .unknownCurrentLocation,
                    .station(ModelStubs.eastFinchleyStation),
                    .nationalRail(ModelStubs.twickenhamRailStation)
                ]
            ),
            .init(
                sectionID: .nearbyStations,
                values: [
                    .station(ModelStubs.angelStation),
                    .station(ModelStubs.eastFinchleyStation)
                ]
            )
        ]
    )
}

#Preview("Suggestions - location setup") {
    Previewer(
        sections: [
            .init(
                sectionID: .suggestions,
                values: [
                    .unknownCurrentLocation
                ]
            )
        ],
        locationAccess: .init(
            state: .notAsked,
            onRequestPermissions: {
                print("Request permissions")
            }
        )
    )
}

#Preview("Suggestions - location denied") {
    Previewer(
        sections: [
            .init(
                sectionID: .suggestions,
                values: [
                    .unknownCurrentLocation
                ]
            )
        ],
        locationAccess: .init(
            state: .denied,
            onRequestPermissions: {
                print("Request permissions")
            }
        )
    )
}

#Preview("Search results") {
    Previewer(
        searchTerm: "station",
        sections: [
            .init(
                sectionID: .searchResults(count: 4),
                values: [
                    .unknownCurrentLocation,
                    .station(ModelStubs.eastFinchleyStation),
                    .nationalRail(ModelStubs.twickenhamRailStation),
                    .namedLocation(
                        .init(
                            name: .init(
                                title: "Search result title",
                                subtitle: "Search result subtitle"
                            ),
                            coordinate: nil,
                            isCurrentLocation: false
                        )
                    )
                ]
            )
        ]
    )
}
