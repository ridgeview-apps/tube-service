import Combine
import Shared
import SwiftUI
import Models

public struct ArrivalsBoardListView: View {
    

    // MARK: Public properties

    public let boardStates: [ArrivalsBoardState]
    public let lineGroupName: String
    public let refreshDate: Date?
    public let loadingState: LoadingState

    public init(boardStates: [ArrivalsBoardState],
                lineGroupName: String,
                refreshDate: Date? = nil,
                loadingState: LoadingState = .loaded) {
        self.boardStates = boardStates
        self.lineGroupName = lineGroupName
        self.refreshDate = refreshDate
        self.loadingState = loadingState
    }
    
    
    // MARK: Private properties
    
    private let rotatingCellTimerPublisher: AnyPublisher<Date, Never> = Timer.autoconnectedPublisher(every: 3)
    @State private var expandedBoardIDs = Set<String>()
    
    
    // MARK: - Layout

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                Section {
                    if boardStates.isEmpty && loadingState == .loaded {
                        noDataView
                    } else {
                        ForEach(boardStates) { boardState in
                            arrivalsBoardView(with: boardState)
                        }
                    }
                } header: {
                    headerTitleView
                }
                .padding(.horizontal)
                .background(Color.defaultBackground)
            }
        }
        .background(Color.defaultBackground)
    }

    private var noDataView: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
                .imageScale(.large)
            Text("arrivals.no.data", bundle: .module)
                .font(.subheadline)
        }
    }
    
    private var headerTitleView: some View {
        VStack(alignment: .leading) {
            Text(lineGroupName)
                .font(.subheadline)
            RefreshStatusView(loadingState: loadingState,
                              refreshDate: refreshDate)
                .font(.caption)
                .foregroundStyle(Color.adaptiveMidGrey2)
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func arrivalsBoardView(with boardState: ArrivalsBoardState) -> some View {
        HStack {
            Spacer(minLength: 0)
            ArrivalsBoardView(platformName: boardState.platformName,
                              cellItems: boardState.cellItems,
                              isExpanded: shouldShowExpandedView(forBoardID: boardState.id),
                              rotatingCellTimerPublisher: rotatingCellTimerPublisher)
                .buttonStyle(.plain)
                .frame(maxWidth: 600)
            Spacer(minLength: 0)
        }
    }
    
    private func shouldShowExpandedView(forBoardID boardID: String) -> Binding<Bool> {
        .init(
            get: {
                expandedBoardIDs.contains(boardID)
            },
            set: { isExpanded in
                if isExpanded {
                    expandedBoardIDs.insert(boardID)
                } else {
                    expandedBoardIDs.remove(boardID)
                }
            }
        )
    }
    

}


// MARK: - Previews

struct ArrivalsBoardListView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArrivalsBoardListView(boardStates: northernLinePlatformBoards,
                                  lineGroupName: "Northern",
                                  refreshDate: .now)
            .navigationTitle("List preview")
            
        }
        .previewDisplayName("Loaded state")
        ArrivalsBoardListView(boardStates: northernLinePlatformBoards,
                              lineGroupName: "Northern",
                              refreshDate: Date() - 10 * 60,
                              loadingState: .loading)
            .previewDisplayName("Loading state")
        ArrivalsBoardListView(boardStates: [],
                              lineGroupName: "Northern")
            .previewDisplayName("No data")
        ArrivalsBoardListView(boardStates: [],
                              lineGroupName: "Northern",
                              loadingState: .failure(errorMessage: "Oops, something went wrong"))
            .previewDisplayName("Error state")

    }
    
    private static var northernLinePlatformBoards: [ArrivalsBoardState] {
        ModelStubs.northernLineBothPlatforms.toPlatformBoardStates()
    }
}
