import SwiftUI

public struct PagerButton: View {
    public let style: Style
    public let title: LocalizedStringResource
    public let action: () -> Void

    public enum Style {
        case up, down

        var systemImageName: String {
            switch self {
            case .up:
                "chevron.up"
            case .down:
                "chevron.down"
            }
        }
    }

    public init(
        style: Style,
        title: LocalizedStringResource,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Text(title)
                Image(systemName: style.systemImageName)
            }
        }
        .buttonStyle(.bordered)
        .font(.caption)
    }
}

#Preview("Up") {
    PagerButton(
        style: .up,
        title: "Earlier",
        action: {}
    )
    .padding()
}

#Preview("Down") {
    PagerButton(
        style: .down,
        title: "Later",
        action: {}
    )
    .padding()
}
