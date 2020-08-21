import ComposableArchitecture
import SwiftUI

struct LineStatusDetailView: View {
    
    let store: LineStatusDetailStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    statusHeader
                        .padding()
                    Divider()
                        .padding([.leading, .trailing])
                    twitterSection
                        .padding([.top, .leading, .trailing])
                }
            }
            .navigationTitle(viewStore.lineStatus.id.longName)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    private var statusHeader: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Spacer()
                    if viewStore.lineStatus.isDisrupted {
                        Image(systemName: "exclamationmark.circle.fill")
                            .imageScale(.large)
                    }
                    Text(viewStore.lineStatus.shortText)
                        .font(.title2)
                    Spacer()
                }
                ForEach(Array(viewStore.lineStatus.disruptionReasonsText), id: \.self) { reason in
                    Text(reason)
                        .font(.subheadline)
                }
            }
            .padding()
            .foregroundColor(viewStore.lineStatus.id.textColor)
            .background(viewStore.lineStatus.id.backgroundColor)
            .roundedBorder(.white)
            
        }
    }
    
    private var twitterSection: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading, spacing: 20) {
                Text("status.twitterSection.title")
                
                if let filteredTweetsLink = viewStore.filteredTweetsLink {
                    twitterLink(for: filteredTweetsLink)
                }
                
                if let allTweetsLink = viewStore.allTweetsLink {
                    twitterLink(for: allTweetsLink)
                }
                
            }
//            .padding()
        }
    }
    
    private func twitterLink(for link: LineStatusDetail.ViewState.TwitterLink) -> some View {
        WithViewStore(store) { viewStore in
            switch viewStore.userPreferences.preferredBrowserType {
            case .inApp:
                Button(action: {
                    viewStore.send(.set(twitterLink: link, isActive: true))
                }) {
                    Text(link.title)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(Color.blue)
                .sheet(isPresented: shouldShowSafariView(for: link)) {
                    SafariView(url: link.url)
                }
                .padding(.bottom, 4)
            case .external:
                Link(link.title, destination: link.url)
                    .font(.subheadline)
                    .foregroundColor(Color.blue)
            }
        }
    }
    
    private func shouldShowSafariView(for link: LineStatusDetail.ViewState.TwitterLink) -> Binding<Bool> {
        ViewStore(store).binding(
            get: { $0.activeTwitterLink == link },
            send: { LineStatusDetail.Action.set(twitterLink: link, isActive: $0) }
        )
    }
}

// MARK: - Previews
#if DEBUG
struct LineStatusDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineStatusDetailView(store: .preview())
                .embeddedInNavigationView()
                .previewDisplayName("Good service")
            LineStatusDetailView(store: .preview(initialState: .fake(ofType: .severeDelays)))
                .embeddedInNavigationView()
                .previewDisplayName("Severe delays")
            LineStatusDetailView(store: .preview(initialState: .fake(ofType: .plannedClosure, for: .circle)))
                .embeddedInNavigationView()
                .previewDisplayName("Planned Closure")
            LineStatusDetailView(store: .preview())
                .embeddedInNavigationView()
                .previewOption(contentSize: .extraExtraExtraLarge)
                .previewOption(colorScheme: .dark)
        }
    }
}
#endif
