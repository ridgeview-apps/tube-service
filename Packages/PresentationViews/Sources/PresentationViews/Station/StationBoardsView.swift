import Shared
import SwiftUI

/// Live boards, with a placeholder while they first load and a message when there are none.
struct StationBoardsView: View {

    let arrivals: LiveArrivals
    var style: ArrivalsBoardState.Style = .train

    private var boardStates: [ArrivalsBoardState] { arrivals.boardStates }
    private var loadingState: LoadingState { arrivals.loadingState }

    private let rotatingCellTimer = ObservableTimer.repeating(every: 3.0)
    @State private var expandedBoardIDs = Set<String>()
    @Environment(\.pausesRepeatingAnimations) private var pausesRepeatingAnimations

    var body: some View {
        StationSection(cardBackground: false) {
            VStack(alignment: .leading, spacing: 8) {
                refreshFailure
                if !boardStates.isEmpty {
                    VStack(spacing: 24) {
                        ForEach(boardStates) { boardState in
                            ArrivalsBoardView(
                                platformName: boardState.platformName,
                                cellItems: boardState.cellItems,
                                style: boardState.style,
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
                platformName: placeholderBoardState.platformName,
                cellItems: placeholderBoardState.cellItems,
                style: style,
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

    private var placeholderBoardState: ArrivalsBoardState {
        switch style {
        case .train: Self.trainPlaceholderBoardState
        case .bus: Self.busPlaceholderBoardState
        }
    }

    // The text is only ever shown redacted or invisible, so it's never localized
    private static let trainPlaceholderBoardState = ArrivalsBoardState(
        platformName: "Northbound - Platform 1",
        cellItems: (1...3).map { number in
            ArrivalsBoardCellItem(
                id: "placeholder-\(number)",
                leadingLabel: .lineTile(
                    .init(
                        text: String(number),
                        backgroundColor: .black,
                        textColor: .white,
                        textShadow: (color: .clear, radius: 0, x: 0, y: 0)
                    )
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

    private static let busPlaceholderBoardState = ArrivalsBoardState(
        platformName: "Stop A",
        cellItems: (1...5).map { number in
            ArrivalsBoardCellItem(
                id: "placeholder-\(number)",
                leadingLabel: .busRoute(arrivalNumber: number, route: "000"),
                headerRow: .init(
                    style: .tube,
                    destination: .towards("Placeholder destination"),
                    countdownText: .verbatim("0 mins"),
                    needsStrikethrough: false
                ),
                footerRow: nil
            )
        },
        style: .bus
    )

    // Laid over an invisible placeholder board, so the screen doesn't jump when loading ends
    private func messageBoard(_ message: Text, hint: Text) -> some View {
        ArrivalsBoardView(
            platformName: placeholderBoardState.platformName,
            cellItems: placeholderBoardState.cellItems,
            style: style,
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
