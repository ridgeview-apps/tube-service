import DataClients
import SwiftUI

#if DEBUG

extension View {
    
    @MainActor func withStubbedEnvironment() -> some View {
        withEnvironmentObjects(lineStatus: LineStatusModel.stub(),
                               stations: StationsModel.stub(),
                               userPreferences: UserPreferencesModel.stub())
        .environment(\.transportAPI, StubTransportAPIClient())
        .environment(\.appConfig, AppConfig.stub)
    }
}

#endif
