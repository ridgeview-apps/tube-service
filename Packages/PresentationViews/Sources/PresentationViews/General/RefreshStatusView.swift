import SwiftUI

public enum LoadingState: Hashable {
    case loading
    case loaded
    case failure(errorMessage: String)
}

public struct RefreshStatusView: View {
    
    public let loadingState: LoadingState
    public let showsText: Bool

    public init(loadingState: LoadingState,
                showsText: Bool = true) {
        self.loadingState = loadingState
        self.showsText = showsText
    }
    
    public var body: some View {
        if loadingState != .loaded {
            Label {
                if showsText {
                    statusText
                }
            } icon: {
                statusImage
            }
            .animation(.default, value: loadingState)
        }
    }

    @ViewBuilder private var statusImage: some View {
        switch loadingState {
        case .loading:
            ProgressView()
                .controlSize(.mini)
        case .loaded:
            EmptyView()
        case .failure:
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.adaptiveRed)
                .imageScale(.small)
        }
    }

    @ViewBuilder private var statusText: some View {
        switch loadingState {
        case .loading:
            Text(.refreshStatusLoading)
        case let .failure(errorMessage):
            Text(errorMessage)
                .foregroundStyle(.adaptiveRed)
        case .loaded:
            EmptyView()
        }
    }
}

#Preview {
    VStack {
        RefreshStatusView(loadingState: .loading)
        RefreshStatusView(loadingState: .loading, showsText: false)
        RefreshStatusView(
            loadingState: .failure(errorMessage: "Sorry, something went wrong")
        )
        RefreshStatusView(
            loadingState: .failure(errorMessage: "Sorry, something went wrong"),
            showsText: false
        )
    }
}
