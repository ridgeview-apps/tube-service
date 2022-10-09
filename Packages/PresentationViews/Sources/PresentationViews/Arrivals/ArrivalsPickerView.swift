import Shared
import SwiftUI
import Models

public struct ArrivalsPickerView: View {
    
    public let stations: [Station]
    public let showsFilterOptions: Bool

    @Binding public var selectedLineGroup: Station.LineGroup?
    @Binding public var selectedFilterOption: UserPreferences.ArrivalsPickerFilterOption
    
    public init(stations: [Station],
                selectedLineGroup: Binding<Station.LineGroup?>,
                selectedFilterOption: Binding<UserPreferences.ArrivalsPickerFilterOption>,
                showsFilterOptions: Bool = true) {
        self.stations = stations
        self.showsFilterOptions = showsFilterOptions
        self._selectedLineGroup = selectedLineGroup
        self._selectedFilterOption = selectedFilterOption
    }
    
    // MARK: Layout
    
    public var body: some View {
        List(selection: $selectedLineGroup) {
            Section {
                ForEach(stations) { station in
                    cell(for: station)
                }
            } header: {
                filterOptions
            }
            .listRowSeparator(.visible, edges: .bottom)
            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.defaultBackground)
        }
        .listStyle(.plain)
        .defaultScrollContentBackgroundColor()
    }
    
    @ViewBuilder private func cell(for station: Station) -> some View {
        Group {
            if station.lineGroups.count == 1 {
                navigationLink(for: station.lineGroups[0], title: station.name)
            } else {
                DisclosureGroup {
                    ForEach(station.lineGroups.sortedByName()) { lineGroup in
                        navigationLink(for: lineGroup, title: lineGroup.name)
                    }
                } label: {
                    rowLabel(withLineIDs: station.sortedLineIDs, title: station.name)
                }
                .tint(.clear)
            }
        }
        .frame(minHeight: 44)
    }
    
    @ViewBuilder private var filterOptions: some View {
        if showsFilterOptions {
            Picker("", selection: $selectedFilterOption) {
                ForEach(UserPreferences.ArrivalsPickerFilterOption.allCases) { filterOption in
                    Text(filterOption.localizedKey, bundle: .module)
                        .tag(filterOption)
                }
            }
            .pickerStyle(.segmented)
            .background(Color.defaultBackground)
        }
    }
    
    private func navigationLink(for lineGroup: Station.LineGroup, title: String) -> some View {
        NavigationLink(value: lineGroup) {
            rowLabel(withLineIDs: lineGroup.lineIds.sortedByName(), title: title)
        }
    }
    
    private func rowLabel(withLineIDs lineIDs: [LineID], title: String) -> some View {
        HStack(spacing: 8) {
            LineColourKeyView(lineIDs: lineIDs)
            Text(title)
            Spacer()
        }
        .contentShape(Rectangle())
        .foregroundColor(Color.primary)
    }
}

private extension UserPreferences.ArrivalsPickerFilterOption {
    var localizedKey: LocalizedStringKey {
        switch self {
        case .all:
            return "arrivals.picker.filterOptions.title.all"
        case .favourites:
            return "arrivals.picker.filterOptions.title.favourites"
        }
    }
}


// MARK: - Previews

#if DEBUG
private struct WrapperView: View  {
    var stations: [Station] = ModelStubs.stations
    @State var selectedLineGroup: Station.LineGroup?
    @State var selectedFilterOption: UserPreferences.ArrivalsPickerFilterOption = .all
    var showsFilterOptions = true
    
    var body: some View {
        NavigationSplitView {
            ArrivalsPickerView(stations: stations,
                               selectedLineGroup: $selectedLineGroup,
                               selectedFilterOption: $selectedFilterOption,
                               showsFilterOptions: showsFilterOptions)
            .navigationTitle("Picker preview")
        } detail: {
            if let selectedLineGroup {
                Text("\(selectedLineGroup.name) selected")
            } else {
                Text("No value selected")
            }
        }
    }
}


#Preview("Filter options") {
    WrapperView()
}

#Preview("No filter options") {
    WrapperView(showsFilterOptions: false)
}

#Preview("With search bar") {
    WrapperView()
        .searchable(text: .constant(""), placement: .navigationBarDrawer(displayMode: .always))
        .previewDisplayName("With search bar")
}
#endif
