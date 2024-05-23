import SwiftUI

extension View {
    
    func onCalendarDayChanged(action: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
            action()
        }
    }
}
