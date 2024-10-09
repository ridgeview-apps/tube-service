import Models
import PresentationViews
import SwiftUI

// MARK: - Data types

enum Sheet {
    case systemStatusDetail(SystemStatus)
    case settings
    case safari(URL)
    case journeyLocationPicker(JourneyLocationPickerScreen.Config)
}

extension Sheet: Identifiable {
    enum ModalScreenID {
        case systemStatusDetail, settings, safari, journeyLocationPicker
    }
    
    var id: ModalScreenID {
        switch self {
        case .systemStatusDetail: .systemStatusDetail
        case .settings: .settings
        case .safari: .safari
        case .journeyLocationPicker: .journeyLocationPicker
        }
    }
}


// MARK: - View modifiers

struct SheetAction {
    typealias Action = (Sheet) -> Void
    let action: Action
    
    func callAsFunction(_ sheet: Sheet) {
        action(sheet)
    }
}


struct RootSheetPresenterModifier: ViewModifier {
    @State private var selectedSheet: Sheet?
    
    func body(content: Content) -> some View {
        content
            .environment(\.showSheet, SheetAction { sheet in
                selectedSheet = sheet
            })
            .sheet(item: $selectedSheet) { sheet in
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
