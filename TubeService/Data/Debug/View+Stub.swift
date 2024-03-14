import DataStores
import SwiftUI

#if DEBUG

extension View {
    
    @MainActor 
    func withStubbedEnvironment() -> some View {
        withEnvironmentDataStores(lineStatus: LineStatusDataStore.stub(),
                                  stations: StationsDataStore.stub(),
                                  userPreferences: UserPreferencesDataStore.stub(),
                                  location: LocationDataStore.stub(),
                                  localSearchCompleter: LocalSearchCompleter())
            .environment(\.transportAPI, StubTransportAPIClient())
            .environment(\.appConfig, AppConfig.stub)
    }
}

#endif
