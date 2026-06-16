import Models
import PresentationViews
import SwiftUI

// MARK: - Data types

enum Sheet {
    case systemStatusDetail(SystemStatus)
    case settings
    case safari(URL)
    case journeyLocationPicker(JourneyLocationPickerScreen.Config)
    case lineStatusHistoryUpsell(TrainLineID)
}

extension Sheet: Identifiable {
    enum ModalScreenID {
        case systemStatusDetail, settings, safari, journeyLocationPicker, lineStatusHistoryUpsell
    }

    var id: ModalScreenID {
        switch self {
        case .systemStatusDetail: .systemStatusDetail
        case .settings: .settings
        case .safari: .safari
        case .journeyLocationPicker: .journeyLocationPicker
        case .lineStatusHistoryUpsell: .lineStatusHistoryUpsell
        }
    }
}


// MARK: - View modifiers

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


struct RootSheetPresenterModifier: ViewModifier {
    @State private var selectedSheet: Sheet?
    @State private var onDismissCallback: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .environment(
                \.showSheet,
                SheetAction { sheet, onDismiss in
                    selectedSheet = sheet
                    onDismissCallback = onDismiss
                }
            )
            .sheet(
                item: $selectedSheet,
                onDismiss: {
                    onDismissCallback?()
                    onDismissCallback = nil
                }
            ) { sheet in
                SheetView(sheet: sheet) {
                    selectedSheet = nil
                }
            }
    }
}

extension View {
    func rootSheetPresenter() -> some View {
        modifier(RootSheetPresenterModifier())
    }
}
