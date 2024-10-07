import DataStores
import SwiftUI

#if DEBUG

extension View {
    
    @MainActor 
    func withStubbedEnvironment(
        transportAPI: StubTransportAPIClient = StubTransportAPIClient(),
        systemStatusAPI: StubSystemStatusAPIClient = StubSystemStatusAPIClient(),
        userDefaults: UserDefaults = .standard,
        locationManager: LocationManagerType = StubLocationManager(),
        localSearchCompleter: LocalSearchCompleter = .init(),
        now: @escaping () -> Date = { Date() }
    ) -> some View {
        
        let appData = AppDataStore(
            transportAPI: transportAPI,
            systemStatusAPI: systemStatusAPI,
            userDefaults: userDefaults,
            locationManager: locationManager,
            localSearchCompleter: localSearchCompleter,
            now: now
        )
        return
            withRootEnvironment(appData: appData)
                .environment(\.transportAPI, transportAPI)
                .environment(\.appConfig, AppConfig.stub)
    }
}

#endif
