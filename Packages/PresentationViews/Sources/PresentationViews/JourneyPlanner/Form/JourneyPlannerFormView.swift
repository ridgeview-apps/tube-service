import Models
import SwiftUI

public struct JourneyPlannerFormView: View {
    
    @Binding var form: JourneyPlannerForm
    @Binding var recentJourneys: [RecentJourneyItem]
    
    let locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus
    
    let onAction: (JourneyPlannerForm.Action) -> Void
    
    @Namespace private var animationNamespace
    
    // MARK: - Init
        
    public init(form: Binding<JourneyPlannerForm>,
                recentJourneys: Binding<[RecentJourneyItem]>,
                locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus,
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
        .defaultScrollContentBackgroundColor()
        .scrollBounceBehavior(.basedOnSize)
        .journeyPlannerFullWidthBackground()
    }
    
    private var formSection: some View {
        Section {
            VStack {
                fromToSelectionView
                timePickerCell
                viaLocationCell
            }
            .padding(.vertical, 4)
        } footer: {
            submitButton
                .listRowInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
                .listRowBackground(Color.clear)
        }
        .listRowBackground(Color.defaultCellBackground)
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
    
    private var fromToSelectionView: some View {
        JourneyPlannerFromToSelectionView(
            form: $form,
            locationAccessoryStatus: locationAccessoryStatus,
            animationNamespace: animationNamespace,
            onAction: onAction
        )
    }
    
    private var timePickerCell: some View {
        JourneyTimePickerView(selection: $form.timeSelection)
            .frame(minHeight: 44)
    }
    
    private var viaLocationCell: some View {
        JourneyLocationFormButton(
            value: $form.via,
            placeholderText: .journeyPlannerTravelOptionsViaPlaceholderTitle,
            prefixLabelTitle: form.via == nil ? nil : .journeyPlannerViaLabelTitle
        ) {
            onAction(.tappedLocationField(.via))
        }
    }
    
    private var submitButton: some View {
        Button {
            submitForm()
        } label: {
            Text(.journeyPlannerShowJourneysButtonTitle)
        }
        .buttonStyle(.primary)
        .disabled(!form.canSubmit)
    }
    
    @ViewBuilder
    private var recentJourneysSection: some View {
        if !recentJourneys.isEmpty {
            Spacer()
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
                Text(.journeyPlannerRecentJourneysSectionTitle)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.defaultBackground)
            .listRowInsets(.init(top: 0, leading: 16, bottom: 8, trailing: 16))
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
    var locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus = .loadingState(.loaded)
    
    var body: some View {
        NavigationStack {
            JourneyPlannerFormView(
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
