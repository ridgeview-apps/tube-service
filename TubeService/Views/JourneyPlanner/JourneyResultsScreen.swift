import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyResultsScreen: View {

    @State private var model: JourneyResultsModel

    @Environment(LocalSearchResultsStore.self) private var localSearchResults
    @Environment(AppRouter.self) private var router
    @Environment(JourneyPlannerSession.self) private var session

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    init(tflAPI: TflAPIClientType) {
        self._model = State(initialValue: JourneyResultsModel(tflAPI: tflAPI))
    }

    private var sessionModeIDs: Set<ModeID> { userPreferences.journeyModePreset.modeIDs }

    var body: some View {
        @Bindable var session = session
        JourneyResultsView(
            pages: $model.pages,
            fromLocation: $session.form.from,
            toLocation: $session.form.to,
            viaLocation: session.form.via,
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
            guard !model.hasFetchedInitialData else { return }
            Task { await fetchInitialData() }
        case .refresh:
            Task { await fetchInitialData() }
        case .earlierJourneys, .laterJourneys:
            Task { await fetchAdjacentData(action: action) }
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
        model.prepareForInitialFetch()

        do {
            session.form = try await localSearchResults.resolveLocationCoordinates(forForm: session.form)
            let requestParams = try session.form.toJourneyRequestParams(withModeIDs: sessionModeIDs)
            await model.fetchInitialResults(requestParams: requestParams, modeIDs: sessionModeIDs)
        } catch {
            model.setInitialPageError(error.toUIErrorMessage())
        }

        saveRecentJourney()
    }

    private func fetchAdjacentData(action: JourneyResultsAction) async {
        guard let requestParams = try? session.form.toJourneyRequestParams(withModeIDs: sessionModeIDs)
        else { return }
        await model.fetchAdjacentResults(
            action: action,
            baseRequestParams: requestParams,
            modeIDs: sessionModeIDs
        )
    }

    private func saveRecentJourney() {
        if let savedJourney = session.form.toNewSavedJourney() {
            userPreferences.saveRecentJourney(savedJourney)
        } else {
            assertionFailure("Failed to create a saved journey - results will be shown but not saved.")
        }
    }
}
