import Shared
import SwiftUI
import Models

public struct LocationUIStatus {
    public enum Style: Hashable {
        case setUp(showsHeader: Bool)
        case openSettingsToAllowLocation
        case locationAllowed(LoadingState)
    }
    
    public let style: Style
    public let horizontalPadding: CGFloat
    public let onRequestPermissions: () -> Void
    
    public init(style: Style,
                horizontalPadding: CGFloat = 16,
                onRequestPermissions: @escaping () -> Void) {
        self.style = style
        self.onRequestPermissions = onRequestPermissions
        self.horizontalPadding = horizontalPadding
    }
    
    var loadingState: LoadingState? {
        switch style {
        case .setUp, .openSettingsToAllowLocation:
            return nil
        case let .locationAllowed(loadingState):
            return loadingState
        }
    }
}

public struct LocationUIStatusViewModifier: ViewModifier {
    public let status: LocationUIStatus
    
    public func body(content: Content) -> some View {
        switch status.style {
        case let .setUp(showsHeader):
            initialSetupView(showsHeader: showsHeader)
        case .openSettingsToAllowLocation:
            permissionDeniedView
        case .locationAllowed:
            content
        }
    }
    
    @ViewBuilder
    private func initialSetupView(showsHeader: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if showsHeader {
                Text(.locationServicesAllowAccessHeaderTitle)
            }
            Button {
                status.onRequestPermissions()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .imageScale(.small)
                    Text(.locationServicesAllowAccessButtonTitle)
                }
            }
            .buttonStyle(.primary)
            Text(.locationServicesAllowAccessFooterTitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, status.horizontalPadding)
    }
    
    private var permissionDeniedView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                    .imageScale(.large)
                Text(.locationServicesAccessDeniedMessageTitle)
            }
            OpenSettingsButton()
                .buttonStyle(.primary)
        }
        .padding(.horizontal, status.horizontalPadding)
    }
}

public extension View {
    
    func locationUIStatus(_ status: LocationUIStatus) -> some View {
        modifier(LocationUIStatusViewModifier(status: status))
    }
}


// MARK: - Previews

private struct Previewer: View {
    var style: LocationUIStatus.Style
    var onRequestPermissions: () -> Void = { print("Permissions requested") }

    var body: some View {
        Text("Permissions granted view")
            .locationUIStatus(.init(style: style,
                                    onRequestPermissions: onRequestPermissions))
    }
}


#Preview("Setup (header)") {
    Previewer(style: .setUp(showsHeader: true))
}

#Preview("Setup (no header)") {
    Previewer(style: .setUp(showsHeader: false))
}

#Preview("Permission denied") {
    Previewer(style: .openSettingsToAllowLocation)
}

#Preview("Permission granted") {
    Previewer(style: .locationAllowed(.loaded))
}
