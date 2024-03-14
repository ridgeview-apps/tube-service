import SwiftUI

public enum LoadingState: Equatable {
    case loading
    case loaded
    case failure(errorMessage: String)
}

public struct RefreshStatusView: View {
    
    public let loadingState: LoadingState
    public let refreshDate: Date?
    public let loadingMessageTitle: LocalizedStringKey
    public let showsText: Bool
    
    private let timestampFormatter: DateFormatter = Formatter.relative(dateStyle: .full, timeStyle: .short)
    
    public init(loadingState: LoadingState, 
                refreshDate: Date? = nil,
                loadingMessageTitle: LocalizedStringKey = "refresh.status.loading",
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
            Text(loadingMessageTitle, bundle: .module)
        case let .failure(errorMessage):
            Text(errorMessage)
                .foregroundStyle(.adaptiveRed)
        case .loaded:
            if let refreshDate {
                Text("refresh.status.last.updated \(timestampFormatter.string(from: refreshDate))",
                     bundle: .module)
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
