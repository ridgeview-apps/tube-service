import SwiftUI
import DataStores

extension EnvironmentValues {
    @Entry var transportAPI: TransportAPIClientType = TransportAPIClient.live
    @Entry var appConfig = AppConfig.shared
    @Entry var showSheet: SheetAction = SheetAction { _ in }
}
