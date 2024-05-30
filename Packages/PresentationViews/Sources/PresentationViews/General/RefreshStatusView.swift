import SwiftUI

public enum LoadingState: Hashable {
    case loading
    case loaded
    case failure(errorMessage: String)
}

public struct RefreshStatusView: View {
    
    public let loadingState: LoadingState
    public let refreshDate: Date?
    public let loadingMessageTitle: LocalizedStringResource
    public let showsText: Bool
    
    private let timestampFormatter: DateFormatter = Formatter.relative(dateStyle: .full, timeStyle: .short)
    private var refreshDateFormatted: String? {
        guard let refreshDate else { return nil }
        return timestampFormatter.string(from: refreshDate)
    }
    
    public init(loadingState: LoadingState, 
                refreshDate: Date? = nil,
                loadingMessageTitle: LocalizedStringResource = .refreshStatusLoading,
                showsText: Bool = true) {
        self.loadingState = loadingState
        self.refreshDate = refreshDate
        self.loadingMessageTitle = loadingMessageTitle
        self.showsText = showsText
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            statusImage
            if showsText {
                statusText
            }
        }
    }
    
    @ViewBuilder private var statusImage: some View {
        switch loadingState {
        case .loading:
            ProgressView()
        case .loaded:
            EmptyView()
        case .failure:
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.adaptiveRed)
                .imageScale(.small)
        }
    }
    
    @ViewBuilder private var statusText: some View {
        switch loadingState {
        case .loading:
            Text(loadingMessageTitle)
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
