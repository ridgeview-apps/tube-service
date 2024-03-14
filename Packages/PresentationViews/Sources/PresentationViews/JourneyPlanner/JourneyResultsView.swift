import Models
import SwiftUI

public struct JourneyResultsView: View {
    public enum Action {
        case refresh
    }
    public let fromLocation: JourneyLocationPicker.Value
    public let toLocation: JourneyLocationPicker.Value
    public let loadingState: LoadingState
    public let journeys: [Journey]
    public let onAction: (Action) -> Void
    
    @State private var swapAnimationIDs = false // This is just used for animation purposes
    
    public init(loadingState: LoadingState,
                journeys: [Journey],
                fromLocation: JourneyLocationPicker.Value,
                toLocation: JourneyLocationPicker.Value,
                onAction: @escaping (Action) -> Void) {
        self.loadingState = loadingState
        self.journeys = journeys
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.onAction = onAction
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            journeyTitleView
            ScrollView {
                VStack(spacing: 24) {
                    switch loadingState {
                    case .loading, .failure:
                        RefreshStatusView(loadingState: loadingState)
                        .foregroundStyle(Color.adaptiveMidGrey2)
                    case .loaded:
                        loadedView
                    }
//                    if loadingState != .loading {
//                        Button {
//                            withAnimation {
//                                onAction(.refresh)
//                            }
//                        } label: {
//                            Text("refresh.button.title", bundle: .module)
//                        }
//                        .buttonStyle(.primary)
//                    }
                }
                .padding(.horizontal)
            }
            .refreshable {
                if loadingState != .loading {
                    onAction(.refresh)
                }
            }

        }
        .withDefaultMaxWidth()
    }
    
    private var journeyTitleView: some View {
        HStack {
            VStack {
                titleRow("journey.results.from.label.title") {
                    JourneyLocationValueTitleLabel(value: fromLocation,
                                                   style: .form(.omitted))
                }
                titleRow("journey.results.to.label.title") {
                    JourneyLocationValueTitleLabel(value: toLocation,
                                                   style: .form(.omitted))
                }
            }
            .font(.headline)
        }
        .padding()
        .background(Color.defaultCellBackground)
    }
    
    @ViewBuilder
    private var loadedView: some View {
        if journeys.isEmpty {
            Text("journey.results.zero.results.title", bundle: .module)
                .foregroundStyle(Color.adaptiveMidGrey2)
        } else {
            LazyVStack(spacing: 20) {
                Section {
                    ForEach(Array(journeys.enumerated()), id: \.offset) { journeyIndex, journey in
                        JourneyCellView(journey: journey,
                                        journeyID: String(journeyIndex))
                    }
                }
            }
        }
    }
    
    private func titleRow(_ titleKey: LocalizedStringKey,
                          valueLabel: () -> some View) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(titleKey, bundle: .module)
                .font(.footnote)
            Spacer()
            valueLabel()
        }
        .multilineTextAlignment(.trailing)
        .lineLimit(1)
    }
}

private struct Previewer: View {
    var loadingState: LoadingState
    var journeys: [Journey] = []
    var fromLocation: JourneyLocationPicker.Value = .station(ModelStubs.kingsCrossStation)
    var toLocation: JourneyLocationPicker.Value = .searchResult(.init(title: "Waterloo", subtitle: ""))
    
    var body: some View {
        JourneyResultsView(
            loadingState: loadingState,
            journeys: journeys,
            fromLocation: fromLocation,
            toLocation: toLocation,
            onAction: { print($0) }
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
