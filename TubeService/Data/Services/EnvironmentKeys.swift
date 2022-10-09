import SwiftUI
import DataClients

// MARK: - TransportAPI environment key

private struct TransportAPIEnvironmentKey: EnvironmentKey {
    static let defaultValue: TransportAPIClientType = DataClients.real.transportAPI
}

extension EnvironmentValues {
  var transportAPI: TransportAPIClientType {
    get { self[TransportAPIEnvironmentKey.self] }
    set { self[TransportAPIEnvironmentKey.self] = newValue }
  }
}


// MARK: - AppConfig environment key

private struct AppConfigEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppConfig = .real
}

extension EnvironmentValues {
    var appConfig: AppConfig {
        get { self[AppConfigEnvironmentKey.self] }
        set { self[AppConfigEnvironmentKey.self] = newValue }
    }
}
