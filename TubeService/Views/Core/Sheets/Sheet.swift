import Models
import PresentationViews
import SwiftUI

// MARK: - Data types

enum Sheet {
    case systemStatusDetail(SystemStatus)
    case settings
    case safari(URL)
    case journeyLocationPicker(JourneyLocationPickerScreen.Config)
    case journeyModePicker(initialModeIDs: Set<ModeID>, onDone: (Set<ModeID>) -> Void)
    case tubeServicePlus(PaywallContext, onAction: (TubeServicePlusView.Action) -> Void)
    case notificationsOnboarding(NotificationsFlowEntry)
}

extension Sheet: Identifiable {
    enum ModalScreenID {
        case systemStatusDetail, settings, safari, journeyLocationPicker, journeyModePicker, tubeServicePlus, notificationsOnboarding
    }

    var id: ModalScreenID {
        switch self {
        case .systemStatusDetail: .systemStatusDetail
        case .settings: .settings
        case .safari: .safari
        case .journeyLocationPicker: .journeyLocationPicker
        case .journeyModePicker: .journeyModePicker
        case .tubeServicePlus: .tubeServicePlus
        case .notificationsOnboarding: .notificationsOnboarding
        }
    }
}
