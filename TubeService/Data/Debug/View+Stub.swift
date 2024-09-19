import DataStores
import SwiftUI

#if DEBUG

extension View {
    
    @MainActor 
    func withStubbedEnvironment(transportAPI: StubTransportAPIClient = StubTransportAPIClient()) -> some View {
        let lineStatus = LineStatusDataStore.stub(transportAPI: transportAPI)
        let stations = StationsDataStore.stub(transportAPI: transportAPI)
        let location = LocationDataStore.stub(stations: stations)
        let localSearchCompleter = LocalSearchCompleter()
        
        return withEnvironmentDataStores(
            lineStatus: lineStatus,
            stations: stations,
            location: location,
            localSearchCompleter: localSearchCompleter
        )
        .environment(\.transportAPI, transportAPI)
        .environment(\.appConfig, AppConfig.stub)
    }
}

#endif
