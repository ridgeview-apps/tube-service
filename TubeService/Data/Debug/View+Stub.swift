import DataStores
import SwiftUI

#if DEBUG

extension View {
    
    @MainActor 
    func withStubbedEnvironment(
        transportAPI: StubTransportAPIClient = StubTransportAPIClient(),
        systemStatusAPI: StubSystemStatusAPIClient = StubSystemStatusAPIClient(),
        userDefaults: UserDefaults = UserDefaults(suiteName: "StubSuite")!,
        locationManager: LocationManagerType = StubLocationManager(),
        localSearchCompleterClient: LocalSearchCompleterClientType = StubLocalSearchCompleterClient(),
        now: @escaping @Sendable () -> Date = { Date() }
    ) -> some View {
        
        let dependencies = AppDependencies(
            transportAPI: transportAPI,
            systemStatusAPI: systemStatusAPI,
            locationManager: locationManager,
            localSearchCompleterClient: localSearchCompleterClient,
            userDefaults: UserDefaultsProvider(userDefaults),
            now: now
        )
        
        let appData = AppDataStore(
            dependencies: dependencies
        )
        return
            withRootEnvironment(appData: appData)
                .environment(\.transportAPI, transportAPI)
    }
}

#endif
