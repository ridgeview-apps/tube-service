import ModelStubs
import Models
import SwiftUI

public struct JourneyResultsView: View {

    @Binding public var fromLocation: JourneyLocation?
    @Binding public var toLocation: JourneyLocation?
    public var pages: [JourneyPage]
    @Binding public var selectedPreset: JourneyModePreset
    public let viaLocation: JourneyLocation?
    public let errorFormatter: (any Error) -> String
    public let onAction: (JourneyResultsAction) -> Void

    @State private var headerCollapseProgress: CGFloat = 0
    @State private var headerHeight: CGFloat = 0
    @State private var maxHeaderHeight: CGFloat = 0
    @State private var expandedJourneyIDs: Set<String> = []

    private let headerCollapseThreshold: CGFloat = 60

    private var headerHeightCompensation: CGFloat {
        max(0, maxHeaderHeight - headerHeight)
    }


    public init(
        pages: [JourneyPage],
        fromLocation: Binding<JourneyLocation?>,
        toLocation: Binding<JourneyLocation?>,
        viaLocation: JourneyLocation?,
        selectedPreset: Binding<JourneyModePreset>,
        errorFormatter: @escaping (any Error) -> String,
        onAction: @escaping (JourneyResultsAction) -> Void
    ) {
        self.pages = pages
        self._fromLocation = fromLocation
        self._toLocation = toLocation
        self.viaLocation = viaLocation
        self._selectedPreset = selectedPreset
        self.errorFormatter = errorFormatter
        self.onAction = onAction
    }

    private var isAnyPageLoading: Bool {
        pages.contains { $0.isLoading }
    }

    private var hasLoadedResults: Bool {
        totalCellItemCount > 0
    }

    public var body: some View {
        VStack(spacing: 0) {
            journeyHeaderView
            JourneyModeFilterStrip(selectedPreset: $selectedPreset, isDisabled: isAnyPageLoading, onCustomTapped: { onAction(.customPresetTapped) })
            Divider()
            ScrollView {
                contentView
            }
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { _, newOffset in
                let scrollProgress = newOffset / headerCollapseThreshold
                headerCollapseProgress = scrollProgress.clamped(to: 0...1)
            }
            .refreshable {
                if !isAnyPageLoading {
                    onAction(.refresh)
                }
            }
        }
        .task {
            onAction(.initialFetch)
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
        .defaultMaxWidthWithFullBackground()
    }

    private var journeyHeaderView: some View {
        JourneyResultsHeaderView(
            fromLocation: $fromLocation,
            toLocation: $toLocation,
            viaLocation: viaLocation,
            isSwapDisabled: isAnyPageLoading,
            collapseProgress: headerCollapseProgress,
            onSwapLocations: {
                onAction(.refresh)
            }
        )
        .onGeometryChange(for: CGFloat.self, of: \.size.height) { newHeight in
            headerHeight = newHeight
            maxHeaderHeight = max(maxHeaderHeight, newHeight)
        }
    }

    private var totalCellItemCount: Int {
        pages.reduce(0) { $0 + ($1.cellItems?.count ?? 0) }
    }

    private var contentView: some View {
        LazyVStack(
            alignment: .leading,
            spacing: 12
        ) {
            if hasLoadedResults {
                earlierJourneysButton
            }
            ForEach(pages) { page in
                pageView(page: page)
            }
            if hasLoadedResults {
                laterJourneysButton
            } else if !pages.isEmpty && pages.allSatisfy({ $0.isLoaded }) {
                zeroResultsView
            }
            Spacer().frame(height: 30 + headerHeightCompensation)  // Bottom scroll padding (extra compensates for collapsed header to keep total scroll length stable)
        }
        .padding(.top, 8)
        .animation(.default, value: pages)
    }

    private var zeroResultsView: some View {
        ContentUnavailableView(
            .journeyResultsZeroResultsTitle,
            systemImage:
                "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath"
        )
    }

    @ViewBuilder
    private func pageView(page: JourneyPage) -> some View {
        switch page {
        case .loading:
            HStack(spacing: 4) {
                Spacer()
                ProgressView()
                    .controlSize(.small)
                Text(.journeyResultsPageFetchingResults)
                Spacer()
            }
            .defaultLoadingStatusStyle(verticalPadding: hasLoadedResults ? 2 : 12)
            .padding(.horizontal)
        case .failed(_, let error):
            HStack {
                Spacer()
                LoadingStatusView(loadingState: .failure(errorMessage: errorFormatter(error)))
                    .defaultLoadingStatusStyle(verticalPadding: 12)
                Spacer()
            }
            .padding(.horizontal)
        case .loaded(_, let cellItems):
            ForEach(cellItems) { cellItem in
                JourneyResultsCell(
                    value: cellItem,
                    isExpanded: expandedJourneyIDs.contains(cellItem.id),
                    onToggle: { toggleExpansion(for: cellItem) }
                )
                .padding(.horizontal)
            }
        }
    }

    private func toggleExpansion(for cellItem: JourneyResultsCellItem) {
        if expandedJourneyIDs.contains(cellItem.id) {
            expandedJourneyIDs.remove(cellItem.id)
        } else {
            expandedJourneyIDs.insert(cellItem.id)
        }
    }

    private var earlierJourneysButton: some View {
        pagerButton(
            title: .journeyResultsEarlierJourneysButton,
            style: .up
        ) {
            onAction(.earlierJourneys)
        }
    }

    private var laterJourneysButton: some View {
        pagerButton(
            title: .journeyResultsLaterJourneysButton,
            style: .down
        ) {
            onAction(.laterJourneys)
        }
    }

    private func pagerButton(
        title: LocalizedStringResource,
        style: PagerButton.Style,
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Spacer()
            PagerButton(
                style: style,
                title: title,
                action: action
            )
            Spacer()
        }
        .disabled(isAnyPageLoading)
        .padding(.horizontal)
    }

}

