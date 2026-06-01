import SwiftUI
import DataStores

extension EnvironmentValues {
    @Entry var transportAPI: TransportAPIClientType = AppDependencies.current.transportAPI
    @Entry var appConfig = AppConfig.main
    @Entry var showSheet: SheetAction = SheetAction { _ in }
}
