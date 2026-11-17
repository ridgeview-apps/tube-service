import Models
import Shared
import SwiftUI

/// A station's live boards and information, split into parts that a bus Stop screen can reuse.
public struct StationView: View {

    public enum Action {
        case selectedLineGroup(Station.LineGroup)
        case tappedInfo
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
    }

    public struct Info {
        /// The status of every line at the station.
        public let lines: [Line]
        /// Closures first, and none that have ended.
        public let notices: [StationNotice]
        /// True until the line statuses first arrive or fail to load.
        public let isLoadingLines: Bool
        /// Whether any notice hasn't been opened yet, which puts a dot on the notices button.
        public let hasUnseenNotices: Bool

        public init(lines: [Line], notices: [StationNotice], isLoadingLines: Bool = false, hasUnseenNotices: Bool = false) {
            self.lines = lines
            self.notices = notices
            self.isLoadingLines = isLoadingLines
            self.hasUnseenNotices = hasUnseenNotices
        }
    }

    public let station: Station
    public let selectedLineGroup: Station.LineGroup
    public let arrivals: Arrivals
    public let info: Info
    @Binding public var isFavourite: Bool
    public let onRefresh: @Sendable () async -> Void
    public let onAction: (Action) -> Void

    @Environment(\.clock) private var clock

    public init(
        station: Station,
        selectedLineGroup: Station.LineGroup,
        arrivals: Arrivals,
        info: Info,
        isFavourite: Binding<Bool>,
        onRefresh: @escaping @Sendable () async -> Void,
        onAction: @escaping (Action) -> Void
    ) {
        self.station = station
        self.selectedLineGroup = selectedLineGroup
        self.arrivals = arrivals
        self.info = info
        self._isFavourite = isFavourite
        self.onRefresh = onRefresh
        self.onAction = onAction
    }

    private var disruptedLines: [Line] { info.lines.disruptionsOnly() }

    private var selectedLines: [Line] {
        info.lines.filter { selectedLineGroup.lineIds.contains($0.id) }
    }

    /// The selected chip has no badge, as the line status row right below it already says it's disrupted.
    private var disruptedLineGroupIDs: Set<Station.LineGroup.ID> {
        station.lineGroups.ids(disruptedBy: disruptedLines).subtracting([selectedLineGroup.id])
    }

    private var hasChips: Bool { station.lineGroups.count > 1 }

    private var noticesBadge: StationInfoButton.Badge? {
        if noticeSections.hasClosureToday { return .closureToday }
        return info.hasUnseenNotices ? .unseen : nil
    }

    private var noticeSections: StationNoticeSections {
        StationNoticeSections(notices: info.notices, stationName: station.name, now: clock.now)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                StationLineStatusRow(
                    lines: selectedLines,
                    isLoading: info.isLoadingLines,
                    onTap: { onAction(.tappedLineStatusRow) }
                )
                .padding(.horizontal, 16)
                StationArrivalsView(
                    boardStates: arrivals.boardStates,
                    refreshDate: arrivals.refreshDate,
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
        .accessibilityIdentifier(AccessibilityID.Station.content)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Always shown, as every station has a location, so the toolbar doesn't shift once notices load
            ToolbarItem {
                StationInfoButton(badge: noticesBadge) { onAction(.tappedInfo) }
            }
            ToolbarItem {
                FavouritesButton(.station, style: .small, isSelected: $isFavourite)
            }
        }
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
    var notices: [StationNotice] = []
    var isLoadingLines = false
    @State private var selectedLineGroup: Station.LineGroup?
    @State private var isFavourite = false

    var body: some View {
        NavigationStack {
            StationView(
                station: station,
                selectedLineGroup: selectedLineGroup ?? station.defaultLineGroup!,
                arrivals: .init(boardStates: boardStates, refreshDate: refreshDate, loadingState: arrivalsLoadingState),
                info: .init(lines: lines, notices: notices, isLoadingLines: isLoadingLines),
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
    // Circle is on the selected chip, so the line status row names it; Victoria badges its chip
    WrapperView(
        lines: [
            Line(id: .circle, lineStatuses: [.disrupted(.minorDelays, "Minor Delays", "Due to an earlier signal failure.")]),
            Line(id: .victoria, lineStatuses: [.disrupted(.severeDelays, "Severe Delays", "Due to a fire alert at Brixton.")]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService]),
            Line(id: .metropolitan, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .piccadilly, lineStatuses: [.goodService])
        ],
        notices: [StationNotice(text: "The escalator to platform 5 is closed")]
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

#Preview("Station notice only") {
    WrapperView(notices: [StationNotice(text: "The escalator to platform 5 is closed")])
}

#Preview("Closure today") {
    WrapperView(notices: [StationNotice(text: "Westbound trains will not stop here.", kind: "Part Closure")])
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
