import SwiftUI

public struct CheckmarkToggleStyle: ToggleStyle {

    var tint: Color
    var onSymbol: String = "checkmark.circle.fill"
    var offSymbol: String = "circle"

    public func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                configuration.label
                Spacer(minLength: 8)
                Image(systemName: configuration.isOn ? onSymbol : offSymbol)
                    .foregroundStyle(configuration.isOn ? tint : .secondary)
                    .font(.system(size: 22))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: CheckmarkToggleStyle (syntactic sugar)

public extension ToggleStyle where Self == CheckmarkToggleStyle {
    static func checkmark(tint: Color) -> CheckmarkToggleStyle {
        CheckmarkToggleStyle(tint: tint)
    }

    static func checkmarkSquare(tint: Color) -> CheckmarkToggleStyle {
        CheckmarkToggleStyle(tint: tint, onSymbol: "checkmark.square.fill", offSymbol: "square")
    }
}

#Preview("Checkmark toggle") {
    VStack(alignment: .leading, spacing: 16) {
        Toggle(isOn: .constant(true)) {
            Text("Recovery alerts")
        }
        .toggleStyle(.checkmark(tint: .blue))
        Toggle(isOn: .constant(false)) {
            Text("Recovery alerts")
        }
        .toggleStyle(.checkmark(tint: .blue))
    }
    .padding()
}
