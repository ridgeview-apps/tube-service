import DataStores
import SwiftUI

#if DEBUG

extension View {
    
    @MainActor 
    func withStubbedEnvironment(
        transportAPI: StubTransportAPIClient = StubTransportAPIClient(),
        systemStatusAPI: StubSystemStatusAPIClient = StubSystemStatusAPIClient()
    ) -> some View {
        let lineStatus = LineStatusDataStore.stub(transportAPI: transportAPI)
        let stations = StationsDataStore.stub(transportAPI: transportAPI)
        let location = LocationDataStore.stub(stations: stations)
        let localSearchCompleter = LocalSearchCompleter()
        let systemStatus = SystemStatusDataStore.stub(systemStatusAPI: systemStatusAPI)
        
        return withEnvironmentDataStores(
            lineStatus: lineStatus,
            stations: stations,
            location: location,
            localSearchCompleter: localSearchCompleter,
            systemStatus: systemStatus
        )
        .environment(\.transportAPI, transportAPI)
        .environment(\.appConfig, AppConfig.stub)
    }
}

#endif
