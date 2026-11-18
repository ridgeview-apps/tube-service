import Shared
import SwiftUI

/// The Station screen's live platform boards for the selected line group, followed by the favourite button.
struct StationBoardsView: View {

    let boardStates: [ArrivalsBoardState]
    let loadingState: LoadingState
    @Binding var isFavourite: Bool

    private let rotatingCellTimer = ObservableTimer.repeating(every: 3.0)
    @State private var expandedBoardIDs = Set<String>()
    @Environment(\.pausesRepeatingAnimations) private var pausesRepeatingAnimations

    var body: some View {
        StationSection(cardBackground: false) {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    refreshFailure
                    if !boardStates.isEmpty {
                        VStack(spacing: 24) {
                            ForEach(boardStates) { boardState in
                                ArrivalsBoardView(
                                    platformName: boardState.platformName,
                                    cellItems: boardState.cellItems,
                                    isExpanded: isExpanded(boardID: boardState.id),
                                    rotatingCellTimer: rotatingCellTimer
                                )
                                .buttonStyle(.plain)
                            }
                        }
                    } else {
                        switch loadingState {
                        case .loading: placeholderBoard
                        case .loaded: messageBoard(Text(.stationArrivalsEmpty), hint: Text(.stationArrivalsEmptyHint))
                        case .failure(let errorMessage):
                            messageBoard(Text(errorMessage), hint: Text(.stationArrivalsFailureRetryHint))
                        }
                    }
                }
                FavouritesButton(.station, style: .large, isSelected: $isFavourite)
            }
        }
    }

    // Only a failed refresh earns a row above the boards; the update time itself sits quietly in the navigation bar
    @ViewBuilder private var refreshFailure: some View {
        if case .failure = loadingState, !boardStates.isEmpty {
            Label {
                Text(.stationArrivalsRefreshFailed)
            } icon: {
                Image(systemName: "exclamationmark.circle.fill")
            }
            .labelStyle(.titleAndIcon)
            .defaultLastUpdatedTimeLabelStyle(foregroundStyle: Color.adaptiveRed)
        }
    }

    // Stands in for the boards while they first load, so the layout doesn't jump when they arrive
    private var placeholderBoard: some View {
        // Only the contents pulse, so a slow load still looks alive while the board keeps its frame
        PhaseAnimator(pausesRepeatingAnimations ? [false] : [false, true]) { isDimmed in
            ArrivalsBoardView(
                platformName: Self.placeholderBoardState.platformName,
                cellItems: Self.placeholderBoardState.cellItems,
                isExpanded: .constant(false),
                contentOpacity: isDimmed ? 0.4 : 1
            )
        } animation: { _ in
            .easeInOut(duration: 0.9)
        }
        .redacted(reason: .placeholder)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // The text is only ever shown redacted or invisible, so it's never localized
    private static let placeholderBoardState = ArrivalsBoardState(
        platformName: "Northbound - Platform 1",
        cellItems: (1...3).map { number in
            ArrivalsBoardCellItem(
                id: "placeholder-\(number)",
                numberLabel: .init(
                    value: number,
                    backgroundColor: .black,
                    textColor: .white,
                    textShadow: (color: .clear, radius: 0, x: 0, y: 0)
                ),
                headerRow: .init(
                    style: .tube,
                    destination: .towards("Placeholder destination"),
                    countdownText: .verbatim("0 mins"),
                    needsStrikethrough: false
                ),
                footerRow: .tubeLiveLocation("Between two placeholder stations")
            )
        }
    )

    // Laid over an invisible placeholder board, so the screen doesn't jump when loading ends
    private func messageBoard(_ message: Text, hint: Text) -> some View {
        ArrivalsBoardView(
            platformName: Self.placeholderBoardState.platformName,
            cellItems: Self.placeholderBoardState.cellItems,
            isExpanded: .constant(false),
            contentOpacity: 0
        )
        .accessibilityHidden(true)
        .overlay {
            VStack(spacing: 8) {
                message
                    .font(.headline)
                    .foregroundStyle(Color.arrivalsBoardPrimary)
                hint
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            .multilineTextAlignment(.center)
            .padding()
            .accessibilityElement(children: .combine)
        }
    }

    private func isExpanded(boardID: String) -> Binding<Bool> {
        .init(
            get: { expandedBoardIDs.contains(boardID) },
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
