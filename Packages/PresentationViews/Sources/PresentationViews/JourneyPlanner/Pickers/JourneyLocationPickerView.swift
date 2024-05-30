import Models
import SwiftUI

public struct JourneyLocationPickerView: View {
    
    public let sections: [JourneyLocationPicker.SectionState]
    public let locationUIStatus: LocationUIStatus
    public let onAction: (JourneyLocationPicker.Action) -> Void
    
    @Binding public var searchTerm: String
    @FocusState private var showKeyboard
    
    public init(searchTerm: Binding<String>,
                sections: [JourneyLocationPicker.SectionState],
                locationUIStatus: LocationUIStatus,
                onAction: @escaping (JourneyLocationPicker.Action) -> Void) {
        self._searchTerm = searchTerm
        self.sections = sections
        self.locationUIStatus = locationUIStatus
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
            .listStyle(.plain)
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
        }
        .padding(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1.0)
                .fill(.tertiary)
        }
        .padding(.horizontal)
        
    }
    

    @ViewBuilder
    private func pickerValuesSection(with sectionState: JourneyLocationPicker.SectionState) -> some View {
        if !sectionState.values.isEmpty {
            Section {
                ForEach(sectionState.values, id: \.self) { value in
                    selectableRow(for: value)
                }
            } header: {
                Text(sectionState.sectionTitle)
            }
            .lineGroupListRowStyle()
        }
    }
    
    private func selectableRow(for value: JourneyLocationPicker.Value) -> some View {
        Button {
            onAction(.valueSelected(value))
        } label: {
            rowLabel(forValue: value)
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
                    Group {
                        Text(Image(systemName: "location.fill"))
                        VStack(alignment: .leading) {
                            Text(.journeyPlannerLocationValueCurrentLocation)
                            if let locationTitle = location.name?.formattedSingleLineTitle, !locationTitle.isEmpty {
                                Text(locationTitle)
                                    .font(.footnote)
                            }
                        }
                    }
                    .locationUIStatus(locationUIStatus)
                } else {
                    if let name = location.name {
                        VStack(alignment: .leading) {
                            Text(name.title)
                            Text(name.subtitle)
                                .font(.footnote)
                        }
                    }
                }
            }
        }
    }
}

private extension JourneyLocationPicker.SectionState {
    
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
    var locationUIStatus: LocationUIStatus = .init(style: .locationAllowed(.loaded)) {
        print("Location allowed")
    }
    
    var body: some View {
        JourneyLocationPickerView(
            searchTerm: $searchTerm,
            sections: sections,
            locationUIStatus: locationUIStatus
        ) {
            print("Action \($0)")
        }
    }
}

#Preview("Suggestions") {
    Previewer(
        sections: [
            .init(sectionID: .suggestions,
                  values: [
                    .unknownCurrentLocation,
                    .station(ModelStubs.eastFinchleyStation),
                    .nationalRail(ModelStubs.twickenhamRailStation)
                  ]),
            .init(sectionID: .nearbyStations,
                  values: [
                    .station(ModelStubs.angelStation),
                    .station(ModelStubs.eastFinchleyStation)
                  ])
        ]
    )
}

#Preview("Suggestions - location setup") {
    Previewer(
        sections: [
            .init(sectionID: .suggestions,
                  values: [
                    .unknownCurrentLocation
                  ])
        ],
        locationUIStatus: .init(style: .setUp(showsHeader: false), onRequestPermissions: {
            print("Request permissions")
        })
    )
}

#Preview("Suggestions - location denied") {
    Previewer(
        sections: [
            .init(sectionID: .suggestions,
                  values: [
                    .unknownCurrentLocation
                  ])
        ],
        locationUIStatus: .init(style: .openSettingsToAllowLocation, onRequestPermissions: {
            print("Request permissions")
        })
    )
}

#Preview("Search results") {
    Previewer(
        searchTerm: "station",
        sections: [
            .init(sectionID: .searchResults(count: 4),
                  values: [
                    .unknownCurrentLocation,
                    .station(ModelStubs.eastFinchleyStation),
                    .nationalRail(ModelStubs.twickenhamRailStation),
                    .namedLocation(.init(name: .init(title: "Search result title",
                                                     subtitle: "Search result subtitle"),
                                         coordinate: nil,
                                         isCurrentLocation: false))
                  ])
        ]
    )
}
