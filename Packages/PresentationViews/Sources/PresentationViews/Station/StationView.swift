import Models
import Shared
import SwiftUI

/// A station's live boards and information, built from a header, an arrivals part and an info part so that a bus Stop
/// screen can reuse the same shape.
public struct StationView: View {

    public enum Action {
        case selectedLineGroup(Station.LineGroup)
        case tappedLine(Line)
        case planJourneyFromHere
        case planJourneyToHere
        /// The notices sheet opened, so its notices now count as seen.
        case openedNotices
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
        /// False until the first fetch of line statuses and notices has finished, so their cards don't push the
        /// screen down one by one as each arrives.
        public let hasLoaded: Bool
        /// Whether any notice hasn't been opened yet, which puts a dot on the notices button.
        public let hasUnseenNotices: Bool

        public init(lines: [Line], notices: [StationNotice], hasLoaded: Bool = true, hasUnseenNotices: Bool = false) {
            self.lines = lines
            self.notices = notices
            self.hasLoaded = hasLoaded
            self.hasUnseenNotices = hasUnseenNotices
        }
    }

    public let station: Station
    public let selectedLineGroup: Station.LineGroup
    public let arrivals: Arrivals
    public let info: Info
    @Binding public var isFavourite: Bool
    public let onAction: (Action) -> Void

    @State private var isShowingNotices = false
    @Environment(\.clock) private var clock

    public init(
        station: Station,
        selectedLineGroup: Station.LineGroup,
        arrivals: Arrivals,
        info: Info,
        isFavourite: Binding<Bool>,
        onAction: @escaping (Action) -> Void
    ) {
        self.station = station
        self.selectedLineGroup = selectedLineGroup
        self.arrivals = arrivals
        self.info = info
        self._isFavourite = isFavourite
        self.onAction = onAction
    }

    private var disruptedLines: [Line] { info.lines.disruptionsOnly() }

    private var selectedLineDisruptions: [Line] {
        disruptedLines.filter { selectedLineGroup.lineIds.contains($0.id) }
    }

    private var disruptedLineGroupIDs: Set<Station.LineGroup.ID> {
        station.lineGroups.ids(disruptedBy: disruptedLines)
    }

    private func showNotices() {
        isShowingNotices = true
        onAction(.openedNotices)
    }

    private var hasChips: Bool { station.lineGroups.count > 1 }

    /// No count: it said little. Orange, like the sheet's closure icons, stays while a closure is on today, even once
    /// seen, as the closure still applies. Otherwise the accent colour, not the chips' red, marks notices not seen yet.
    private enum NoticesBadge {
        case closureToday
        case unseen

        var style: AnyShapeStyle {
            switch self {
            case .closureToday: AnyShapeStyle(.orange)
            case .unseen: AnyShapeStyle(.tint)
            }
        }

        var accessibilityValue: Text {
            switch self {
            case .closureToday: Text(.stationNoticesClosureAccessibilityValue)
            case .unseen: Text(.stationNoticesUnseenAccessibilityValue)
            }
        }
    }

    private var noticesBadge: NoticesBadge? {
        if noticeSections.hasClosureToday { return .closureToday }
        return info.hasUnseenNotices ? .unseen : nil
    }

    private var noticeSections: StationNoticeSections {
        StationNoticeSections(notices: info.notices, stationName: station.name, now: clock.now)
    }

