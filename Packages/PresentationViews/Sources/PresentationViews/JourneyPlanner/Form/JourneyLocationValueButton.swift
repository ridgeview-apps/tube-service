import Models
import SwiftUI

public struct JourneyLocationValueButton: View {
    
    public enum AccessoryStatus {
        case warning
        case loadingState(LoadingState)
    }
    
    @Binding var value: JourneyLocationPicker.Value?
    var hasErrors: Bool = false
    var accessoryStatus: AccessoryStatus?
    let action: () -> Void
    
    public var body: some View {
        Button {
            action()
        } label: {
            locationValueLabel(for: value)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .font(.subheadline)
        .overlay(alignment: .trailing) {
            if value != nil {
                clearButton
            }
        }
    }
    
    @ViewBuilder
    private func locationValueLabel(for value: JourneyLocationPicker.Value?) -> some View {
        Group {
            if let value {
                JourneyLocationTitleLabel(value: value, accessoryStatus: accessoryStatus)
            } else {
                Text("journey.planner.location.button.select.location", bundle: .module)
            }
        }
        .foregroundStyle(hasErrors ? .adaptiveRed : .accentColor)
        .lineLimit(1)
        .padding(4)
    }
    
    private var clearButton: some View {
        Button {
            withAnimation {
                value = nil
            }
        } label: {
            Image(systemName: "multiply.circle.fill")
                .padding(.horizontal, 4)
                .frame(height: 44)
        }
        .foregroundStyle(.adaptiveDarkGrey1)
        .offset(x: 4, y: -18)
    }
}


// MARK: - Previews

private struct Previewer: View {
    
    let description: String
    var hasErrors = false
    @State var value: JourneyLocationPicker.Value? = .currentLocation(.unknown)
    var accessoryStatus: JourneyLocationValueButton.AccessoryStatus?
    var action: () -> Void = { print("Tapped") }
    
    var body: some View {
        HStack {
            Text(description)
            Spacer()
            JourneyLocationValueButton(value: $value,
                                       hasErrors: hasErrors,
                                       accessoryStatus: accessoryStatus,
                                       action: action)
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            Previewer(description: "Populated")
            Previewer(description: "Error", hasErrors: true)
            Previewer(description: "Location loading", accessoryStatus: .loadingState(.loading))
            Previewer(description: "Location warning", accessoryStatus: .warning)
            Previewer(description: "Location failure", accessoryStatus: .loadingState(.failure(errorMessage: "")))
            Previewer(description: "Deselected value", value: nil)
        }
        .padding(.horizontal)
    }
}
