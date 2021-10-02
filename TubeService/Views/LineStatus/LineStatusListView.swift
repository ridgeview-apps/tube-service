import ComposableArchitecture
import SwiftUI

struct LineStatusListView: View {
    
    let store: LineStatusListStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Section(header: sectionHeader(viewStore: viewStore)) {
                    if let errorMessage = viewStore.errorMessage {
                        ErrorView(errorMessage: errorMessage)
                    }
                    ForEach(viewStore.statuses) { lineStatus in
                        NavigationLink(
                            destination:
                                IfLetStore(
                                    store.scope(
                                        state: { $0.rowSelection.navigationStates[id: lineStatus.id] },
                                        action: { LineStatusList.Action.lineStatusDetail(id: lineStatus.id, action: $0) }
                                    ),
                                    then: LineStatusDetailView.init(store:)
                                )
                            ,
                            tag: lineStatus.id,
                            selection: selectedRowId(viewStore: viewStore)
                        ) {
                            LineStatusRowView(lineStatus: lineStatus)
                        }
                        .accessibility(identifier: lineStatus.id.rawValue)
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitle(viewStore.navigationBarTitle)
            .refreshable {
                await viewStore.send(.refresh, while: \.isRefreshing)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onSceneDidBecomeActive {
                viewStore.send(.autoRefreshIfNeeded)
            }
        }
    }
    
    private func sectionHeader(viewStore: ViewStore<LineStatusList.State, LineStatusList.Action>) -> some View {
        HStack(spacing: 8) {
            Text(viewStore.lastRefreshedAtText)
            if viewStore.isRefreshing {
                ProgressView()
            }
        }
    }
    
    private func selectedRowId(viewStore: ViewStore<LineStatusList.State, LineStatusList.Action>) -> Binding<LineStatus.ID?> {
        viewStore.binding(
            get: \.rowSelection.id,
            send: LineStatusList.Action.selectRow
        )
    }
}

// Rows
struct LineStatusRowView: View {
    let lineStatus: LineStatus
    
    var body: some View {
        VStack(spacing: 8) {
            VStack(alignment: .leading) {
                HStack {
                    Text(lineStatus.id.shortName)
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity,
                               alignment: .leading)
                        .padding(8)
                        .background(lineStatus.id.backgroundColor)
                        .foregroundColor(lineStatus.id.textColor)
                        .roundedBorder(.white)
                    HStack {
                        if lineStatus.isDisrupted {
                            Image(systemName: "exclamationmark.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.red)
                        }
                        Text(LocalizedStringKey(lineStatus.shortText))
                            .foregroundColor(lineStatus.isDisrupted ? .red : .primary)
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity,
                                   alignment: .leading)
                    }
                }
            }
        }
    }
    
    private func tweetsButton(title: LocalizedStringKey,
                              url: URL,
                              showTweets: Binding<Bool>) -> some View {
        Button(action: {
            showTweets.wrappedValue = true
        }) {
            Text(title)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(Color.blue)
        .sheet(isPresented: showTweets) {
            SafariView(url: url)
        }
        .padding(.bottom, 4)
    }
}

// MARK: - Previews
#if DEBUG
struct LineStatusListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineStatusListView(store: .preview())
                .embeddedInNavigationView()
            LineStatusListView(store: .preview())
                .embeddedInNavigationView()
                .previewOption(colorScheme: .dark)
        }
    }
}
#endif
