import Models
import SwiftUI

public struct SystemStatusBannerView: View {
    
    public enum Action {
        case tappedOK(SystemStatus)
        case tappedMoreInfo(SystemStatus)
    }
    
    public let systemStatus: SystemStatus
    public let onAction: (Action) -> Void
    @Binding var isShowing: Bool
    
    public init(
        systemStatus: SystemStatus,
        isShowing: Binding<Bool>,
        onAction: @escaping (Action) -> Void
    ) {
        self.systemStatus = systemStatus
        self._isShowing = isShowing
        self.onAction = onAction
    }
    
    public var body: some View {
        if isShowing {
            VStack(alignment: .leading, spacing: 8) {
                SystemStatusTitleView(systemStatus: systemStatus)
                VStack(alignment: .leading, spacing: 20) {
                    Text(systemStatus.formattedMessage)
                    actionButtons
                }
            }
            .withDefaultMaxWidth(alignment: .leading)
            .foregroundStyle(systemStatus.foregroundStyle)
            .padding(.horizontal)
            .padding(.bottom, 24)
            .background {
                systemStatus.tint.ignoresSafeArea()
            }
            .shadow(color: systemStatus.tint, radius: 4, y: 2)
            .opacity(0.96)
            .transition(
                .asymmetric(insertion: .slideDown, removal: .slideUp)
            )
        }
        
    }
    
    private var actionButtons: some View {
        HStack(spacing: 20) {
            if systemStatus.detail != nil {
                Button {
                    withAnimation {
                        isShowing = false
                        onAction(.tappedMoreInfo(systemStatus))
                    }
                } label: {
                    Text(.systemStatusBannerMoreInfoButtonTitle)
                }
            }
            Button {
                withAnimation {
                    isShowing = false
                    onAction(.tappedOK(systemStatus))
                }
            } label: {
                Text(.globalOK)
            }
        }
        .buttonStyle(.primary)
    }
}


// MARK: - Preview
import ModelStubs

#Preview("OK") {
    @Previewable @State var isShowing = true
    
    NavigationStack {
        Text("Preview").navigationTitle("Preview nav title")
    }
    .overlay(alignment: .top) {
        SystemStatusBannerView(
            systemStatus: ModelStubs.systemStatusOK,
            isShowing: $isShowing
        ) { _ in }
    }
}


#Preview("Outage") {
    @Previewable @State var isShowing = true
    
    NavigationStack {
        Text("Preview").navigationTitle("Preview nav title")
    }
    .overlay(alignment: .top) {
        SystemStatusBannerView(
            systemStatus: ModelStubs.systemStatusOutage,
            isShowing: $isShowing
        ) { _ in }
    }
}

#Preview("Resolved") {
    @Previewable @State var isShowing = true
    
    NavigationStack {
        Text("Preview").navigationTitle("Preview nav title")
    }
    .overlay(alignment: .top) {
        SystemStatusBannerView(
            systemStatus: ModelStubs.systemStatusResolved,
            isShowing: $isShowing
        ) { _ in }
    }
}
