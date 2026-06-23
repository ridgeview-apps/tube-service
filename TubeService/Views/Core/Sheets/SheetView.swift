import Models
import PresentationViews
import SwiftUI

struct SheetView: View {

    let sheet: Sheet

    var body: some View {
        switch sheet {
        case let .systemStatusDetail(status):
            SystemStatusDetailView(systemStatus: status)
                .asModalScreen()
        case .settings:
            SettingsScreen()
        case let .safari(url):
            SafariView(url: url)
        case let .journeyLocationPicker(config):
            JourneyLocationPickerScreen(config: config)
                .asModalScreen()
        case let .journeyModePicker(initialModeIDs, onDone):
            JourneyModePickerScreen(initialModeIDs: initialModeIDs, onDone: onDone)
        case let .tubeServicePlus(context, onAction):
            TubeServicePlusView(context: context, onAction: onAction)
        case let .notificationsOnboarding(entry):
            NotificationsFlow(entry: entry)
        }
    }
}
