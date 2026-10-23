import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyResultsScreen: View {

    @Environment(JourneyPlannerStore.self) private var journeyPlanner
    @Environment(AppRouter.self) private var router

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    private var sessionModeIDs: Set<ModeID> { userPreferences.journeyModePreset.modeIDs }

    var body: some View {
        @Bindable var journeyPlanner = journeyPlanner
        JourneyResultsView(
            pages: journeyPlanner.pages,
            fromLocation: $journeyPlanner.form.from,
            toLocation: $journeyPlanner.form.to,
            viaLocation: journeyPlanner.form.via,
            selectedPreset: $userPreferences.journeyModePreset,
            errorFormatter: { $0.toUIErrorMessage() },
            onAction: { handleAction($0) }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(L10n.journeyResultsNavigationTitle))
        .onChange(of: userPreferences.journeyModePreset) { _, newValue in
            guard !newValue.isCustom else { return }
            Task { await loadJourneys() }
        }
    }

    private func handleAction(_ action: JourneyResultsAction) {
        switch action {
        case .initialFetch:
            guard !journeyPlanner.hasLoadedJourneys else { return }
            Task { await loadJourneys() }
        case .refresh:
            Task { await loadJourneys() }
        case .earlierJourneys:
            Task { await journeyPlanner.loadMoreJourneys(.earlierJourneys, modeIDs: sessionModeIDs) }
        case .laterJourneys:
            Task { await journeyPlanner.loadMoreJourneys(.laterJourneys, modeIDs: sessionModeIDs) }
        case .customPresetTapped:
            let seedModeIDs: Set<ModeID>
            if case .custom(let modeIDs) = userPreferences.journeyModePreset {
                seedModeIDs = modeIDs
            } else {
                seedModeIDs = JourneyModePreset.trainAndBus.modeIDs
            }
            router.showSheet(
                .journeyModePicker(
                    initialModeIDs: seedModeIDs,
                    onDone: { modeIDs in
                        userPreferences.journeyModePreset = .custom(modeIDs)
                        Task { await loadJourneys() }
                    }
                )
            )
        }
    }

    private func loadJourneys() async {
        await journeyPlanner.loadJourneys(modeIDs: sessionModeIDs)
        saveRecentJourney()
    }

    private func saveRecentJourney() {
        if let savedJourney = journeyPlanner.form.toNewSavedJourney() {
            userPreferences.saveRecentJourney(savedJourney)
        } else {
            assertionFailure("Failed to create a saved journey - results will be shown but not saved.")
        }
    }
}
