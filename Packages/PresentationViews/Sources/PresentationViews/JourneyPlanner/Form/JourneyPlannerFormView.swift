import Models
import SwiftUI

public struct JourneyPlannerFormView: View {
    
    @Binding var form: JourneyPlannerForm
    @Binding var recentJourneys: [RecentJourneyItem]
    @Binding var isTravelOptionsExpanded: Bool
    
    let locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus
    
    let onAction: (JourneyPlannerForm.Action) -> Void
    
    @Namespace private var animationNamespace
    
    // MARK: - Init
        
    public init(form: Binding<JourneyPlannerForm>,
                recentJourneys: Binding<[RecentJourneyItem]>,
                isTravelOptionsExpanded: Binding<Bool>,
                locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus,
                onAction: @escaping (JourneyPlannerForm.Action) -> Void) {
        self._form = form
        self._recentJourneys = recentJourneys
        self._isTravelOptionsExpanded = isTravelOptionsExpanded
        self.locationAccessoryStatus = locationAccessoryStatus
        self.onAction = onAction
    }
    
    
    // MARK: - Body
    
    public var body: some View {
        List {
            Group {
                formSection
                recentJourneysSection
            }
            
        }
        .buttonStyle(.plain)
        .listStyle(.plain)
        .defaultScrollContentBackgroundColor()
        .scrollBounceBehavior(.basedOnSize)
        .journeyPlannerFullWidthBackground()
    }
    
    private var formSection: some View {
        Section {
            JourneyPlannerFromToSelectionView(form: $form,
                                              locationAccessoryStatus: locationAccessoryStatus,
                                              animationNamespace: animationNamespace,
                                              onAction: onAction)
                .padding(.top, 4)

            JourneyPlannerTravelOptionsCell(
                isExpanded: $isTravelOptionsExpanded,
                timeSelection: $form.timeSelection,
                viaLocation: $form.via,
                onAction: handleTravelOptionsAction
            )
        } footer: {
            submitButton
                .padding(.top, 12)
        }
        .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
        .listRowBackground(Color.defaultCellBackground)
        .listSectionSeparator(.hidden)
    }
    
    private func handleTravelOptionsAction(_ action: JourneyPlannerTravelOptionsCell.Action) {
        switch action {
        case .tappedViaLocationButton:
            onAction(.tappedLocationField(.via))
        }
    }
    
    private var submitButton: some View {
        Button {
            submitForm()
        } label: {
            Text("journey.planner.show.journeys.button.title", bundle: .module)
        }
        .buttonStyle(.primary)
        .disabled(!form.canSubmit)
        .listRowBackground(Color.clear)
    }
    
    @ViewBuilder
    private var recentJourneysSection: some View {
        if !recentJourneys.isEmpty {
            Section {
                ForEach($recentJourneys) { $recentJourneyItem in
                    RecentJourneyCell(item: $recentJourneyItem,
                                      animationNamespace: animationNamespace) {
                        onAction(.tappedRecentJourney(recentJourneyItem))
                    }
                    .buttonStyle(.plain)
                }
                .onDeleteItem(in: recentJourneys) { recentJourney in
                    onAction(.swipedToDelete(recentJourney))
                }
            } header: {
                Text("journey.planner.recent.journeys.section.title", bundle: .module)
                    .font(.footnote)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.defaultBackground)
            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
    }
    
    private func submitForm() {
        onAction(.tappedSubmit)
    }
}

extension View {
    func journeyPlannerFullWidthBackground() -> some View {
        ZStack {
            Color
                .defaultBackground
                .ignoresSafeArea()
            self
                .withDefaultMaxWidth()
        }
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    @State var form: JourneyPlannerForm
    @State var recentJourneys: [RecentJourneyItem] = []
    @State var isTravelOptionsExpanded = false
    var locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus = .loadingState(.loaded)
    
    var body: some View {
        NavigationStack {
            JourneyPlannerFormView(
                form: $form,
                recentJourneys: $recentJourneys,
                isTravelOptionsExpanded: $isTravelOptionsExpanded,
                locationAccessoryStatus: locationAccessoryStatus,
                onAction: { print("Action \($0)") }
            )
            .navigationTitle("Preview")
        }
    }
}

#Preview("Default form") {
    Previewer(form: .empty)
}

#Preview("Valid form") {
    Previewer(
        form: .init(
            from: .currentLocation(name: .init(title: "Piccadilly", subtitle: "Westminster"),
                                   coordinate: .init(lat: 0, lon: 0)),
            to: .station(ModelStubs.kingsCrossStation),
            timeSelection: .leaveNow()
        )
    )
}

#Preview("Invalid form") {
    Previewer(
        form: .init(
            from: nil,
            to: nil,
            timeSelection: .leaveNow(),
            showsInlineErrorsImmediately: true
        )
    )
}

#Preview("Same journey locations") {
    Previewer(
        form: .init(
            from: .station(ModelStubs.kingsCrossStation),
            to: .station(ModelStubs.kingsCrossStation),
            timeSelection: .leaveNow(),
            showsInlineErrorsImmediately: true
        )
    )
}

#Preview("Options applied") {
    Previewer(
        form: .init(
            from: .currentLocation(name: .init(title: "Piccadilly", subtitle: "Westminster"),
                                   coordinate: .init(lat: 0, lon: 0)),
            to: .station(ModelStubs.kingsCrossStation),
            via: .station(ModelStubs.eastFinchleyStation),
            timeSelection: .init(option: .arriveBy, date: .now + 3600)
        )
    )
}

#Preview("Recent journeys") {
    Previewer(
        form: .init(
            from: .currentLocation(name: .init(title: "Piccadilly", subtitle: "Westminster"),
                                   coordinate: .init(lat: 0, lon: 0)),
            to: .station(ModelStubs.kingsCrossStation),
            timeSelection: .leaveNow()
        ),
        recentJourneys: [
            .init(id: UUID(),
                  fromLocation: .station(ModelStubs.eastFinchleyStation),
                  toLocation: .station(ModelStubs.kingsCrossStation),
                  viaLocation: nil,
                  lastUsed: .distantPast),
            .init(id: UUID(),
                  fromLocation: .station(ModelStubs.kingsCrossStation),
                  toLocation: .station(ModelStubs.eastFinchleyStation),
                  viaLocation: .station(ModelStubs.angelStation),
                  lastUsed: .distantPast)
        ]
    )
}
