import SwiftUI
import DataStores
import UIKit

struct OpenSettingsAction {
    @MainActor func callAsFunction() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

extension EnvironmentValues {
    @Entry var appConfig = AppConfig.main
    @Entry var showSheet: SheetAction = SheetAction { _, _ in }
    @Entry var openSettings = OpenSettingsAction()
}