fileprivate extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - Previews

private struct Previewer: View {
    @State var pages: [JourneyPage]
    @State var fromLocation: JourneyLocation? = .station(
        ModelStubs.angelStation
    )
    @State var toLocation: JourneyLocation? = .station(
        ModelStubs.kingsCrossStation
    )
    @State var selectedPreset: JourneyModePreset = .trainAndBus
    var viaLocation: JourneyLocation? = .namedLocation(
        .init(
            name: .init(title: "Random location", subtitle: ""),
            coordinate: nil,
            isCurrentLocation: false
        )
    )

    var body: some View {
        JourneyResultsView(
            pages: pages,
            fromLocation: $fromLocation,
            toLocation: $toLocation,
            viaLocation: viaLocation,
            selectedPreset: $selectedPreset,
            errorFormatter: { $0.localizedDescription },
            onAction: { print("Action: \($0)") }
        )
    }
}

extension JourneyPage {
    fileprivate static func loadedPage(
        id: String,
        results: JourneyResults
    ) -> Self {
        .loaded(
            id: id,
            cellItems: (results.journeys ?? [])
                .removingDuplicates()
                .map {
                    JourneyResultsCellItem(
                        journey: $0,
                        journeyDiagramID: UUID().uuidString
                    )
                }
        )
    }

    fileprivate static func loadingPage(id: String) -> Self {
        .loading(id: id)
    }
}

#Preview("Loaded (3 pages)") {
    Previewer(
        pages: [
            .loadedPage(
                id: "previous",
                results: ModelStubs.journeyResultsKingsXToWaterlooEarlier
            ),
            .loadedPage(
                id: "initial",
                results: ModelStubs.journeyResultsKingsXToWaterlooNow
            ),
            .loadedPage(
                id: "next",
                results: ModelStubs.journeyResultsKingsXToWaterlooLater
            )
        ]
    )
}

#Preview("Loading (initial)") {
    Previewer(
        pages: [.loadingPage(id: "initial")]
    )
}

#Preview("Loading (next)") {
    Previewer(
        pages: [
            .loadedPage(
                id: "initial",
                results: ModelStubs.journeyResultsKingsXToWaterlooNow
            ),
            .loadingPage(id: "next")
        ]
    )
}

#Preview("Loading (previous)") {
    Previewer(
        pages: [
            .loadingPage(id: "previous"),
            .loadedPage(
                id: "initial",
                results: ModelStubs.journeyResultsKingsXToWaterlooNow
            )
        ]
    )
}

#Preview("Loading error") {
    Previewer(
        pages: [
            .failed(id: "initial", error: URLError(.notConnectedToInternet))
        ]
    )
}

#Preview("No results") {
    Previewer(
        pages: [
            .loaded(id: "initial", cellItems: [])
        ]
    )
}
