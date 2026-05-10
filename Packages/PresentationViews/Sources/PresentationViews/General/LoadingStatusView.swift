import SwiftUI

public enum LoadingState: Hashable {
    case loading
    case loaded
    case failure(errorMessage: String)
}

public struct LoadingStatusView: View {

    public let loadingState: LoadingState

    public init(
        loadingState: LoadingState
    ) {
        self.loadingState = loadingState
    }

    public var body: some View {
        HStack(spacing: 4) {
            switch loadingState {
            case .loading:
                ProgressView()
                    .controlSize(.small)
                Text(.refreshStatusLoading)
            case .failure(let reason):
                Group {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(reason)
                }
                .foregroundStyle(.adaptiveRed)
            case .loaded:
                EmptyView()
            }
        }
    }
}

extension View {
    func defaultLoadingStatusStyle(
        font: Font = .caption,
        lineLimit: Int = 3,
        foregroundStyle: some ShapeStyle = .secondary,
        verticalPadding: CGFloat = 4.0
    ) -> some View {
        self.font(font)
            .foregroundStyle(foregroundStyle)
            .lineLimit(lineLimit)
            .padding(.vertical, verticalPadding)
    }
}

#Preview {
    VStack {
        LoadingStatusView(loadingState: .loading)
        LoadingStatusView(
            loadingState: .failure(
                errorMessage: "Sorry, something went wrong wrong"
            )
        )
        LoadingStatusView(
            loadingState: .failure(
                errorMessage: """
                    Sorry, something went wrong wrong. Super long message. 
                    Super long message. Super long message. Super long message. 
                    Super long message. Super long message. Super long message. 
                    Super long message.
                    """
            )
        )
        LoadingStatusView(loadingState: .loaded)
            .background(.orange)
    }
    .defaultLoadingStatusStyle()
}
