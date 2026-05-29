import ModelStubs
import Models
import SwiftUI

public struct JourneyResultsView: View {

    @Binding public var fromLocation: JourneyLocationPicker.Value?
    @Binding public var toLocation: JourneyLocationPicker.Value?
    @Binding public var pages: [JourneyResultsPage]
    public let viaLocation: JourneyLocationPicker.Value?
    public let timeOption: JourneyTimePickerSelection
    public let onAction: (JourneyResultsAction) -> Void

    @State private var hasSwappedLocations = false
    @Namespace private var animationNamespace

    private let timestampFormatter: DateFormatter = Formatter.relative(
        dateStyle: .medium,
        timeStyle: .short
    )

    public init(
        pages: Binding<[JourneyResultsPage]>,
        fromLocation: Binding<JourneyLocationPicker.Value?>,
        toLocation: Binding<JourneyLocationPicker.Value?>,
        viaLocation: JourneyLocationPicker.Value?,
        timeoption: JourneyTimePickerSelection,
        onAction: @escaping (JourneyResultsAction) -> Void
    ) {
        self._pages = pages
        self._fromLocation = fromLocation
        self._toLocation = toLocation
        self.viaLocation = viaLocation
        self.timeOption = timeoption
        self.onAction = onAction
    }

    private var isAnyPageLoading: Bool {
        pages.contains { $0.loadingState == .loading }
    }

    private var hasLoadedResults: Bool {
        totalCellItemCount > 0
    }

    public var body: some View {
        VStack(spacing: 0) {
            Divider()
            journeyTitleView
            Divider()
            ScrollView {
                contentView
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
        .journeyPlannerFullWidthBackground()
    }

    private var journeyTitleView: some View {
        VStack(alignment: .leading) {
            if let fromLocation {
                JourneyLocationTitleLabel(value: fromLocation)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .swapValuesGeometryEffectID(
                        .firstPairItem("locationsPair"),
                        isSwapped: hasSwappedLocations,
                        in: animationNamespace
                    )
                    .routeAnchor(.from)
            }

            Spacer()
                .frame(height: 44)

            VStack(alignment: .leading, spacing: 4) {
                if let toLocation {
                    JourneyLocationTitleLabel(value: toLocation)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .swapValuesGeometryEffectID(
                            .secondPairItem("locationsPair"),
                            isSwapped: hasSwappedLocations,
                            in: animationNamespace
                        )
                        .routeAnchor(.to)

                }

                if let viaLocation {
                    HStack(spacing: 0) {
                        Text(.journeyResultsViaTitle)
                        JourneyLocationTitleLabel(value: viaLocation)
                            .bold()
                    }
                    .font(.caption2)
                }
            }
        }
        .lineLimit(1)
        .font(.headline)
        .routeIndicatorOverlay(
            leadingOffset: 28,
            leadingPadding: 44
        ) {
            swapLocationsButton
        }
        .padding(.vertical)
        .background(Color.defaultCellBackground)
    }

    private var swapLocationsButton: some View {
        JourneyPlannerSwapButton(
            isSwapped: $hasSwappedLocations,
            valueA: $fromLocation,
            valueB: $toLocation
        )
        .disabled(isAnyPageLoading)
        .onChange(of: hasSwappedLocations) {
            onAction(.refresh)
        }
    }

    private var totalCellItemCount: Int {
        pages.reduce(0) { $0 + $1.cellItems.count }
    }

    private var contentView: some View {
        LazyVStack(
            alignment: .leading,
            spacing: 12,
            pinnedViews: [.sectionHeaders]
        ) {
            Section {
                if hasLoadedResults {
                    earlierJourneysButton
                }
                ForEach($pages) { $page in
                    pageView(page: $page)
                }
                if hasLoadedResults {
                    laterJourneysButton
                } else if pages.allSatisfy({ $0.loadingState == .loaded }) {
                    zeroResultsView
                }
                Spacer().frame(height: 30) // Bottom scroll padding
            } header: {
                if hasLoadedResults {
                    resultsSectionHeader
                }
            }
        }
    }

    private var zeroResultsView: some View {
        ContentUnavailableView(
            .journeyResultsZeroResultsTitle,
            systemImage:
                "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath"
        )
    }

    @ViewBuilder
    private func pageView(page: Binding<JourneyResultsPage>) -> some View {
        switch page.wrappedValue.loadingState {
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
        case .failure:
            HStack {
                Spacer()
                LoadingStatusView(loadingState: page.wrappedValue.loadingState)
                    .defaultLoadingStatusStyle(verticalPadding: 12)
                Spacer()
            }
            .padding(.horizontal)
        case .loaded:
            ForEach(page.cellItems) { $cellItem in
                JourneyResultsCell(cellItem: $cellItem)
                    .padding(.horizontal)
            }
        }
    }

    private var earlierJourneysButton: some View {
        pagerButton(
            title: .journeyResultsEarlierJourneysButton,
            imageName: "chevron.up"
        ) {
            onAction(.earlierJourneys)
        }
    }

    private var laterJourneysButton: some View {
        pagerButton(
            title: .journeyResultsLaterJourneysButton,
            imageName: "chevron.down"
        ) {
            onAction(.laterJourneys)
        }
    }
    
    private func pagerButton(
        title: LocalizedStringResource,
        imageName: String,
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Spacer()
            Button {
                action()
            } label: {
                Label(
                    title,
                    systemImage: imageName
                )
            }
            .buttonStyle(.bordered)
            .disabled(isAnyPageLoading)
            Spacer()
        }
        .padding(.horizontal)
    }

    private var resultsSectionHeader: some View {
        HStack(spacing: 0) {
            Text(.journeyPlannerResultsCount(totalCellItemCount))
            Text(", ")
            timeOptionText
            Spacer()
        }
        .font(.footnote)
        .lineLimit(2)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.defaultBackground)
    }

