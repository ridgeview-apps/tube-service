import Models
import PresentationViews
import SwiftUI

struct SheetView: View {

    let sheet: Sheet
    let onDismiss: (() -> Void)?

    var body: some View {
        switch sheet {
        case let .systemStatusDetail(status):
            SystemStatusDetailView(systemStatus: status)
                .defaultModalScreen(onTapClose: onDismiss)
        case .settings:
            SettingsScreen()
        case let .safari(url):
            SafariView(url: url)
        case let .journeyLocationPicker(config):
            JourneyLocationPickerScreen(config: config)
                .defaultModalScreen(onTapClose: onDismiss)
        case let .journeyModePicker(initialModeIDs, onDone):
            JourneyModePickerScreen(initialModeIDs: initialModeIDs, onDone: onDone)
        case .tubeServicePlus:
            NavigationStack {
                TubeServicePlusScreen(context: .statusHistory)
            }
        case let .notificationsOnboarding(preselectedLine):
            NotificationsOnboardingFlow(preselectedLine: preselectedLine)
        }
    }
}
