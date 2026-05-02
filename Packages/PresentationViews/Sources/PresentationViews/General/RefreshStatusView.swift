import SwiftUI

public enum LoadingState: Hashable {
    case loading
    case loaded
    case failure(errorMessage: String)
}

public struct RefreshStatusView: View {
    
    public let loadingState: LoadingState
    public let refreshDate: Date?
    public let showsText: Bool

    private let timestampFormatter: DateFormatter = Formatter.relative(dateStyle: .medium, timeStyle: .short)
    private var refreshDateFormatted: String? {
        guard let refreshDate else { return nil }
        return timestampFormatter.string(from: refreshDate)
    }

    public init(loadingState: LoadingState,
                refreshDate: Date? = nil,
                showsText: Bool = true) {
        self.loadingState = loadingState
        self.refreshDate = refreshDate
        self.showsText = showsText
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            statusImage
            if showsText {
                statusText
            }
        }
        .animation(.default, value: loadingState)
    }

    @ViewBuilder private var statusImage: some View {
        switch loadingState {
        case .loading:
            ProgressView()
                .controlSize(.mini)
        case .loaded:
            if refreshDate != nil {
                Image(systemName: "clock")
                    .imageScale(.small)
            }
        case .failure:
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.adaptiveRed)
                .imageScale(.small)
        }
    }

    @ViewBuilder private var statusText: some View {
        switch loadingState {
        case .loading:
            EmptyView()
        case let .failure(errorMessage):
            Text(errorMessage)
                .foregroundStyle(.adaptiveRed)
        case .loaded:
            if let refreshDateFormatted {
                Text(.refreshStatusLastUpdated(refreshDateFormatted))
            }
        }
    }
}

#Preview {
    VStack {
        RefreshStatusView(loadingState: .loading, refreshDate: .now)
        RefreshStatusView(loadingState: .loaded, refreshDate: .now)
        RefreshStatusView(loadingState: .loaded, refreshDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        RefreshStatusView(loadingState: .loaded, refreshDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!)
        RefreshStatusView(loadingState: .loaded, refreshDate: nil)
        RefreshStatusView(loadingState: .failure(errorMessage: "Sorry, something went wrong"), refreshDate: nil)
        RefreshStatusView(loadingState: .failure(errorMessage: "Sorry, something went wrong"), refreshDate: nil,
                          showsText: false)
    }
}
