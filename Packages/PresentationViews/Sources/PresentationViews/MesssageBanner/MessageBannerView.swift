import SwiftUI
import Models

public struct MessageBanner: Equatable, Identifiable {
    public enum Style {
        case info, warning, error
    }
    
    public var id: String { "" }
    public let style: Style
    public let message: LocalizedStringResource
    public let dismissAfter: Double
    
    public init(
        style: Style,
        message: LocalizedStringResource,
        dismissAfter: Double = 4.0
    ) {
        self.style = style
        self.message = message
        self.dismissAfter = dismissAfter
    }
}

public struct MessageBannerView: View {

    public let banner: MessageBanner
    public let onManualClose: () -> Void
    
    private let closeButtonSize = CGSize(width: 44, height: 44)
    private let defaultPadding: CGFloat = 12
    
    @State private var dragOffset: CGSize = .zero
    
    public init(
        banner: MessageBanner,
        onManualClose: @escaping () -> Void
    ) {
        self.banner = banner
        self.onManualClose = onManualClose
    }
    
    public var body: some View {
        Label {
            Text(banner.message)
                .font(.subheadline)
        } icon: {
            titleIcon
        }
        .padding(.vertical, defaultPadding)
        .padding(.leading, defaultPadding)
        .padding(.trailing, closeButtonSize.width)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(cornerRadius: 8)
        .overlay(alignment: .topTrailing) {
            closeButton
        }
        .padding(.horizontal)
        .transition(.asymmetric(insertion: .slideDown, removal: .slideUp))
        .offset(y: dragOffset.height)
        .gesture(dragGesture)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                withAnimation { dragOffset = gesture.translation }
            }
            .onEnded { _ in
                let swipedUpSufficiently = dragOffset.height < -20
                if swipedUpSufficiently {
                    close()
                } else {
                    withAnimation { dragOffset = .zero }
                }
            }
    }
    
    @ViewBuilder private var titleIcon: some View {
        switch banner.style {
        case .info:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        case .warning:
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)
        case .error:
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.adaptiveRed)
        }
    }
    
    private var closeButton: some View {
        Button {
            close()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .frame(width: closeButtonSize.width,
                       height: closeButtonSize.height)
        }
        .foregroundStyle(.secondary)
        .offset(x: 8, y: -8)
    }
    
    private func close() {
        withAnimation {
            onManualClose()
        }
    }
}

// MARK: - Previews

#Preview("Info") {
    MessageBannerView(
        banner: .init(
            style: .info,
            message: "Info message"
        ),
        onManualClose: { print("Manual close") }
    )
}

#Preview("Warning") {
    MessageBannerView(
        banner: .init(
            style: .warning,
            message: "Warning message"
        ),
        onManualClose: { print("Manual close") }
    )
}

#Preview("Error") {
    MessageBannerView(
        banner: .init(
            style: .error,
            message: "Error message"
        ),
        onManualClose: { print("Manual close") }
    )
}
