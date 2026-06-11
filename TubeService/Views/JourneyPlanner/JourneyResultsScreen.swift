import DataStores
import Models
import PresentationViews
import SwiftUI

@MainActor
struct JourneyResultsScreen: View {

    @State private var model: JourneyResultsModel

    @Environment(LocalSearchResultsStore.self) var localSearchResults

    @AppStorage(
        UserDefaults.Keys.userPreferences.rawValue,
        store: AppDependencies.current.userDefaults.value
    )
    private var userPreferences: UserPreferences = .default

    @Binding var form: JourneyPlannerForm

    private var modeIDs: Set<ModeID> { userPreferences.journeyPlannerModeIDs }

    init(form: Binding<JourneyPlannerForm>, tflAPI: TflAPIClientType) {
        self._form = form
        self._model = State(initialValue: JourneyResultsModel(tflAPI: tflAPI))
    }

    var body: some View {
        JourneyResultsView(
            pages: $model.pages,
            fromLocation: $form.from,
            toLocation: $form.to,
            viaLocation: form.via,
            timeoption: form.timeSelection,
            onAction: { handleAction($0) }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(L10n.journeyResultsNavigationTitle))
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
        }
    }

    private func fetchInitialData() async {
        model.prepareForInitialFetch()

        do {
            form = try await localSearchResults.resolveLocationCoordinates(forForm: form)
            let requestParams = try form.toJourneyRequestParams(withModeIDs: modeIDs)
            await model.fetchInitialResults(requestParams: requestParams, modeIDs: modeIDs)
        } catch {
            model.setInitialPageError(error.toUIErrorMessage())
        }

        saveRecentJourney()
    }

    private func fetchAdjacentData(action: JourneyResultsAction) async {
        guard let requestParams = try? form.toJourneyRequestParams(withModeIDs: modeIDs) else { return }
        await model.fetchAdjacentResults(action: action, baseRequestParams: requestParams, modeIDs: modeIDs)
    }

    private func saveRecentJourney() {
        if let savedJourney = form.toNewSavedJourney() {
            userPreferences.saveRecentJourney(savedJourney)
        } else {
            assertionFailure("Failed to create a saved journey - results will be shown but not saved.")
        }
    }
}
