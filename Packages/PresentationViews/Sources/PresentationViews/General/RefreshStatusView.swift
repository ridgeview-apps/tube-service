import SwiftUI

public enum LoadingState: Equatable {
    case loading
    case loaded
    case failure(errorMessage: String)
}

public struct RefreshStatusView: View {
    
    public let loadingState: LoadingState
    public let refreshDate: Date?
    
    public init(loadingState: LoadingState, 
                refreshDate: Date?) {
        self.loadingState = loadingState
        self.refreshDate = refreshDate
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            statusImage
            statusText
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
                .foregroundColor(.red)
                .imageScale(.small)
        }
    }
    
    @ViewBuilder private var statusText: some View {
        switch loadingState {
        case .loading:
            Text("refresh.status.updating", bundle: .module)
        case let .failure(errorMessage):
            Text(errorMessage)
                .foregroundStyle(.red)
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
    }
}

private let timestampFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .short
    formatter.doesRelativeDateFormatting = true
    return formatter
}()
