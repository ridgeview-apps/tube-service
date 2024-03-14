import Models
import SwiftUI

public struct JourneyLocationPickerView: View {
    
    public let placeholder: LocalizedStringKey
    public let sections: [JourneyLocationPicker.SectionState]
    public let locationUIStatus: LocationUIStatus
    public let onAction: (JourneyLocationPicker.Action) -> Void
    
    @Binding public var searchTerm: String
    @FocusState private var showKeyboard
    
    public init(searchTerm: Binding<String>,
                placeholder: LocalizedStringKey,
                sections: [JourneyLocationPicker.SectionState],
                locationUIStatus: LocationUIStatus,
                onAction: @escaping (JourneyLocationPicker.Action) -> Void) {
        self._searchTerm = searchTerm
        self.placeholder = placeholder
        self.sections = sections
        self.locationUIStatus = locationUIStatus
        self.onAction = onAction
    }
    
    public var body: some View {
        List {
            searchTextFieldSection
            ForEach(sections) { sectionState in
                pickerValuesSection(with: sectionState)
            }
        }
        .onChange(of: searchTerm, debounceTime: .milliseconds(300)) { newValue in
            onAction(.searchTermChanged(newValue))
        }
        .onAppear {
            showKeyboard = true
        }
    }
    
    private var searchTextFieldSection: some View {
        Section {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField(placeholder, text: $searchTerm)
                    .clearButton(text: $searchTerm)
                    .focused($showKeyboard)
                    .autocorrectionDisabled()
            }
        }
    }
    

    @ViewBuilder
    private func pickerValuesSection(with sectionState: JourneyLocationPicker.SectionState) -> some View {
        if !sectionState.values.isEmpty {
            Section {
                ForEach(sectionState.values, id: \.self) { value in
                    selectionButton(value: value)
                }
            } header: {
                if let headerTitle = sectionState.headerTitle {
                    Text(headerTitle, bundle: .module)
                }
            }
        }
    }
    
    private func selectionButton(value: JourneyLocationPicker.Value) -> some View {
        Button {
            onAction(.valueSelected(value))
        } label: {
            JourneyLocationValueTitleLabel(
                value: value,
                style: .pickerList(locationUIStatus)
            )
        }
    }
}

private extension JourneyLocationPicker.SectionState {
    var headerTitle: LocalizedStringKey? {
        switch self {
        case .userLocation:
            return nil
        case .recent:
            return "journey.location.picker.recents.section.title"
        case .nearbyStations:
            return "journey.location.picker.nearby.stations.section.title"
        case let .searchResults(values):
            return ("journey.location.search.results.count \(values.count)")
        }
    }
}


// MARK: - Previews

private struct Previewer: View {
    @State var searchTerm: String = ""
    var sections: [JourneyLocationPicker.SectionState]
    var locationUIStatus: LocationUIStatus = .init(style: .locationAllowed) {
        print("Location allowed")
    }
    
    var body: some View {
        JourneyLocationPickerView(
            searchTerm: $searchTerm,
            placeholder: "Enter search text",
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
            .userLocation(name: "Example location"),
            .recent([
                .station(ModelStubs.eastFinchleyStation),
                .nationalRail(ModelStubs.twickenhamRailStation),
                .searchResult(
                    .init(title: "Recent location title", 
                          subtitle: "Recent location subtitle")
                )
            ]),
            .nearbyStations([
                    .station(ModelStubs.kingsCrossStation),
                    .station(ModelStubs.angelStation)
                ])
        ]
    )
}

#Preview("Suggestions - location denied") {
    Previewer(
        sections: [
            .userLocation(name: nil),
        ],
        locationUIStatus: .init(style: .openSettingsToAllowLocation, onAllowLocation: {
            print("Allow")
        })
    )
}

#Preview("Search results") {
    Previewer(
        searchTerm: "station",
        sections: [
            .searchResults([
                .station(ModelStubs.kingsCrossStation),
                .nationalRail(ModelStubs.twickenhamRailStation),
                .searchResult(
                    .init(title: "Search result title",
                          subtitle: "Search result subtitle")
                )
            ])
        ]
    )
}
