import ComposableArchitecture
import SwiftUI

struct ArrivalsPickerView: View {
    
    let store: ArrivalsPickerStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Section(header: sectionHeader) {
                    if let emptySearchResultsStringKey = viewStore.emptySearchResultsStringKey {
                        Text(LocalizedStringKey(emptySearchResultsStringKey))
                            .italic()
                    }
                    ForEach(viewStore.selectableStations) { station in
                        if station.hasSingleArrivalsGroup {
                            ArrivalsBoardNavigationLink(store: store,
                                                        selection: selectedRowId,
                                                        destinationId: station.arrivalsBoardsListId(at: 0))
                        } else {
                            DisclosureGroup(
                                isExpanded: isRowExpanded(for: station),
                                content: {
                                    ForEach(station.sortedArrivalsGroups) { arrivalsGroup in
                                        ArrivalsBoardNavigationLink(store: store,
                                                                    selection: selectedRowId,
                                                                    destinationId: .init(station: station, arrivalsGroup: arrivalsGroup))
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
            .navigationSearchBar(
                text: searchText,
                options: [
                    .placeholder: viewStore.placeholderSearchText,
                    .   searchTextFieldAccessibilityId: "stations.picker.search.bar"
                ],
                actions: [
                    .onCancelButtonClicked: { viewStore.send(.endSearch) },
                    .onDidBecomeActive: { viewStore.send(.beginSearch) },
                ]
            )
            .listStyle(PlainListStyle())
            .navigationBarTitle(viewStore.navigationBarTitle)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    private var sectionHeader: some View {
        WithViewStore(store) { viewStore in
            if viewStore.sectionHeaderShowsFilterOptions {
                filterOptionsHeader
            } else if viewStore.sectionHeaderShowsSearchResultsCount {
                Text(viewStore.searchResultsCountText)
            }
        }
    }

    private var filterOptionsHeader: some View {
        WithViewStore(store) { viewStore in
            Picker("", selection: selectedFilterOption) {
                ForEach(viewStore.filterOptions) { filterOption in
                    Text(LocalizedStringKey(filterOption.localizedKey))
                        .tag(filterOption)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, 8)
            .padding([.leading, .trailing, .bottom])
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .background(Color(UIColor.systemBackground))
        }
    }
    
    private var selectedFilterOption: Binding<ArrivalsPicker.ViewState.Filter> {
        ViewStore(store).binding(
            get: \.selectedFilterOption,
            send: ArrivalsPicker.Action.selectFilterOption
        )
    }
    
    private var selectedRowId: Binding<ArrivalsBoardsList.Id?> {
        ViewStore(store).binding(
            get: \.rowSelection.id,
            send: ArrivalsPicker.Action.selectRow
        )
    }
    
    private var searchText: Binding<String> {
        ViewStore(store).binding(
            get: \.searchText,
            send: ArrivalsPicker.Action.search(text:)
        )
    }
    
    private func isRowExpanded(for station: Station) -> Binding<Bool> {
        ViewStore(store).binding(
            get: { $0.expandedRows.contains(station) },
            send: { ArrivalsPicker.Action.setExpandedRowState(to: $0, for: station) }
        )
    }
    
    private func selectedRowDestination() -> ArrivalsBoardsListView {
        ArrivalsBoardsListView(store: self.store.arrivalsBoardsListStore)
    }
}

private struct ArrivalsBoardNavigationLink: View {
    
    let store: ArrivalsPickerStore
    @Binding var selection: ArrivalsBoardsList.Id?
    let destinationId: ArrivalsBoardsList.Id
    
    private var station: Station { destinationId.station }
    private var arrivalsGroup: Station.ArrivalsGroup { destinationId.arrivalsGroup }
    
    var body: some View {
        NavigationLink(
            destination: ArrivalsBoardsListView(store: store.arrivalsBoardsListStore),
            tag: ArrivalsBoardsList.Id(station: station, arrivalsGroup: arrivalsGroup),
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

private extension ArrivalsPicker.ViewState.Filter {
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
