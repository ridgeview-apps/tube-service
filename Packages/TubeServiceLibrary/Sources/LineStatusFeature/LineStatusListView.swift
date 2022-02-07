import ComposableArchitecture
import Model
import ModelUI
import ModelFakes
import SharedViews
import StyleGuide
import SwiftUI

public typealias LineStatusListStore = Store<LineStatusList.State, LineStatusList.Action>
typealias LineStatusListViewStore = ViewStore<LineStatusList.State, LineStatusList.Action>

public struct LineStatusListView: View {
    
    private let store: LineStatusListStore
    @ObservedObject private var viewStore: LineStatusListViewStore
    
    public init(store: LineStatusListStore) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    public var body: some View {
        List {
            Section(header: sectionHeader) {
                if let errorMessage = viewStore.errorMessage {
                    ErrorView(errorMessage: errorMessage)
                }
                ForEach(viewStore.statuses) { lineStatus in
                    LineStatusRowButton(lineStatus: lineStatus,
                                        selection: rowSelectionBinding) {
                        IfLetStore(
                            store.scope(
                                state: { $0.rowSelection.navigationStates[id: lineStatus.id] },
                                action: { LineStatusList.Action.lineStatusDetail(id: lineStatus.id, action: $0) }
                            ),
                            then: LineStatusDetailView.init(store:)
                        )
                    }
                    .accessibility(identifier: lineStatus.id.rawValue)
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .navigationBarTitle(Text(LocalizedStringKey(viewStore.navigationBarTitleKey), bundle: .module))
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
    
    private var sectionHeader: some View {
        HStack(spacing: 8) {
            Text(viewStore.lastRefreshedAtText)
            if viewStore.isRefreshing {
                ProgressView()
            }
        }
    }
    
    private var rowSelectionBinding: Binding<LineStatus.ID?> {
        viewStore.binding(
            get: \.rowSelection.id,
            send: LineStatusList.Action.selectRow
        )
    }
}

// Rows
struct LineStatusRowButton<DestinationView: View>: View {
    let lineStatus: LineStatus
    @Binding var selection: LineStatus.ID?
    let destinationView: () -> DestinationView
    
    var body: some View {
        ZStack {
            Button {
                selection = lineStatus.id
            } label: {
                HStack(spacing: 0) {
                    
                    columnText(lineStatus.id.shortName)
                        .foregroundColor(lineStatus.id.textColor)
                        .background(lineStatus.id.backgroundColor)
                    
                    columnText(lineStatus.shortText)
                        .foregroundColor(lineStatus.isDisrupted ? .red : .primary)
                    
                    accessoryImage
                }
                
            }
            .buttonStyle(.plain)
            
            NavigationLink(tag: lineStatus.id,
                           selection: $selection,
                           destination: destinationView) { }.hidden()
        }
        .frame(minHeight: 44)
    }
    
    private func columnText(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .leading)
            .padding(.init(top: 8,
                           leading: 12,
                           bottom: 8,
                           trailing: 12))
    }
    
    @ViewBuilder private var accessoryImage: some View {
        if lineStatus.isDisrupted {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.red)
                .padding(.trailing)
                .frame(width: 30)
        } else {
            Image(systemName: "chevron.right")
                .foregroundColor(.adaptiveMidGrey2)
                .padding(.trailing)
                .frame(width: 30)
        }
    }
}

// MARK: - Previews
#if DEBUG
struct LineStatusListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineStatusListView(store: preview())
                .embeddedInNavigationView()
//                .previewOption(contentSize: .extraExtraLarge)
            LineStatusListView(store: preview())
                .embeddedInNavigationView()
                .previewOption(colorScheme: .dark)
            LineStatusListView(
                store: preview(
                    initialState: .fake(statuses: []),
                    environment: .fake().withFailedRefresh()
                )
            )
            .embeddedInNavigationView()
        }
    }
    
    static func preview(initialState: LineStatusList.State = .fake(),
                        environment: LineStatusList.Environment = .fake()) -> LineStatusListStore {
        .init(
            initialState: initialState,
            reducer: LineStatusList.reducer,
            environment: environment
        )
    }
}
#endif
