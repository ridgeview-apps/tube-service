import Models
import SwiftUI

public struct JourneyResultsView: View {
    
    @Binding public var fromLocation: JourneyLocationPicker.Value?
    @Binding public var toLocation: JourneyLocationPicker.Value?
    @Binding public var cellItems: [JourneyResultsCellItem]
    public let viaLocation: JourneyLocationPicker.Value?
    public let timeOption: JourneyTimePickerSelection
    public let loadingState: LoadingState
    public let onRefresh: () -> Void
    
    @State private var hasSwappedLocations = false
    @Namespace private var animationNamespace
    
    private let timestampFormatter: DateFormatter = Formatter.relative(dateStyle: .medium,
                                                                       timeStyle: .short)
    
    public init(loadingState: LoadingState,
                cellItems: Binding<[JourneyResultsCellItem]>,
                fromLocation: Binding<JourneyLocationPicker.Value?>,
                toLocation: Binding<JourneyLocationPicker.Value?>,
                viaLocation: JourneyLocationPicker.Value?,
                timeoption: JourneyTimePickerSelection,
                onRefresh: @escaping () -> Void) {
        self.loadingState = loadingState
        self._cellItems = cellItems
        self._fromLocation = fromLocation
        self._toLocation = toLocation
        self.viaLocation = viaLocation
        self.timeOption = timeoption
        self.onRefresh = onRefresh
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            journeyTitleView
            ScrollView {
                VStack(spacing: 24) {
                    switch loadingState {
                    case .loading, .failure:
                        RefreshStatusView(loadingState: loadingState)
                            .foregroundStyle(Color.adaptiveMidGrey2)
                            .padding(.top, 12)
                    case .loaded:
                        loadedView
                    }
                }
            }
            .refreshable {
                if loadingState != .loading {
                    refreshData()
                }
            }
        }
        .journeyPlannerFullWidthBackground()
    }
    
    private var journeyTitleView: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    if let fromLocation {
                        JourneyLocationTitleLabel(value: fromLocation)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .swapValuesGeometryEffectID(.firstPairItem("locationsPair"), isSwapped: hasSwappedLocations, in: animationNamespace)
                    }
                    
                    Text("journey.results.to.label.title", bundle: .module)
                        .font(.caption)
                    
                    if let toLocation {
                        JourneyLocationTitleLabel(value: toLocation)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .swapValuesGeometryEffectID(.secondPairItem("locationsPair"), isSwapped: hasSwappedLocations, in: animationNamespace)

                    }
                }
                .lineLimit(1)
                .font(.headline)
                
                Spacer()
                
                swapLocationsButton
            }
            
            if let viaLocation {
                HStack(spacing: 0) {
                    Text("journey.results.via.title", bundle: .module)
                    JourneyLocationTitleLabel(value: viaLocation)
                        .lineLimit(1)
                        .bold()
                }
                .font(.caption2)
            }
        }
        .padding()
        .background(Color.defaultCellBackground)
    }
    
    private var swapLocationsButton: some View {
        SwapValuesButton(isSwapped: $hasSwappedLocations,
                         valueA: $fromLocation,
                         valueB: $toLocation)
            .disabled(loadingState == .loading)
            .frame(width: 44, height: 44)
            .onChange(of: hasSwappedLocations) { _ in
                refreshData()
            }
    }
        
    @ViewBuilder
    private var loadedView: some View {
        if cellItems.isEmpty {
            Text("journey.results.zero.results.title", bundle: .module)
                .foregroundStyle(Color.adaptiveMidGrey2)
                .padding(.top, 12)
        } else {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach($cellItems) { $cellItem in
                        JourneyResultsCell(cellItem: $cellItem)
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                    }
                } header: {
                    resultsSectionHeader
                }
            }
        }
    }
    
    private var resultsSectionHeader: some View {
        HStack(spacing: 0) {
            Text("journey.planner.results.count \(cellItems.count)",
                 bundle: .module)
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
            Text("journey.results.time.option.leaving.at \(timeOption.formattedDate)", bundle: .module)
        case .arriveBy:
            Text("journey.results.time.option.arriving.by \(timeOption.formattedDate)", bundle: .module)
        }
    }
    
    private func refreshData() {
        onRefresh()
    }
}

private struct Previewer: View {
    var loadingState: LoadingState
    @State var cellItems: [JourneyResultsCellItem] = []
    @State var fromLocation: JourneyLocationPicker.Value? = .station(ModelStubs.angelStation)
    @State var toLocation: JourneyLocationPicker.Value? = .station(ModelStubs.kingsCrossStation)
    var viaLocation: JourneyLocationPicker.Value? = .namedLocation(.init(name: .init(title: "Random location", subtitle: ""),
                                                                        coordinate: nil,
                                                                        isCurrentLocation: false))
    var timeOption: JourneyTimePickerSelection = .leaveNow()
    
    var body: some View {
        JourneyResultsView(
            loadingState: loadingState,
            cellItems: $cellItems,
            fromLocation: $fromLocation,
            toLocation: $toLocation,
            viaLocation: viaLocation,
            timeoption: timeOption,
            onRefresh: { print("Refreshing") }
        )
    }
}

#Preview("Loaded") {
    Previewer(
        loadingState: .loaded,
        cellItems: (ModelStubs.journeyItineraryKingsXToWaterloo.journeys ?? [])
                        .removingDuplicates()
                        .map {
                            JourneyResultsCellItem(journey: $0,
                                                   journeyDiagramID: UUID().uuidString,
                                                   isExpanded: false)
                        }        
    )
}

#Preview("Loading") {
    Previewer(loadingState: .loading)
}

#Preview("Loading error") {
    Previewer(loadingState: .failure(errorMessage: "Oops, something bad happened"))
}

#Preview("No results") {
    Previewer(loadingState: .loaded)
}
