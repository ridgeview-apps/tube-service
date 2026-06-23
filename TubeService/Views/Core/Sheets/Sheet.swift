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
    case tubeServicePlus(PaywallContext)
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


// MARK: - Actions

struct SheetAction {
    typealias Handler = (Sheet, (() -> Void)?) -> Void

    private let handler: Handler

    init(_ handler: @escaping Handler) {
        self.handler = handler
    }

    func callAsFunction(_ sheet: Sheet, onDismiss: (() -> Void)? = nil) {
        handler(sheet, onDismiss)
    }
}
