import ComposableArchitecture
import SwiftUI
import Combine

struct ArrivalsBoardsListView: View {
    
    let store: ArrivalsBoardsListStore
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                if let errorMessage = viewStore.errorMessage {
                    ErrorView(errorMessage: errorMessage)
                }
                Section(header: sectionHeader(viewStore: viewStore)) {
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
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(maxWidth: 600)
                                    .padding()
                                Spacer()
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .background(Color(UIColor.systemBackground))
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text(viewStore.station.name), displayMode: .inline)
            .navigationBarItems(trailing: navigationBarItems(viewStore: viewStore))
            .refreshable {
                await viewStore.send(.refresh, while: \.isRefreshing)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
    
    private var boardDataUnavailableView: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
                .imageScale(.large)
            Text("arrivals.no.data")
        }
    }
    
    private func sectionHeader(viewStore: ViewStore<ArrivalsBoardsList.State, ArrivalsBoardsList.Action>) -> some View {
        HStack(spacing: 8) {
            Text(viewStore.sectionTitle)
            if viewStore.isRefreshing {
                ProgressView()
            }
        }
    }
    
    private func navigationBarItems(viewStore: ViewStore<ArrivalsBoardsList.State, ArrivalsBoardsList.Action>) -> some View {
        HStack {
            FavouritesButton(isFavourite: self.isFavourite(viewStore: viewStore))
                .padding([.leading, .top, .bottom])
        }
    }
    
    private func isFavourite(viewStore: ViewStore<ArrivalsBoardsList.State, ArrivalsBoardsList.Action>) -> Binding<Bool> {
        viewStore.binding(
            get: \.isFavourite,
            send: ArrivalsBoardsList.Action.tapFavourite
        )
    }

}

// MARK: - Previews
#if DEBUG
struct ArrivalsBoardsListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let populatedArrivalsView = ArrivalsBoardsListView(
            store: .preview(viewState: .fake())
        )
        
        let emptyArrivalsView =  ArrivalsBoardsListView(
            store: .preview(
                viewState: .fake(station: .fake(ofType: .kingsCross),
                                  arrivalsGroupIndex: 0,
                                  boards: [])
            )
        )
        
        let errorView =  ArrivalsBoardsListView(
            store: .preview(
                viewState: .fake(station: .fake(ofType: .kingsCross),
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
}
#endif