    public var body: some View {
        ScrollView {
            // The chips and line status card scroll away together: the screen is short, and changing chip replaces
            // everything below, so pinning the chips earned little
            VStack(alignment: .leading, spacing: 0) {
                if info.hasLoaded, hasChips {
                    StationLineChipsView(
                        lineGroups: station.lineGroups.sortedByName(),
                        selectedLineGroup: selectedLineGroup,
                        disruptedLineGroupIDs: disruptedLineGroupIDs,
                        onSelect: { onAction(.selectedLineGroup($0)) }
                    )
                }
                VStack(alignment: .leading, spacing: 20) {
                    if info.hasLoaded, !selectedLineDisruptions.isEmpty {
                        StationLineDisruptionsView(
                            lines: selectedLineDisruptions,
                            selectedLineIDs: selectedLineGroup.lineIds,
                            onTapLine: { onAction(.tappedLine($0)) }
                        )
                        .padding(.horizontal, 16)
                        // Clears the selected chip's disruption badge, while staying closer to the chips than the boards
                        .padding(.top, hasChips ? 6 : 0)
                    }
                    VStack(alignment: .leading, spacing: 24) {
                        // Until the cards above have loaded, only the placeholder board shows, so everything appears
                        // at once
                        StationArrivalsView(
                            boardStates: info.hasLoaded ? arrivals.boardStates : [],
                            refreshDate: arrivals.refreshDate,
                            loadingState: info.hasLoaded ? arrivals.loadingState : .loading,
                            isFavourite: $isFavourite
                        )
                        StationInfoView(station: station, onAction: handleInfoAction)
                    }
                }
                // The chip row's own padding is the gap below the chips, so the line status card sits under them
                .padding(.top, hasChips ? 0 : 16)
                .padding(.bottom, 16)
            }
        }
        // Cards that appear or go after the first load (e.g. on pull-to-refresh) slide in rather than snap
        .animation(.default, value: disruptedLines.map(\.id))
        .accessibilityIdentifier(AccessibilityID.Station.content)
        .defaultMaxWidthWithFullBackground()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if info.hasLoaded, !noticeSections.isEmpty {
                ToolbarItem {
                    Button(action: showNotices) {
                        Label {
                            Text(.stationNoticesTitle)
                        } icon: {
                            Image(systemName: noticesBadge == nil ? "info.circle" : "info.circle.badge")
                                // The first palette layer is the badge, but in the plain symbol it's the "i", which
                                // would otherwise turn blue too
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(noticesBadge?.style ?? AnyShapeStyle(.primary), .primary)
                                .contentTransition(.symbolEffect(.replace))
                        }
                    }
                    .accessibilityValue(noticesBadge?.accessibilityValue ?? Text(verbatim: ""))
                }
            }
            ToolbarItem {
                FavouritesButton(style: .small, isSelected: $isFavourite)
            }
        }
        .sheet(isPresented: $isShowingNotices) {
            StationNoticesView(
                stationName: station.name,
                sections: noticeSections
            )
        }
    }

    private func handleInfoAction(_ action: StationInfoView.Action) {
        switch action {
        case .planJourneyFromHere: onAction(.planJourneyFromHere)
        case .planJourneyToHere: onAction(.planJourneyToHere)
        }
    }
}


// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    var station: Station = ModelStubs.kingsCrossStation
    var boardStates: [ArrivalsBoardState] = ModelStubs.northernLineBothPlatforms.toPlatformBoardStates()
    var arrivalsLoadingState: LoadingState = .loaded
    var lines: [Line] = [.circle, .hammersmithAndCity, .metropolitan, .northern, .piccadilly, .victoria].map {
        Line(id: $0, lineStatuses: [.goodService])
    }
    var notices: [StationNotice] = []
    @State private var selectedLineGroup: Station.LineGroup?
    @State private var isFavourite = false

    var body: some View {
        NavigationStack {
            StationView(
                station: station,
                selectedLineGroup: selectedLineGroup ?? station.defaultLineGroup!,
                arrivals: .init(boardStates: boardStates, refreshDate: .now, loadingState: arrivalsLoadingState),
                info: .init(lines: lines, notices: notices),
                isFavourite: $isFavourite,
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
    // Circle is on the selected chip, so it leads the summary; Victoria is counted in "+N more"
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
    // The selected chip is fine, so the summary says so and only counts Piccadilly's delays
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
    WrapperView(boardStates: [], arrivalsLoadingState: .loading)
}

#Preview("Failure") {
    WrapperView(boardStates: [], arrivalsLoadingState: .failure(errorMessage: "Loading failure"))
}
