import DataStores
import SwiftUI

private struct AppRouteDestinationsModifier: ViewModifier {
    @Environment(AppDataStore.self) private var appData

    func body(content: Content) -> some View {
        content.navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .journeyResults:
                JourneyResultsScreen(tflAPI: appData.tflAPI)
            case .lineStatusDetail(let lineID, let request):
                LineStatusDetailScreen(lineID: lineID, request: request)
            case .lineStatusHistory(let lineID):
                LineStatusHistoryScreen(lineID: lineID)
            }
        }
    }
}

extension View {
    func appRouteDestinations() -> some View {
        modifier(AppRouteDestinationsModifier())
    }
}
