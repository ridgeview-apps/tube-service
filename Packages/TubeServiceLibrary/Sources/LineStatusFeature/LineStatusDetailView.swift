import ComposableArchitecture
import ModelUI
import ModelFakes
import SharedViews
import StyleGuide
import SwiftUI

public typealias LineStatusDetailStore = Store<LineStatusDetail.State, LineStatusDetail.Action>

public struct LineStatusDetailView: View {
    
    private let store: LineStatusDetailStore
    @ObservedObject private var viewStore: ViewStore<LineStatusDetail.State, LineStatusDetail.Action>
    
    public init(store: LineStatusDetailStore) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                statusHeader
                twitterSection
                    .padding([.top])
            }
            .padding([.top, .leading, .trailing])
        }
        .background(Color.defaultBackground)
        .navigationTitle(viewStore.lineStatus.id.longName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
    
    private var statusHeader: some View {
        HStack(spacing: 12) {
            Rectangle()
                .foregroundColor(viewStore.lineStatus.id.backgroundColor)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 12) {
                Text(viewStore.lineStatus.shortText)
                    .font(.title2)
                statusDetailText
            }
            .padding([.top, .bottom, .trailing])
            .foregroundColor(viewStore.lineStatus.isDisrupted ? .adaptiveRed : .primary)
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .leading)
        .cardStyle(cornerRadius: 8)
    }
    
    
    @ViewBuilder private var statusDetailText: some View {
        if !viewStore.lineStatus.isDisrupted {
            Text(viewStore.lineStatus.goodServiceMessage, bundle: .module)
        } else {
            ForEach(Array(viewStore.lineStatus.disruptionReasonsText), id: \.self) { reason in
                Text(reason)
                    .font(.body)
            }
        }
    }
    
    private var twitterSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("status.twitterSection.title", bundle: .module)
            
            ForEach(viewStore.twitterLinks) { link in
                twitterLinkButton(for: link)
            }
        }
    }
    
    @ViewBuilder private func twitterLinkButton(for link: LineStatusDetail.TwitterLink) -> some View {
        Button(action: {
            viewStore.send(.setActiveTwitterLink(to: link))
        }) {
            switch link.style {
            case .tflAllTweets:
                Text("status.tfl.tweets.title.allLines", bundle: .module)
            case let .lineTweets(line):
                Text("status.tfl.tweets.title.line \(line.longName)", bundle: .module)
            }
        }
        .sheet(item: twitterLinkBinding(for: link)) { link in
            SafariView(url: link.url)
        }

    }
    
    private func twitterLinkBinding(for link: LineStatusDetail.TwitterLink) -> Binding<LineStatusDetail.TwitterLink?> {
        viewStore.binding(
            get:  \.activeTwitterLink,
            send: LineStatusDetail.Action.setActiveTwitterLink
        )
    }
}

// MARK: - Previews
#if DEBUG
struct LineStatusDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineStatusDetailView(store: preview())
                .embeddedInNavigationView()
                .previewDisplayName("Good service")
            LineStatusDetailView(store: preview(initialState: .fake(ofType: .severeDelays)))
                .embeddedInNavigationView()
                .previewDisplayName("Severe delays")
            LineStatusDetailView(store: preview(initialState: .fake(ofType: .plannedClosure, for: .circle)))
                .embeddedInNavigationView()
                .previewDisplayName("Planned Closure")
            LineStatusDetailView(store: preview())
                .embeddedInNavigationView()
                .previewOption(contentSize: .extraExtraExtraLarge)
                .previewOption(colorScheme: .dark)
        }
    }
    
    static func preview(initialState: LineStatusDetail.State = .fake(ofType: .goodService)) -> LineStatusDetailStore {
        .init(
            initialState: initialState,
            reducer: LineStatusDetail.reducer,
            environment: ()
        )
    }
}
#endif
