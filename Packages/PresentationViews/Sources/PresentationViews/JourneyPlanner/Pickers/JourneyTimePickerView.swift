import Foundation
import SwiftUI

private let timestampFormatter: DateFormatter = Formatter.relative(dateStyle: .medium,
                                                                   timeStyle: .short)

public struct JourneyTimePickerSelection: Hashable, Sendable {
    
    public enum Option: CaseIterable, Sendable {
        case leaveNow, leaveAt, arriveBy
        
        var title: LocalizedStringResource {
            switch self {
            case .leaveNow:
                    .journeyPlannerTimePickerOptionLeaveNow
            case .leaveAt:
                    .journeyPlannerTimePickerOptionLeaveLater
            case .arriveBy:
                    .journeyPlannerTimePickerOptionArriveBy
            }
        }
    }
    public var option: Option
    public var date: Date = .now
    
    var formattedDate: String {
        switch option {
        case .leaveNow:
            timestampFormatter.string(from: .now)
        case .leaveAt, .arriveBy:
            timestampFormatter.string(from: date)
        }
    }
    
    public static func leaveNow() -> JourneyTimePickerSelection { .init(option: .leaveNow) }
}

struct JourneyTimePickerView: View {
    
    @Binding var selection: JourneyTimePickerSelection

    @State private var revealDatePicker = false
    @State private var minimumDate: Date = .now
    
    var body: some View {
        VStack(alignment: .trailing) {
            Picker("", selection: $selection.option) {
                ForEach(JourneyTimePickerSelection.Option.allCases, id: \.self) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(.segmented)
            
            if revealDatePicker {
                DatePicker(selection: $selection.date,
                           in: minimumDate...) {
                    Text("", bundle: .module)
                }
                .labelsHidden()
            }
        }
        .onAppear {
            updateDatePickerVisibility()
        }
        .onChange(of: selection) {
            updateDatePickerVisibility()
        }
    }
    
    private func updateDatePickerVisibility() {
        withAnimation {
            switch selection.option {
            case .leaveNow:
                revealDatePicker = false
            case .leaveAt, .arriveBy:
                revealDatePicker = true
            }
        }
    }
}

private struct Previewer: View {
    @State var selection: JourneyTimePickerSelection = .leaveNow()
    
    var body: some View {
        JourneyTimePickerView(selection: $selection)
    }
}

#Preview("Other") {
    Previewer()
}
