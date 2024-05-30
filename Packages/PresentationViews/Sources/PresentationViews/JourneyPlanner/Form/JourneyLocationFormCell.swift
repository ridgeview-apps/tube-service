import Models
import SwiftUI

public struct JourneyLocationFormButton: View {
    
    enum Style {
        case normal, error
    }
    
    var style: Style = .normal
    @Binding var value: JourneyLocationPicker.Value?
    var accessoryStatus: JourneyLocationTitleLabel.AccessoryStatus?
    var placeholderText: LocalizedStringResource = .journeyPlannerLocationButtonSelectLocation
    let action: () -> Void
    
    public var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            HStack {
                locationValueLabel(for: value)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                
                if value != nil {
                    clearButton
                }
            }
            .font(.subheadline)
            .frame(height: 44)
            .padding(.leading, 8)
            .padding(.trailing, 4)
            .overlay(roundedBorder)
        }
        .buttonStyle(.plain)
        .lineLimit(1)
    }
    
    @ViewBuilder
    private var roundedBorder: some View {
        switch style {
        case .normal:
            RoundedRectangle(cornerRadius: 4)
                .stroke(lineWidth: 1.0)
                .fill(.tertiary)
        case .error:
            RoundedRectangle(cornerRadius: 4)
                .stroke(lineWidth: 1.0)
                .fill(.adaptiveRed)
        }
    }
    
    @ViewBuilder
    private func locationValueLabel(for value: JourneyLocationPicker.Value?) -> some View {
        Group {
            if let value {
                JourneyLocationTitleLabel(value: value, accessoryStatus: accessoryStatus)
                    .imageScale(.small)
            } else {
                HStack {
                    Text(placeholderText)
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }
    
    private var clearButton: some View {
        Button {
            value = nil
        } label: {
            Image(systemName: "multiply.circle.fill")
                .padding(4)
                .imageScale(.medium)
        }
        .foregroundStyle(.secondary)
    }
}


// MARK: - Previews

private struct Previewer: View {
    
    var style: JourneyLocationFormButton.Style = .normal
    let title: LocalizedStringResource
    @State var value: JourneyLocationPicker.Value? = .unknownCurrentLocation
    var accessoryStatus: JourneyLocationTitleLabel.AccessoryStatus?
    var action: () -> Void = { print("Tapped") }
    
    var body: some View {
        JourneyLocationFormButton(style: .normal,
                                  value: $value,
                                  accessoryStatus: accessoryStatus,
                                  action: action)
            .formDetailCell(title: title)
    }
}

#Preview {
    ScrollView {
        VStack {
            Previewer(title: "Populated")
            Previewer(title: "Location loading", accessoryStatus: .loadingState(.loading))
            Previewer(title: "Location warning", accessoryStatus: .warning)
            Previewer(title: "Location failure", accessoryStatus: .loadingState(.failure(errorMessage: "")))
            Previewer(title: "Deselected value", value: nil)
        }
        .padding(.horizontal)
    }
}
