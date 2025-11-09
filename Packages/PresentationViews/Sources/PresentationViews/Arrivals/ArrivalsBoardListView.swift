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
    
    private let rotatingCellTimer = ObservableTimer.repeating(every: 3.0)
    @State private var expandedBoardIDs = Set<String>()
    
    
    // MARK: - Layout

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24) {
                Section {
                    Group {
                        if boardStates.isEmpty && loadingState == .loaded {
                            noDataView
                        } else {
                            ForEach(boardStates) { boardState in
                                arrivalsBoardView(with: boardState)
                            }
                        }
                    }
                    .withDefaultMaxWidth()
                } header: {
                    headerTitleView
                } footer: {
                    footerView
                }
                .padding(.horizontal, 20)
                .background(Color.defaultBackground)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.defaultBackground)
        .withHardScrollEdgeEffectStyle()
    }

    private var noDataView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
                .imageScale(.large)
            Text(.arrivalsNoData)
                .font(.subheadline)
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
        ArrivalsBoardView(platformName: boardState.platformName,
                          cellItems: boardState.cellItems,
                          isExpanded: shouldShowExpandedView(forBoardID: boardState.id),
                          rotatingCellTimer: rotatingCellTimer)
        .buttonStyle(.plain)
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
        FavouritesButton(style: .large, isSelected: $isFavourite)
    }
}


// MARK: - Previews

import ModelStubs

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
    WrapperView(boardStates: ModelStubs.elizabethLineBothPlatforms.toPlatformBoardStates(forLineID: .elizabeth),
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
