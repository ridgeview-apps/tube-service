import Models
import SwiftUI

public struct PrimaryActionButtonStyle: ButtonStyle {

    var tint: Color = .accentColor

    @Environment(\.isEnabled) var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.subheadline.weight(.semibold))
            .withDefaultMaxWidth()
            .frame(minHeight: 48)
            .padding(.horizontal, 18)
            .background(
                tint.opacity(isEnabled ? 0.12 : 0.06),
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .strokeBorder(tint.opacity(isEnabled ? 0.18 : 0.08), lineWidth: 1)
            }
            .foregroundStyle(isEnabled ? tint : .secondary)
            .opacity(configuration.isPressed ? 0.82 : 1)
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: PrimaryActionButtonStyle (syntactic sugar)

public extension ButtonStyle where Self == PrimaryActionButtonStyle {
    static var primary: PrimaryActionButtonStyle { PrimaryActionButtonStyle() }
    static func primary(tint: Color) -> PrimaryActionButtonStyle { PrimaryActionButtonStyle(tint: tint) }
}

// MARK: - LineActionButtonStyle

public struct LineActionButtonStyle: ButtonStyle {

    let lineID: TrainLineID

    @Environment(\.isEnabled) var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.subheadline.weight(.semibold))
            .withDefaultMaxWidth()
            .frame(minHeight: 48)
            .padding(.horizontal, 18)
            .foregroundStyle(isEnabled ? lineID.textColor : Color.secondary)
            .background(
                lineID.backgroundColor.opacity(isEnabled ? 1 : 0.15),
                in: Capsule()
            )
            .opacity(configuration.isPressed ? 0.82 : 1)
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == LineActionButtonStyle {
    static func line(_ lineID: TrainLineID) -> LineActionButtonStyle {
        LineActionButtonStyle(lineID: lineID)
    }
}

#Preview("Primary button") {
    VStack {
        Button("Standard") {}
        Button("Disabled") {}.disabled(true)
    }
    .buttonStyle(.primary)
    .padding()
}

#Preview("Line button") {
    ScrollView {
        VStack {
            ForEach(TrainLineID.allCases, id: \.self) { lineID in
                Button(lineID.name) {}
                    .buttonStyle(.line(lineID))
            }
            Divider()
            ForEach(TrainLineID.allCases, id: \.self) { lineID in
                Button(lineID.name) {}
                    .buttonStyle(.line(lineID))
                    .disabled(true)
            }
        }
        .padding()
    }
}
