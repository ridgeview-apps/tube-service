import ComposableArchitecture
import SwiftUI
import Combine

struct ArrivalsBoardsListView: View {
    
    let store: ArrivalsBoardsListStore
    
    private var isFavourite: Binding<Bool> {
        ViewStore(self.store).binding(
            get: \.isFavourite,
            send: ArrivalsBoardsList.Action.tapFavourite
        )
    }
    
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
                                    .animation(.default)
                                Spacer()
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .background(Color(UIColor.systemBackground))
                    }
                }
            }
            .animation(nil)
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text(viewStore.station.name), displayMode: .inline)
            .navigationBarItems(trailing: navigationBarItems(viewStore: viewStore))
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
            NavigationButton.Refresh {
                viewStore.send(.refresh)
            }
            .disabled(viewStore.isRefreshing)
            .padding([.leading, .top, .bottom])
            
            FavouritesButton(isFavourite: self.isFavourite)
                .padding([.leading, .top, .bottom])
        }
    }
}

// MARK: - Previews
#if DEBUG
struct ArrivalsBoardsListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let populatedArrivalsView = ArrivalsBoardsListView(
            store: .preview(viewState: .fake())
        )
        .embeddedInNavigationView()
        
        let emptyArrivalsView =  ArrivalsBoardsListView(
            store: .preview(
                viewState: .fake(station: .fake(ofType: .kingsCross),
                                  arrivalsGroupIndex: 0,
                                  boards: [])
            )
        )
        .embeddedInNavigationView()
        
        let errorView =  ArrivalsBoardsListView(
            store: .preview(
                viewState: .fake(station: .fake(ofType: .kingsCross),
                                  arrivalsGroupIndex: 0,
                                  boards: [],
                                  errorMessage: "An unexpected error occurred.")
            )
        )
        .embeddedInNavigationView()
        
        Group {
            populatedArrivalsView
            emptyArrivalsView
            errorView
        }
    }
}
#endif
