import ComposableArchitecture
import SwiftUI

struct LineStatusListView: View {
    
    let store: LineStatusListStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Section(header: sectionHeader) {
                    if let errorMessage = viewStore.errorMessage {
                        ErrorView(errorMessage: errorMessage)
                    }
                    ForEach(viewStore.statuses) { lineStatus in
                        NavigationLink(
                            destination: selectedRowDestination,
                            tag: lineStatus.id,
                            selection: selectedRowId
                        ) {
                            LineStatusRowView(lineStatus: lineStatus)
                        }
                        .accessibility(identifier: lineStatus.id.rawValue)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(viewStore.navigationBarTitle)
            .navigationBarItems(trailing: navigationBarItems)
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onSceneDidBecomeActive {
                viewStore.send(.autoRefreshIfNeeded)
            }
        }
    }
    
    private var sectionHeader: some View {
        HStack(spacing: 8) {
            Text(ViewStore(store).lastRefreshedAtText)
            if ViewStore(store).isRefreshing {
                ProgressView()
            }
        }
    }
    
    private var navigationBarItems: some View {
        HStack {
            NavigationButton.Refresh {
                ViewStore(store).send(.refresh)
            }
            .disabled(ViewStore(store).isRefreshing)
            .padding([.leading, .top, .bottom])            
        }
    }
    
    private var selectedRowId: Binding<LineStatus.ID?> {
        ViewStore(store).binding(
            get: \.rowSelection.id,
            send: LineStatusList.Action.selectRow
        )
    }
    
    private var selectedRowDestination: LineStatusDetailView {
        LineStatusDetailView(store: store.lineStatusDetailStore)
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
                        .animation(nil)
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
                            .animation(nil)
                    }
                }
            }
        }
        .animation(.default)
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