    private var timeOptionText: some View {
        switch timeOption.option {
        case .leaveNow, .leaveAt:
            Text(.journeyResultsTimeOptionLeavingAt(timeOption.formattedDate))
        case .arriveBy:
            Text(.journeyResultsTimeOptionArrivingBy(timeOption.formattedDate))
        }
    }

}

// MARK: - Previews

private struct Previewer: View {
    @State var pages: [JourneyResultsPage]
    @State var fromLocation: JourneyLocationPicker.Value? = .station(
        ModelStubs.angelStation
    )
    @State var toLocation: JourneyLocationPicker.Value? = .station(
        ModelStubs.kingsCrossStation
    )
    var viaLocation: JourneyLocationPicker.Value? = .namedLocation(
        .init(
            name: .init(title: "Random location", subtitle: ""),
            coordinate: nil,
            isCurrentLocation: false
        )
    )
    var timeOption: JourneyTimePickerSelection = .leaveNow()

    var body: some View {
        JourneyResultsView(
            pages: $pages,
            fromLocation: $fromLocation,
            toLocation: $toLocation,
            viaLocation: viaLocation,
            timeoption: timeOption,
            onAction: { print("Action: \($0)") }
        )
    }
}

extension JourneyResultsPage {
    fileprivate static func loadedPage(
        id: String,
        results: JourneyResults
    ) -> Self {
        JourneyResultsPage(
            id: id,
            loadingState: .loaded,
            cellItems: (results.journeys ?? [])
                .removingDuplicates()
                .map {
                    JourneyResultsCellItem(
                        journey: $0,
                        journeyDiagramID: UUID().uuidString,
                        isExpanded: false
                    )
                }
        )
    }

    fileprivate static func loadingPage(id: String) -> Self {
        JourneyResultsPage(
            id: id,
            loadingState: .loading,
            cellItems: []
        )
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
            ),
        ]
    )
}

#Preview("Loading error") {
    Previewer(
        pages: [
            JourneyResultsPage(
                id: "initial",
                loadingState: .failure(
                    errorMessage: "Oops, something bad happened"
                ),
                cellItems: []
            )
        ]
    )
}

#Preview("No results") {
    Previewer(
        pages: [
            JourneyResultsPage(
                id: "initial",
                loadingState: .loaded,
                cellItems: []
            )
        ]
    )
}
