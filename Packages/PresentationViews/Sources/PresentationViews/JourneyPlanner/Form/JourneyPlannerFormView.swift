import ModelStubs
import Models
import SwiftUI

public struct JourneyPlannerFormView: View {

    @Binding var form: JourneyPlannerForm
    @Binding var recentJourneys: [RecentJourneyItem]

    let locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus

    let onAction: (JourneyPlannerForm.Action) -> Void

    @Namespace private var animationNamespace
    private var showsDatePicker: Bool {
        form.timeSelection.option != .leaveNow
    }

    // MARK: - Init

    public init(
        form: Binding<JourneyPlannerForm>,
        recentJourneys: Binding<[RecentJourneyItem]>,
        locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus,
        onAction: @escaping (JourneyPlannerForm.Action) -> Void
    ) {
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
            VStack(spacing: 16) {
                fromToSelectionView
                    .padding(.leading, 16)
                    .padding(.trailing, 8)
                Group {
                    travelOptionsChips
                    submitButton
                }
                .padding(.horizontal, 16)

            }
            .padding(.vertical, 16)
            .cardStyle()
        }
        .listRowBackground(Color.defaultBackground)
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

    // MARK: - Travel option chips

    private var travelOptionsChips: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showsDatePicker {
                timeSelectionGroup
                JourneyPlannerViaChip(via: $form.via) {
                    onAction(.tappedLocationField(.via))
                }
            } else {
                HStack(spacing: 8) {
                    JourneyPlannerTimeChip(timeSelection: $form.timeSelection)
                    JourneyPlannerViaChip(via: $form.via) {
                        onAction(.tappedLocationField(.via))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .buttonStyle(.borderless)
    }

    private var timeSelectionGroup: some View {
        HStack {
            JourneyPlannerTimeChip(timeSelection: $form.timeSelection)
            CompactDatePicker(
                selection: $form.timeSelection.date,
                minimumDate: .now,
                minuteInterval: 5
            )
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(Color(.tertiarySystemFill), in: RoundedRectangle(cornerRadius: 12))
        .transition(.opacity.combined(with: .move(edge: .top)))
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
            Section {
                ForEach($recentJourneys) { $recentJourneyItem in
                    RecentJourneyCell(
                        item: $recentJourneyItem,
                        animationNamespace: animationNamespace
                    ) {
                        onAction(.tappedRecentJourney(recentJourneyItem))
                    }
                    .buttonStyle(.plain)
                }
                .onDeleteItem(in: recentJourneys) { recentJourney in
                    onAction(.swipedToDelete(recentJourney))
                }
            } header: {
                HStack(spacing: 4) {
                    Image(systemName: "clock.arrow.circlepath")
                    Text(.journeyPlannerRecentJourneysSectionTitle)
                }
                .secondarySectionHeaderStyle()
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

private struct Previewer: View {
    @State var form: JourneyPlannerForm
    @State var recentJourneys: [RecentJourneyItem] = []
    var locationAccessoryStatus: JourneyLocationTitleLabel.AccessoryStatus =
        .loadingState(.loaded)

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
            from: .currentLocation(
                name: .init(title: "Piccadilly", subtitle: "Westminster"),
                coordinate: .init(lat: 0, lon: 0)
            ),
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
            from: .currentLocation(
                name: .init(title: "Piccadilly", subtitle: "Westminster"),
                coordinate: .init(lat: 0, lon: 0)
            ),
            to: .station(ModelStubs.kingsCrossStation),
            via: .station(ModelStubs.eastFinchleyStation),
            timeSelection: .init(option: .arriveBy, date: .now + 3600)
        )
    )
}

#Preview("Recent journeys") {
    Previewer(
        form: .init(
            from: .currentLocation(
                name: .init(title: "Piccadilly", subtitle: "Westminster"),
                coordinate: .init(lat: 0, lon: 0)
            ),
            to: .station(ModelStubs.kingsCrossStation),
            timeSelection: .leaveNow()
        ),
        recentJourneys: [
            .init(
                id: UUID(),
                fromLocation: .station(ModelStubs.eastFinchleyStation),
                toLocation: .station(ModelStubs.kingsCrossStation),
                viaLocation: nil,
                lastUsed: .distantPast
            ),
            .init(
                id: UUID(),
                fromLocation: .station(ModelStubs.kingsCrossStation),
                toLocation: .station(ModelStubs.eastFinchleyStation),
                viaLocation: .station(ModelStubs.angelStation),
                lastUsed: .distantPast
            ),
        ]
    )
}
