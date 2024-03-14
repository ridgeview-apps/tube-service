import Models
import SwiftUI

public struct JourneyPlannerView: View {
    
    @Binding var form: JourneyPlannerForm
    @Binding var recentJourneys: [RecentJourneyItem]
    
    let locationAccessoryStatus: JourneyLocationValueButton.AccessoryStatus
    
    let onAction: (JourneyPlannerForm.Action) -> Void
    
    @Namespace private var animationNamespace
    
    // MARK: - Init
        
    public init(form: Binding<JourneyPlannerForm>,
                recentJourneys: Binding<[RecentJourneyItem]>,
                locationAccessoryStatus: JourneyLocationValueButton.AccessoryStatus,
                onAction: @escaping (JourneyPlannerForm.Action) -> Void) {
        self._form = form
        self._recentJourneys = recentJourneys
        self.locationAccessoryStatus = locationAccessoryStatus
        self.onAction = onAction
    }
    
    
    // MARK: - Body
    
    public var body: some View {
        List {
            formSection
            recentJourneysSection
        }
        .buttonStyle(.plain)
        .listStyle(.plain)
        .withDefaultMaxWidth()
        .defaultScrollContentBackgroundColor()
        .scrollBounceBehavior(.basedOnSize)
    }
    
    private var formSection: some View {
        Section {
            JourneyPlannerFromToSelectionView(form: $form,
                                              locationAccessoryStatus: locationAccessoryStatus,
                                              onAction: onAction)
            

            JourneyPlannerTravelOptionsView(
                timeSelection: $form.timeSelection,
                viaLocation: $form.via,
                onAction: handleTravelOptionsAction
            )
            .frame(minHeight: 44)
        } footer: {
            submitButton
        }
        .listRowBackground(Color.defaultCellBackground)
        .listSectionSeparator(.hidden)
        
    }
    private func handleTravelOptionsAction(_ action: JourneyPlannerTravelOptionsView.Action) {
        switch action {
        case .viaLocationButtonTapped:
            onAction(.tapLocationField(.via))
        }
    }
    
    private var submitButton: some View {
        Button {
            submitForm()
        } label: {
            Text("journey.planner.show.journeys.button.title", bundle: .module)
        }
        .buttonStyle(.primary)
        .disabled(!form.isValid)
    }
    
    @ViewBuilder
    private var recentJourneysSection: some View {
        if !recentJourneys.isEmpty {
            Section {
                ForEach($recentJourneys) { $recentJourneyItem in
                    RecentJourneyCell(item: $recentJourneyItem,
                                      animationNamespace: animationNamespace) {
                        onAction(.selectRecentJourney(recentJourneyItem))
                    }
                    .buttonStyle(.plain)
                    .id(recentJourneyItem.id)
                }
                .onDeleteItem(in: recentJourneys) { recentJourney in
                    onAction(.deleteRecentJourney(recentJourney))
                }
            } header: {
                Text("journey.planner.recent.journeys.section.title", bundle: .module)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .listSectionSeparator(.hidden)
            .listRowBackground(Color.defaultCellBackground)
        }
    }
    
    private func submitForm() {
        onAction(.submit)
    }
}

// MARK: - Previews

private struct Previewer: View {
    @State var form: JourneyPlannerForm
    @State var recentJourneys: [RecentJourneyItem] = []
    var locationAccessoryStatus: JourneyLocationValueButton.AccessoryStatus = .loadingState(.loaded)
    
    var body: some View {
        NavigationStack {
            JourneyPlannerView(
                form: $form,
                recentJourneys: $recentJourneys,
                locationAccessoryStatus: locationAccessoryStatus,
                onAction: { print("Action \($0)") }
            )
            .navigationTitle("Preview")
        }
    }
}

#Preview("Default form") {
    Previewer(form: .init())
}

#Preview("Valid form") {
    Previewer(
        form: .init(
            from: .currentLocation(.init(name: .init(title: "Picadilly", 
                                                     subtitle: "Westminster"))),
            to: .station(ModelStubs.kingsCrossStation),
            timeSelection: .leaveNow()
        )
    )
}

#Preview("Options applied") {
    Previewer(
        form: .init(
            from: .currentLocation(.init(name: .init(title: "Piccadilly", subtitle: "Westminster"))),
            to: .station(ModelStubs.kingsCrossStation),
            via: .station(ModelStubs.eastFinchleyStation),
            timeSelection: .init(option: .arriveBy, date: .now + 3600)
        )
    )
}

#Preview("Recent journeys") {
    Previewer(
        form: .init(),
        recentJourneys: [
            .init(fromLocation: .station(ModelStubs.eastFinchleyStation),
                  toLocation: .station(ModelStubs.kingsCrossStation),
                  viaLocation: nil)
        ]
    )
}
