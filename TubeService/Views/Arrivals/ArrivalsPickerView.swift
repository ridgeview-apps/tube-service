import ComposableArchitecture
import DataClients
import Model
import SwiftUI

struct ArrivalsPickerView: View {
    
    let store: ArrivalsPickerStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Section(header: sectionHeader(viewStore: viewStore)) {
                    if let emptySearchResultsStringKey = viewStore.emptySearchResultsStringKey {
                        Text(LocalizedStringKey(emptySearchResultsStringKey))
                            .italic()
                    }
                    ForEach(viewStore.selectableStations) { station in
                        if station.hasSingleArrivalsGroup {
                            ArrivalsBoardNavigationLink(store: store,
                                                        rowId: station.arrivalsBoardsListId(at: 0),
                                                        selection: selectedRowId(viewStore: viewStore))
                        } else {
                            DisclosureGroup(
                                isExpanded: isRowExpanded(for: station, viewStore: viewStore),
                                content: {
                                    ForEach(station.sortedArrivalsGroups) { arrivalsGroup in
                                        ArrivalsBoardNavigationLink(store: store,
                                                                    rowId: .init(station: station, arrivalsGroup: arrivalsGroup),
                                                                    selection: selectedRowId(viewStore: viewStore))
                                    }
                                },
                                label: {
                                    // Use RowButton so we can tap the whole row to expand/collapse (not just the indicator)
                                    RowButton {
                                        viewStore.send(.toggleExpandedRowState(for: station))
                                    } label: {
                                        LineColourKeyTextView(lines: station.sortedLines, text: station.name)
                                            .foregroundColor(Color.primary)
                                    }
                                    .accessibilityIdentifier(station.id)
                                }
                            )
                        }
                    }
                }
            }
            .listStyle(.plain)
            .searchable(
                text: searchText(viewStore: viewStore),
                placement: SearchFieldPlacement.navigationBarDrawer(displayMode: .always),
                prompt: Text(viewStore.placeholderSearchText)
            )
            .navigationBarTitle(viewStore.navigationBarTitle)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    @ViewBuilder private func sectionHeader(viewStore: ViewStore<ArrivalsPicker.State, ArrivalsPicker.Action>) -> some View {
        if viewStore.sectionHeaderShowsFilterOptions {
            filterOptionsHeader(viewStore: viewStore)
        } else if viewStore.sectionHeaderShowsSearchResultsCount {
            Text(viewStore.searchResultsCountText)
        }
    }

    private func filterOptionsHeader(viewStore: ViewStore<ArrivalsPicker.State, ArrivalsPicker.Action>) -> some View {
        Picker("", selection: selectedFilterOption(viewStore: viewStore)) {
            ForEach(viewStore.filterOptions) { filterOption in
                Text(LocalizedStringKey(filterOption.localizedKey))
                    .tag(filterOption)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.top, 8)
        .padding([.leading, .trailing, .bottom])
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .background(Color(.systemBackground))
    }
    
    private func selectedFilterOption(viewStore: ViewStore<ArrivalsPicker.State, ArrivalsPicker.Action>) -> Binding<UserPreferences.ArrivalsPickerFilterOption> {
        viewStore.binding(
            get: \.selectedFilterOption,
            send: ArrivalsPicker.Action.selectFilterOption
        )
    }
    
    private func selectedRowId(viewStore: ViewStore<ArrivalsPicker.State, ArrivalsPicker.Action>) -> Binding<ArrivalsBoardsList.Id?> {
        viewStore.binding(
            get: \.rowSelection.id,
            send: ArrivalsPicker.Action.selectRow
        )
    }
    
    private func searchText(viewStore: ViewStore<ArrivalsPicker.State, ArrivalsPicker.Action>) -> Binding<String> {
        viewStore.binding(
            get: \.searchText,
            send: ArrivalsPicker.Action.search(text:)
        )
    }
    
    private func isRowExpanded(for station: Station, viewStore: ViewStore<ArrivalsPicker.State, ArrivalsPicker.Action>) -> Binding<Bool> {
        viewStore.binding(
            get: { $0.expandedRows.contains(station) },
            send: { ArrivalsPicker.Action.setExpandedRowState(to: $0, for: station) }
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
            LineColourKeyTextView(lines: station.hasSingleArrivalsGroup ? station.sortedLines : arrivalsGroup.sortedLineIds,
                                  text: station.hasSingleArrivalsGroup ? station.name : arrivalsGroup.title)
        }
        .accessibilityIdentifier("\(station.id)-\(arrivalsGroup.id)")
    }
}

private struct LineColourKeyTextView: View {
    var lines: [TrainLine]
    var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            LineColourKeyView(lines: lines)
            Text(text)
        }
    }
}

private extension Station {
    var hasSingleArrivalsGroup: Bool {
        arrivalsGroups.count == 1
    }
}

private extension UserPreferences.ArrivalsPickerFilterOption {
    var localizedKey: String {
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
struct ArrivalsPickerContainerView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ArrivalsPickerView(store: .preview())
                .embeddedInNavigationView()
            ArrivalsPickerView(store: .preview())
                .embeddedInNavigationView()
                .previewOption(colorScheme: .dark)
        }
    }
}
#endif
