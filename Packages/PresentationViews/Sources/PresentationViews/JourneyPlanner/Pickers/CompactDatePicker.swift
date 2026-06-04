import Foundation
import SwiftUI
import UIKit

struct CompactDatePicker: UIViewRepresentable {
    @Binding var selection: Date
    var minimumDate: Date?
    var minuteInterval: Int

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.minuteInterval = minuteInterval
        picker.minimumDate = minimumDate
        picker.setContentHuggingPriority(.required, for: .horizontal)
        picker.setContentHuggingPriority(.required, for: .vertical)
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
        return picker
    }

    func updateUIView(_ picker: UIDatePicker, context: Context) {
        picker.date = selection
        picker.minimumDate = minimumDate
        picker.minuteInterval = minuteInterval
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection)
    }

    class Coordinator: NSObject {
        let selection: Binding<Date>

        init(selection: Binding<Date>) {
            self.selection = selection
        }

        @MainActor @objc func dateChanged(_ sender: UIDatePicker) {
            selection.wrappedValue = sender.date
        }
    }
}

#Preview {
    CompactDatePicker(
        selection: .constant(.now),
        minuteInterval: 5
    )
}
