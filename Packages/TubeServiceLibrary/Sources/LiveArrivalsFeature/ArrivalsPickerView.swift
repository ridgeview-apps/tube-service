import ComposableArchitecture
import Model
import ModelUI
import ModelFakes
import SharedViews
import StyleGuide
import SwiftUI

public typealias ArrivalsPickerStore = Store<ArrivalsPicker.State, ArrivalsPicker.Action>

public struct ArrivalsPickerView: View {
    
    private let store: ArrivalsPickerStore
    @ObservedObject private var viewStore: ViewStore<ArrivalsPicker.State, ArrivalsPicker.Action>
    
    public init(store: ArrivalsPickerStore) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    public var body: some View {
        List {
            Section(header: sectionHeader) {
                if let emptySearchResultsStringKey = viewStore.emptySearchResultsStringKey {
                    Text(LocalizedStringKey(emptySearchResultsStringKey), bundle: .module)
                        .italic()
                }
                ForEach(viewStore.selectableStations) { station in
                    if station.hasSingleArrivalsGroup {
                        ArrivalsBoardNavigationLink(store: store,
                                                    rowId: station.arrivalsBoardsListId(at: 0),
                                                    selection: selectedRowId)
                    } else {
                        expandableRow(for: station)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)                
        .searchable(
            text: searchText,
            placement: SearchFieldPlacement.navigationBarDrawer(displayMode: .always),
            prompt: Text("arrivals.picker.search.placeholder", bundle: .module)
        )
        .navigationBarTitle(Text("arrivals.picker.navigation.title", bundle: .module))
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
    
    @ViewBuilder private var sectionHeader: some View {
        if viewStore.sectionHeaderShowsFilterOptions {
            filterOptionsHeader
        } else if viewStore.sectionHeaderShowsSearchResultsCount {
            Text("arrivals.picker.search.results.count \(viewStore.searchResultsCount)",
                 bundle: .module)
        }
    }

    private var filterOptionsHeader: some View {
        Picker("", selection: selectedFilterOption) {
            ForEach(viewStore.filterOptions) { filterOption in
                Text(filterOption.localizedKey, bundle: .module)
                    .tag(filterOption)
            }
        }
        .pickerStyle(.segmented)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
    }
    
    private var selectedFilterOption: Binding<UserPreferences.ArrivalsPickerFilterOption> {
        viewStore.binding(
            get: \.userPreferences.lastUsedFilterOption,
            send: ArrivalsPicker.Action.selectFilterOption
        )
    }
    
    private var selectedRowId: Binding<ArrivalsBoardsList.Id?> {
        viewStore.binding(
            get: \.rowSelection.id,
            send: ArrivalsPicker.Action.selectRow
        )
    }
    
    private var searchText: Binding<String> {
        viewStore.binding(
            get: \.searchText,
            send: ArrivalsPicker.Action.search(text:)
        )
    }
    
    private func shouldExpandRow(for station: Station) -> Binding<Bool> {
        viewStore.binding(
            get: { $0.expandedRows.contains(station) },
            send: { ArrivalsPicker.Action.setExpandedRowState(to: $0, for: station) }
        )
    }
    
    private func expandableRow(for station: Station) -> some View {
        DisclosureGroup(
            isExpanded: shouldExpandRow(for: station),
            content: {
                ForEach(station.sortedArrivalsGroups) { arrivalsGroup in
                    ArrivalsBoardNavigationLink(store: store,
                                                rowId: .init(station: station, arrivalsGroup: arrivalsGroup),
                                                selection: selectedRowId)
                        .padding(.zero)
                }
            },
            label: {
                // Use RowButton so we can tap the whole row to expand/collapse (not just the indicator)
                RowButton {
                    viewStore.send(.toggleExpandedRowState(for: station), animation: .default)
                } label: {
                    LineColourKeyTextView(
                        rowType: .collapsedRow(station: station)
                    )
                    .foregroundColor(Color.primary)
                }
                .accessibilityIdentifier(station.id)
            }
        )
    }
}

private struct ArrivalsBoardNavigationLink: View {
    
    let store: ArrivalsPickerStore
    let rowId: ArrivalsBoardsList.State.ID
    @Binding var selection: ArrivalsBoardsList.State.ID?
        
    private var station: Station { rowId.station }
    private var arrivalsGroup: Station.ArrivalsGroup { rowId.arrivalsGroup }
    
    var body: some View {
        NavigationLink(
            destination:
                IfLetStore(
                    store.scope(
                        state: { $0.rowSelection.navigationStates[id: rowId] },
                        action: { ArrivalsPicker.Action.arrivalsBoardsList(id: rowId, action: $0) }
                    ),
                    then: ArrivalsBoardsListView.init(store:)
                )
            ,
            tag: rowId,
            selection: $selection
        ) {
            LineColourKeyTextView(
                rowType: .expandedRow(station: station,
                                      arrivalsGroup: arrivalsGroup)
            )
        }
        .accessibilityIdentifier("\(station.id)-\(arrivalsGroup.id)")
    }
}

private struct LineColourKeyTextView: View {
    enum RowType {
        case collapsedRow(station: Station)
        case expandedRow(station: Station, arrivalsGroup: Station.ArrivalsGroup)
    }
    
    let rowType: RowType
    
    var body: some View {
        HStack(spacing: 8) {
            LineColourKeyView(lines: lines)
            Text(text)
        }
    }
    
    var lines: [TrainLine] {
        switch rowType {
        case .collapsedRow(let station):
            return station.sortedLines
        case .expandedRow(let station, let arrivalsGroup):
            return station.hasSingleArrivalsGroup ? station.sortedLines : arrivalsGroup.sortedLineIds
        }
    }
    
    var text: String {
        switch rowType {
        case .collapsedRow(let station):
            return station.name
        case .expandedRow(let station, let arrivalsGroup):
            return station.hasSingleArrivalsGroup ? station.name : arrivalsGroup.title
        }
    }

}

extension Station {
    var sortedArrivalsGroups: IdentifiedArrayOf<ArrivalsGroup> {
        IdentifiedArrayOf(uniqueElements: arrivalsGroups.sortedByTitle())
    }
    
    func arrivalsBoardsListId(at index: Int) -> ArrivalsBoardsList.Id {
        .init(station: self, arrivalsGroup: arrivalsGroups[index])
    }

    var hasSingleArrivalsGroup: Bool {
        arrivalsGroups.count == 1
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
    
    var imageName: String? {
        switch self {
        case .all:
            return nil
        case .favourites:
            return "star.fill"
        }
    }
}
//
//// MARK: - Previews
#if DEBUG
struct ArrivalsPickerContainerView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ArrivalsPickerView(store: fakeStore())
                .embeddedInNavigationView()
            ArrivalsPickerView(store: fakeStore())
                .embeddedInNavigationView()
                .previewOption(colorScheme: .dark)
        }
    }

    static func fakeStore(
        initialState: ArrivalsPicker.State = .fake()
    ) -> ArrivalsPickerStore {
        .init(initialState: initialState,
              reducer: ArrivalsPicker.reducer,
              environment: .fake())
    }
}
#endif
