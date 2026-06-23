import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyResultsScreen: View {

    @Environment(AppDataStore.self) private var appData
    @Environment(AppRouter.self) private var router

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    private var sessionModeIDs: Set<ModeID> { userPreferences.journeyModePreset.modeIDs }

    var body: some View {
        @Bindable var journeyPlanner = appData.journeyPlanner
        JourneyResultsView(
            pages: $journeyPlanner.pages,
            fromLocation: $journeyPlanner.form.from,
            toLocation: $journeyPlanner.form.to,
            viaLocation: journeyPlanner.form.via,
            selectedPreset: $userPreferences.journeyModePreset,
            onAction: { handleAction($0) }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(L10n.journeyResultsNavigationTitle))
        .onChange(of: userPreferences.journeyModePreset) { _, newValue in
            guard !newValue.isCustom else { return }
            Task { await fetchInitialData() }
        }
    }

    private func handleAction(_ action: JourneyResultsAction) {
        switch action {
        case .initialFetch:
            guard !appData.journeyPlanner.hasFetchedInitialData else { return }
            Task { await fetchInitialData() }
        case .refresh:
            Task { await fetchInitialData() }
        case .earlierJourneys, .laterJourneys:
            Task { await appData.journeyPlanner.fetchAdjacentData(action: action, modeIDs: sessionModeIDs) }
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
                        Task { await fetchInitialData() }
                    }
                )
            )
        }
    }

    private func fetchInitialData() async {
        await appData.journeyPlanner.fetchInitialData(modeIDs: sessionModeIDs)
        saveRecentJourney()
    }

    private func saveRecentJourney() {
        if let savedJourney = appData.journeyPlanner.form.toNewSavedJourney() {
            userPreferences.saveRecentJourney(savedJourney)
        } else {
            assertionFailure("Failed to create a saved journey - results will be shown but not saved.")
        }
    }
}
