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
    
    @Binding var isFavourite: Bool

    public init(boardStates: [ArrivalsBoardState],
                lineGroupName: String,
                refreshDate: Date?,
                loadingState: LoadingState,
                isFavourite: Binding<Bool>) {
        self.boardStates = boardStates
        self.lineGroupName = lineGroupName
        self.refreshDate = refreshDate
        self.loadingState = loadingState
        self._isFavourite = isFavourite
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
                } footer: {
                    footerView
                }
                .padding(.horizontal)
                .background(Color.defaultBackground)
            }
        }
        .background(Color.defaultBackground)
    }

    private var noDataView: some View {
        HStack(spacing: 0) {
            Spacer()
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                    .imageScale(.large)
                Text("arrivals.no.data", bundle: .module)
                    .font(.subheadline)
                Spacer()
            }
            .frame(maxWidth: 600)
            Spacer()
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
            Spacer()
            ArrivalsBoardView(platformName: boardState.platformName,
                              cellItems: boardState.cellItems,
                              isExpanded: shouldShowExpandedView(forBoardID: boardState.id),
                              rotatingCellTimerPublisher: rotatingCellTimerPublisher)
                .buttonStyle(.plain)
                .frame(maxWidth: 600)
            Spacer()
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
    
    @ViewBuilder private var footerView: some View {
        HStack {
            Spacer()
            FavouritesButton(style: .large, isSelected: $isFavourite)
            Spacer()
        }
    }
}


// MARK: - Previews

private struct WrapperView: View {
    var boardStates: [ArrivalsBoardState]
    var lineGroupName: String = "Northern"
    var refreshDate: Date? = .now
    var loadingState: LoadingState = .loaded
    @State var isFavourite = false
    
    var body: some View {
        NavigationStack {
            ArrivalsBoardListView(boardStates: boardStates,
                                  lineGroupName: lineGroupName,
                                  refreshDate: refreshDate,
                                  loadingState: loadingState,
                                  isFavourite: $isFavourite)
            .navigationTitle("List preview")
        }
    }
    
}

#Preview("Loaded state") {
    WrapperView(boardStates: ModelStubs.northernLineBothPlatforms.toPlatformBoardStates(),
                loadingState: .loaded)
}

#Preview("Loading state") {
    WrapperView(boardStates: ModelStubs.northernLineBothPlatforms.toPlatformBoardStates(),
                loadingState: .loading)
}

#Preview("No data state") {
    WrapperView(boardStates: [])
}

#Preview("Error state") {
    WrapperView(boardStates: [], loadingState: .failure(errorMessage: "Oops, something went wrong"))
}
