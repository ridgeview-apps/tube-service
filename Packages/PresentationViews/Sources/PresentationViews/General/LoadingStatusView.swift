import SwiftUI

public enum LoadingState: Hashable {
    case loading
    case loaded
    case failure(errorMessage: String)
}

public struct LoadingStatusView: View {
    
    public let loadingState: LoadingState
    public let refreshedAt: Date?
    
    private let timestampFormatter: DateFormatter = Formatter.relative(
        dateStyle: .short,
        timeStyle: .short,
        context: .middleOfSentence
    )
    
    private var formattedRefreshDate: String? {
        guard let refreshedAt else { return nil }
        return timestampFormatter.string(from: refreshedAt)
    }
    
    public init(
        loadingState: LoadingState,
        refreshedAt: Date? = nil
    ) {
        self.loadingState = loadingState
        self.refreshedAt = refreshedAt
    }
    
    public var body: some View {
        HStack(alignment: verticalAlignment, spacing: 4) {
            switch loadingState {
            case .loading:
                ProgressView()
                    .controlSize(.small)
                Text(.refreshStatusLoading)
            case .loaded:
                if let formattedRefreshDate {
                    Image(systemName: "clock")
                    Text(
                        .refreshStatusLastUpdated(formattedRefreshDate)
                    )
                }
            case .failure(let reason):
                Group {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(reason)
                }
                .foregroundStyle(.adaptiveRed)
            }
        }
    }
    
    private var verticalAlignment: VerticalAlignment {
        switch loadingState {
        case .loading:
            .center
        case .loaded, .failure:
            .firstTextBaseline
        }
    }
}

extension View {
    func defaultLoadingStatusStyle(
        font: Font = .caption,
        foregroundStyle: some ShapeStyle = .secondary
    ) -> some View {
        self.font(font)
            .foregroundStyle(foregroundStyle)
    }
}

#Preview {
    VStack {
        LoadingStatusView(loadingState: .loading)
        LoadingStatusView(
            loadingState: .loaded,
            refreshedAt: .now
        )
        LoadingStatusView(
            loadingState: .failure(errorMessage: "Sorry, something went wrong")
        )
    }
    .defaultLoadingStatusStyle()
}
