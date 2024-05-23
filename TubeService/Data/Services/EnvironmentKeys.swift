import SwiftUI
import DataStores

// MARK: - TransportAPI environment key

private struct TransportAPIEnvironmentKey: EnvironmentKey {
    @MainActor
    static let defaultValue: TransportAPIClientType = AppDataStore.shared.transportAPI
}

extension EnvironmentValues {
  var transportAPI: TransportAPIClientType {
    get { self[TransportAPIEnvironmentKey.self] }
    set { self[TransportAPIEnvironmentKey.self] = newValue }
  }
}


// MARK: - AppEnvironment environment key

private struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppEnvironment = .shared
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
