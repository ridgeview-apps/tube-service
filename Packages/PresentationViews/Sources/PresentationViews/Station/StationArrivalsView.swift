import Models
import Shared
import SwiftUI

/// A station's live boards, split into parts that a bus Stop screen can reuse.
public struct StationArrivalsView: View {

    public enum Action {
        case selectedLineGroup(Station.LineGroup)
        case tappedLineStatusRow
    }

    public struct Arrivals {
        public let boardStates: [ArrivalsBoardState]
        public let refreshDate: Date?
        public let loadingState: LoadingState

        public init(boardStates: [ArrivalsBoardState], refreshDate: Date?, loadingState: LoadingState) {
            self.boardStates = boardStates
            self.refreshDate = refreshDate
            self.loadingState = loadingState
        }

        /// The update time, for the navigation bar's subtitle.
        public var lastUpdatedSubtitle: Text {
            guard let refreshDate else { return Text(verbatim: "") }
            return Text(.refreshStatusLastUpdated(Self.timeText(refreshDate)))
        }

        // Just the time: live arrivals are never from another day, so "today" adds nothing
        private static func timeText(_ date: Date) -> String {
            date.formatted(date: .omitted, time: .shortened)
        }
    }

    public let station: Station
    public let selectedLineGroup: Station.LineGroup
    public let arrivals: Arrivals
    /// The status of every line at the station.
    public let lines: [Line]
    /// True until the line statuses first arrive or fail to load.
    public let isLoadingLines: Bool
    @Binding public var isFavourite: Bool
    public let onRefresh: @Sendable () async -> Void
    public let onAction: (Action) -> Void

    public init(
        station: Station,
        selectedLineGroup: Station.LineGroup,
        arrivals: Arrivals,
        lines: [Line],
        isLoadingLines: Bool,
        isFavourite: Binding<Bool>,
        onRefresh: @escaping @Sendable () async -> Void,
        onAction: @escaping (Action) -> Void
    ) {
        self.station = station
        self.selectedLineGroup = selectedLineGroup
        self.arrivals = arrivals
        self.lines = lines
        self.isLoadingLines = isLoadingLines
        self._isFavourite = isFavourite
        self.onRefresh = onRefresh
        self.onAction = onAction
    }

    private var disruptedLines: [Line] { lines.disruptionsOnly() }

    private var selectedLines: [Line] {
        lines.filter { selectedLineGroup.lineIds.contains($0.id) }
    }

    private var lineStatus: StationLineStatusRow.Status {
        .init(lines: selectedLines, isLoading: isLoadingLines)
    }

    /// The selected chip keeps its badge too, so the badges don't move around as the selection changes.
    private var disruptedLineGroupIDs: Set<Station.LineGroup.ID> {
        station.lineGroups.ids(disruptedBy: disruptedLines)
    }

    private var hasChips: Bool { station.lineGroups.count > 1 }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                StationLineStatusRow(
                    status: lineStatus,
                    onTap: lineStatus.isDisruption ? { onAction(.tappedLineStatusRow) } : nil
                )
                .padding(.horizontal, 16)
                StationBoardsView(
                    boardStates: arrivals.boardStates,
                    loadingState: arrivals.loadingState,
                    isFavourite: $isFavourite
                )
            }
            // Closer to the chips than the boards, as the line status row describes the selected chip
            .padding(.top, hasChips ? 2 : 16)
            .padding(.bottom, 16)
        }
        // Before the bar, so neither reaches the chips' scroll view, whose refresh inset hides the chips on reopening
        .refreshable(action: onRefresh)
        .accessibilityIdentifier(AccessibilityID.StationArrivals.content)
        // Pinned, so they still show other lines have arrivals once the boards scroll
        .safeAreaBar(edge: .top) {
            if hasChips {
                StationLineChipsView(
                    lineGroups: station.lineGroups.sortedByName(),
                    selectedLineGroup: selectedLineGroup,
                    disruptedLineGroupIDs: disruptedLineGroupIDs,
                    onSelect: { onAction(.selectedLineGroup($0)) }
                )
            }
        }
        // Status rows that come and go slide rather than snap
        .animation(.default, value: disruptedLines.map(\.id))
        .defaultMaxWidthWithFullBackground()
    }
}

// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    var station: Station = ModelStubs.kingsCrossStation
    var boardStates: [ArrivalsBoardState] = ModelStubs.northernLineBothPlatforms.toPlatformBoardStates()
    var arrivalsLoadingState: LoadingState = .loaded
    var refreshDate: Date? = .now
    var lines: [Line] = [.circle, .hammersmithAndCity, .metropolitan, .northern, .piccadilly, .victoria].map {
        Line(id: $0, lineStatuses: [.goodService])
    }
    var isLoadingLines = false
    @State private var selectedLineGroup: Station.LineGroup?
    @State private var isFavourite = false

    var body: some View {
        NavigationStack {
            StationArrivalsView(
                station: station,
                selectedLineGroup: selectedLineGroup ?? station.defaultLineGroup!,
                arrivals: .init(boardStates: boardStates, refreshDate: refreshDate, loadingState: arrivalsLoadingState),
                lines: lines,
                isLoadingLines: isLoadingLines,
                isFavourite: $isFavourite,
                onRefresh: {},
                onAction: { action in
                    if case .selectedLineGroup(let lineGroup) = action { selectedLineGroup = lineGroup }
                }
            )
            .navigationTitle(station.name)
        }
    }
}

#Preview("Several line groups") {
    WrapperView()
}

#Preview("Disrupted lines") {
    // Circle is on the selected chip, so the line status row names it; both disrupted chips have a badge
    WrapperView(
        lines: [
            Line(id: .circle, lineStatuses: [.disrupted(.minorDelays, "Minor Delays", "Due to an earlier signal failure.")]),
            Line(id: .victoria, lineStatuses: [.disrupted(.severeDelays, "Severe Delays", "Due to a fire alert at Brixton.")]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService]),
            Line(id: .metropolitan, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .piccadilly, lineStatuses: [.goodService])
        ]
    )
}

#Preview("Another line disrupted") {
    // The selected chip has a good service; only Piccadilly's chip has a badge
    WrapperView(
        lines: [
            Line(id: .piccadilly, lineStatuses: [.disrupted(.minorDelays, "Minor Delays", "Due to an earlier signal failure.")]),
            Line(id: .circle, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService]),
            Line(id: .metropolitan, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .victoria, lineStatuses: [.goodService])
        ]
    )
}

private extension LineStatus {
    static func disrupted(_ severity: LineStatusSeverity, _ description: String, _ reason: String) -> LineStatus {
        .init(statusSeverity: severity, statusSeverityDescription: description, reason: reason, disruption: nil)
    }
}

#Preview("One line group") {
    WrapperView(
        station: ModelStubs.stations.first { $0.lineGroups.count == 1 }!,
        boardStates: ModelStubs.elizabethLineBothPlatforms.toPlatformBoardStates(forLineID: .elizabeth)
    )
}

#Preview("No arrivals") {
    WrapperView(boardStates: [])
}

#Preview("Loading") {
    WrapperView(boardStates: [], arrivalsLoadingState: .loading, refreshDate: nil, lines: [], isLoadingLines: true)
}

#Preview("Failure") {
    WrapperView(boardStates: [], arrivalsLoadingState: .failure(errorMessage: "Loading failure"))
}
