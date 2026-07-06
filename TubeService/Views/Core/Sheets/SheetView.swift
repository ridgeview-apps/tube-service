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
                .asModalScreen()
        case let .safari(url):
            SafariView(url: url)
        case let .journeyLocationPicker(config):
            JourneyLocationPickerScreen(config: config)
                .asModalScreen()
        case let .journeyModePicker(initialModeIDs, onDone):
            JourneyModePickerScreen(initialModeIDs: initialModeIDs, onDone: onDone)
        case let .tubeServicePlus(context, onAction):
            TubeServicePlusView(context: context, onAction: onAction)
                .asModalScreen()
        case let .notificationSettings(context, mode):
            NotificationsFlow(context: context, mode: mode)
        case let .lineNotificationSettings(lineID):
            LineNotificationSettingsScreen(lineID: lineID)
        }
    }
}
