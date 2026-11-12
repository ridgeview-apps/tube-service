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

        public init(lines: [Line], notices: [StationNotice]) {
            self.lines = lines
            self.notices = notices
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

    private var noticeTexts: [String] {
        info.notices.map { $0.text.removingStationNamePrefix(station.name) }
    }

    private var disruptions: StationDisruptionsView {
        StationDisruptionsView(
            selectedLineDisruptions: selectedLineDisruptions,
            selectedLineIDs: selectedLineGroup.lineIds,
            noticesSummary: StationNoticesSummary(notices: info.notices, stationName: station.name, now: clock.now),
            onAction: handleDisruptionsAction
        )
    }

    private func handleDisruptionsAction(_ action: StationDisruptionsView.Action) {
        switch action {
        case .tappedLine(let line): onAction(.tappedLine(line))
        case .tappedNotices: isShowingNotices = true
        }
    }

    public var body: some View {
        ScrollView {
            // A pinned header rather than safeAreaBar: a horizontal ScrollView in a safeAreaBar took on the navigation
            // bar's inset twice after navigating back, hiding the chips behind a blank band
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                Section {
                    VStack(alignment: .leading, spacing: 24) {
                        if !disruptions.isEmpty {
                            disruptions
                                .padding(.horizontal, 16)
                        }
                        StationArrivalsView(
                            boardStates: arrivals.boardStates,
                            refreshDate: arrivals.refreshDate,
                            loadingState: arrivals.loadingState,
                            isFavourite: $isFavourite
                        )
                        StationInfoView(station: station, onAction: handleInfoAction)
                    }
                    .padding(.vertical, 16)
                } header: {
                    if station.lineGroups.count > 1 {
                        StationLineChipsView(
                            lineGroups: station.lineGroups.sortedByName(),
                            selectedLineGroup: selectedLineGroup,
                            disruptedLineGroupIDs: disruptedLineGroupIDs,
                            onSelect: { onAction(.selectedLineGroup($0)) }
                        )
                    }
                }
            }
        }
        .accessibilityIdentifier(AccessibilityID.Station.content)
        .defaultMaxWidthWithFullBackground()
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingNotices) {
            StationNoticesView(stationName: station.name, notices: noticeTexts)
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
