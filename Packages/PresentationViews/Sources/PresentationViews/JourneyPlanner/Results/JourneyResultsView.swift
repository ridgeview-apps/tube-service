import Models
import SwiftUI

public struct JourneyResultsView: View {
    
    @Binding public var fromLocation: JourneyLocationPicker.Value?
    @Binding public var toLocation: JourneyLocationPicker.Value?
    public let viaLocation: JourneyLocationPicker.Value?
    public let timeOption: JourneyTimePickerSelection
    public let loadingState: LoadingState
    public let journeys: [Journey]
    public let onRefresh: () -> Void
    
    @State private var hasSwappedLocations = false
    @Namespace private var animationNamespace
    
    private let timestampFormatter: DateFormatter = Formatter.relative(dateStyle: .medium,
                                                                       timeStyle: .short)
    
    public init(loadingState: LoadingState,
                journeys: [Journey],
                fromLocation: Binding<JourneyLocationPicker.Value?>,
                toLocation: Binding<JourneyLocationPicker.Value?>,
                viaLocation: JourneyLocationPicker.Value?,
                timeoption: JourneyTimePickerSelection,
                onRefresh: @escaping () -> Void) {
        self.loadingState = loadingState
        self.journeys = journeys
        self._fromLocation = fromLocation
        self._toLocation = toLocation
        self.viaLocation = viaLocation
        self.timeOption = timeoption
        self.onRefresh = onRefresh
    }
    
    public var body: some View {
        VStack {
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
                .padding(.horizontal)
            }
            .refreshable {
                if loadingState != .loading {
                    refreshData()
                }
            }

        }
        .withDefaultMaxWidth()
    }
    
    private var journeyTitleView: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    if let fromLocation {
                        JourneyLocationTitleLabel(value: fromLocation)
                            .swapValuesGeometryEffectID(.firstPairItem("locationsPair"), isSwapped: hasSwappedLocations, in: animationNamespace)
                    }
                    
                    Text("journey.results.to.label.title", bundle: .module)
                        .font(.caption)
                    
                    if let toLocation {
                        JourneyLocationTitleLabel(value: toLocation)
                            .swapValuesGeometryEffectID(.secondPairItem("locationsPair"), isSwapped: hasSwappedLocations, in: animationNamespace)

                    }
                }
                .font(.headline)
                
                Spacer()
                
                swapLocationsButton
            }
            
            if let viaLocation {
                VStack(alignment: .leading) {
                    Text("journey.results.via.title", bundle: .module)
                    JourneyLocationTitleLabel(value: viaLocation)
                        .lineLimit(1)
                }
                .font(.caption)
            }
        }
        .padding()
        .background(Color.defaultCellBackground)
    }
    
    private var swapLocationsButton: some View {
        SwapValuesButton(isSwapped: $hasSwappedLocations,
                         valueA: $fromLocation,
                         valueB: $toLocation,
                         namespace: animationNamespace)
            .disabled(loadingState == .loading)
            .frame(width: 44, height: 44)
            .onChange(of: hasSwappedLocations) { _ in
                refreshData()
            }
    }
        
    @ViewBuilder
    private var loadedView: some View {
        if journeys.isEmpty {
            Text("journey.results.zero.results.title", bundle: .module)
                .foregroundStyle(Color.adaptiveMidGrey2)
                .padding(.top, 12)
        } else {
            LazyVStack(alignment: .leading, spacing: 20) {
                Section {
                    ForEach(Array(journeys.enumerated()), id: \.offset) { journeyIndex, journey in
                        JourneyResultsCell(journey: journey,
                                           journeyID: String(journeyIndex),
                                           isInitiallyExpanded: journeyIndex == 0)
                    }
                } header: {
                    VStack(alignment: .leading) {
                        timeOptionText
                            .font(.subheadline)
                        Text("journey.planner.results.count \(journeys.count)",
                             bundle: .module)
                            .font(.footnote)
                    }
                }
            }
        }
    }
    
    private var timeOptionText: some View {
        switch timeOption.option {
        case .leaveNow:
            Text("journey.results.time.option.leaving.at \(timeOption.formattedDate)", bundle: .module)
        case .leaveAt:
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
    var journeys: [Journey] = []
    @State var fromLocation: JourneyLocationPicker.Value? = .station(ModelStubs.angelStation)
    @State var toLocation: JourneyLocationPicker.Value? = .station(ModelStubs.kingsCrossStation)
    var viaLocation: JourneyLocationPicker.Value? = .namedLocation(.init(name: .init(title: "Random location", subtitle: ""),
                                                                        coordinate: nil))
    var timeOption: JourneyTimePickerSelection = .leaveNow()
    
    var body: some View {
        JourneyResultsView(
            loadingState: loadingState,
            journeys: journeys,
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
        journeys: ModelStubs.journeyItineraryKingsXToWaterloo.journeys?.removingDuplicates() ?? []
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
