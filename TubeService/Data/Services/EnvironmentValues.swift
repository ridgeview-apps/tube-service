import SwiftUI
import DataStores

extension EnvironmentValues {
    @Entry var transportAPI: TransportAPIClientType = TransportAPIClient.shared
    @Entry var appConfig = AppConfig.shared
}
