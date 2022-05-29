import ComposableArchitecture
import Model
import ModelUI
import ModelFakes
import SharedViews
import StyleGuide
import SwiftUI

public typealias ArrivalsBoardsListStore = Store<ArrivalsBoardsList.State, ArrivalsBoardsList.Action>
public typealias ArrivalsBoardsListViewStore = ViewStore<ArrivalsBoardsList.State, ArrivalsBoardsList.Action>

public struct ArrivalsBoardsListView: View {
    
    private let store: ArrivalsBoardsListStore
    @ObservedObject private var viewStore: ArrivalsBoardsListViewStore
    
    public init(store: ArrivalsBoardsListStore) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    public var body: some View {
        List {
            if let errorMessage = viewStore.errorMessage {
                ErrorView(errorMessage: errorMessage)
            }
            Section(header: sectionHeader) {
                if viewStore.boardDataUnavailable {
                    boardDataUnavailableView
                } else {
                    ForEachStore(
                        store.scope(
                            state: \.boards,
                            action: ArrivalsBoardsList.Action.arrivalsBoard(id:action:)
                        )
                    ) { boardStore in
                        HStack {
                            Spacer()
                            ArrivalsBoardView(store: boardStore)
                                .buttonStyle(.plain)
                                .frame(maxWidth: 600)
                                .padding()
                            Spacer()
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.defaultBackground)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(viewStore.station.name)
        .navigationBarItems(trailing: navigationBarItems)
        .refreshable {
            await viewStore.send(.refresh, while: \.isRefreshing)
        }
        .background(Color.defaultBackground)
        .onAppear {
            viewStore.send(.onAppear)
        }
        .onDisappear {
            viewStore.send(.onDisappear)
        }
    }
    
    private var boardDataUnavailableView: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
                .imageScale(.large)
            Text("arrivals.no.data", bundle: .module)
        }
    }
    
    private var sectionHeader: some View {
        HStack(spacing: 8) {
            Text(viewStore.sectionTitle)
            if viewStore.isRefreshing {
                ProgressView()
            }
        }
    }
    
    @ViewBuilder private var navigationBarItems: some View {
        let isFavourite = viewStore.binding(
            get: \.isFavourite,
            send: ArrivalsBoardsList.Action.tapFavourite
        )
        HStack {
            FavouritesButton(isFavourite: isFavourite)
                .padding([.leading, .top, .bottom])
        }
    }
}

// MARK: - Previews
#if DEBUG
struct ArrivalsBoardsListView_Previews: PreviewProvider {
    static var previews: some View {

        let populatedArrivalsView = ArrivalsBoardsListView(
            store: fakeStore()
        )
        
        let emptyArrivalsView =  ArrivalsBoardsListView(
            store: fakeStore(
                initialState: .fake(station: .fake(ofType: .kingsCross),
                                    arrivalsGroupIndex: 0,
                                    boards: [])
            )
        )
        
        let errorView =  ArrivalsBoardsListView(
            store: fakeStore(
                initialState: .fake(station: .fake(ofType: .kingsCross),
                                    arrivalsGroupIndex: 0,
                                    boards: [],
                                    errorMessage: "An unexpected error occurred.")
            )
        )

        Group {
            populatedArrivalsView
                .embeddedInNavigationView()
            emptyArrivalsView
                .embeddedInNavigationView()
            errorView
                .embeddedInNavigationView()
        }
    }
    
    static func fakeStore(
        initialState: ArrivalsBoardsList.State = .fake()
    ) -> ArrivalsBoardsListStore {
        .init(initialState: initialState,
              reducer: ArrivalsBoardsList.reducer,
              environment: .fake())
    }
}
#endif
